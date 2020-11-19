//
//  AppDelegate.swift
//  SOB
//
//  Created by Ketan Parekh on 13/11/20.
//

import UIKit
import BackgroundTasks

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var bgtimer = Timer()
    var backgroundUpdateTask: UIBackgroundTaskIdentifier!
    let defaults = UserDefaults.standard
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        registerLocalNotification()
        registerBackgroundTaks()
        if UIApplication.shared.backgroundRefreshStatus == .available {
            if ((launchOptions?[UIApplication.LaunchOptionsKey.location]) != nil){
                SOBLocationManager.shared().startMonitoringLocation()
            }
        }
        return true
    }
    func applicationWillTerminate(_ application: UIApplication) {
        scheduleAppRefresh()
        SOBLocationManager.shared().restartMonitoringLocation()
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
    //MARK: Register BackGround Tasks
    
    private func registerBackgroundTaks() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.ketan.sob.bgrefresh", using: nil) { task in
            self.handleAppRefresh(task: task as! BGAppRefreshTask)
        }
    }
}

//MARK:- BGTask Helper
extension AppDelegate {
    func cancelAllPandingBGTask() {
        BGTaskScheduler.shared.cancelAllTaskRequests()
    }
    func getCaseCountsUpdateUserIfChanged(){
        
        APIHelper.getCaseCounts (latitude: defaults.double(forKey: Constants.Common.lastLocationLatitude), longitude: defaults.double(forKey: Constants.Common.lastLocationLongitude), completion: {
            [weak self] NPGEOCoronaResult in
            switch NPGEOCoronaResult {
            case .failure:
                ErrorPresenter.showError(message: NSLocalizedString("ResponseError", comment: ""), on: self?.window?.rootViewController)
            case .success(let caseCounts):
                // Check if Store count and current count hase same phase or not
                let defaults = UserDefaults.standard
                let lastUpdatedValue = defaults.double(forKey: Constants.Common.lastUpdated)
                let storedPhaseName = PhaseHelper.getPhaseName(caseCount: lastUpdatedValue)
                let phaseName = PhaseHelper.getPhaseName(caseCount: caseCounts)
                if(storedPhaseName != phaseName) {
                    self?.scheduleLocalNotification(title: NSLocalizedString(phaseName, comment: "") , message: String(format: NSLocalizedString("You are in %@.", comment: ""), NSLocalizedString(phaseName, comment: "")));
                }
            }
        })
        
        
    }
    func handleAppRefresh(task: BGAppRefreshTask) {
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 1
        
        let refreshOperation = BlockOperation {
            self.getCaseCountsUpdateUserIfChanged()
            print("Refresh executed")
        }
        
        refreshOperation.completionBlock = {
            task.setTaskCompleted(success: !refreshOperation.isCancelled)
        }
        operationQueue.addOperation(refreshOperation)
        
        task.expirationHandler = {
            task.setTaskCompleted(success: false)
            operationQueue.cancelAllOperations()
        }
        scheduleAppRefresh()
        
    }
    func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: "com.ketan.sob.bgrefresh")
        request.earliestBeginDate =  Date(timeIntervalSinceNow: 10 * 60) // App Refresh after 10 minute.
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule app refresh: \(error)")
        }
    }
}

//MARK:- Notification Helper
extension AppDelegate {
    func registerLocalNotification() {
        let notificationCenter = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        notificationCenter.requestAuthorization(options: options) {
            (didAllow, error) in
            if !didAllow {
                print("User has declined notifications")
            }
        }
    }
    func scheduleLocalNotification(title: String, message: String) {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                self.fireNotification(title: title, message: message)
            }
        }
    }
    func fireNotification(title: String, message: String) {
        // Create Notification Content
        let notificationContent = UNMutableNotificationContent()
        // Configure Notification Content
        notificationContent.title = title
        notificationContent.body = message
        notificationContent.badge = 1
        // Add Trigger
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 1.0, repeats: false)
        
        // Create Notification Request
        let notificationRequest = UNNotificationRequest(identifier: "local_notification", content: notificationContent, trigger: notificationTrigger)
        
        // Add Request to User Notification Center
        UNUserNotificationCenter.current().add(notificationRequest) { (error) in
            if let error = error {
                print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
            }
        }
    }
}
