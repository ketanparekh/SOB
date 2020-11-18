//
//  ViewController.swift
//  SOB
//
//  Created by Ketan Parekh on 13/11/20.
//

import UIKit
import Alamofire
import CoreLocation
class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var appDelegate = UIApplication.shared.delegate as? AppDelegate
    @IBOutlet weak var welcomeText: UILabel?
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var phaseText: UILabel?
    @IBOutlet weak var lastSeenText: UILabel?
    @IBOutlet weak var rulesTitleText: UILabel?
    @IBOutlet weak var rulesText: UITextView?
    
    let defaults = UserDefaults.standard
    
    //MARK:- Class Methods
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set Previously stored Data
        setDisplayData(caseCounts: defaults.double(forKey: Constants.Common.savedCases7Per100K))
        // 1 & 2 Get Location, 2 Call API
        getLocationAndAPI()
    }
    
    //MARK:- UI Updates Method
    func setDisplayData(caseCounts: Double) {
        let phaseDict = PhaseHelper.getPhase(caseCount: caseCounts)
        let phaseColor: UIColor = UIColor(named: phaseDict["PhaseColor"]!)!
        let phase : String = phaseDict["Phase"]!
        let phaseRules = phaseDict["PhaseRules"]
        
        setGradientBackground(colorTop: UIColor.white, colorBottom: phaseColor)
        
        circleView.backgroundColor = phaseColor
        circleView.layer.cornerRadius = circleView.frame.size.width/2
        circleView.clipsToBounds = true
        circleView.layer.borderColor = UIColor.clear.cgColor
        circleView.layer.borderWidth = 5.0
        
        phaseText?.text = String(format: NSLocalizedString("You are in %@ phase.", comment: ""), phase)
        let lastUpdated = NSLocalizedString("LastUpdated", comment: "")
        
        let lastUpdatedValue = defaults.string(forKey: Constants.Common.lastUpdated)
        lastSeenText?.text = lastUpdatedValue != nil ? (lastUpdated + lastUpdatedValue!) : ""
        rulesTitleText?.text = NSLocalizedString("Rules", comment: "")
        rulesText?.text = NSLocalizedString(phaseRules!, comment: "")
    }
    func setGradientBackground(colorTop: UIColor, colorBottom: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorBottom.cgColor, colorTop.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = self.view.bounds
        gradientLayer.name = "gradientLayer"
        for layer in self.view.layer.sublayers! {
            if layer.isKind(of: CAGradientLayer.self) {
                layer.removeFromSuperlayer()
            }
        }
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    @IBAction func refreshPhase(sender: UIButton) {
        // 5 Refresh should repeat Step 1 to 4
        getLocationAndAPI()
    }
    
    //MARK:- Location and API Methods
    func getLocationAndAPI(){
        APIHelper.getCaseCounts (latitude: defaults.double(forKey: Constants.Common.lastLocationLatitude), longitude: defaults.double(forKey: Constants.Common.lastLocationLongitude), completion: {
            [weak self] NPGEOCoronaResult in
            switch NPGEOCoronaResult {
            case .failure:
                ErrorPresenter.showError(message: NSLocalizedString("ResponseError", comment: ""), on: self)
            case .success(let caseCounts):
                // 4 Update UI - Color, Rules and Last Updated
                self?.setDisplayData(caseCounts: caseCounts)
            }
        })
        
    }
    
}
