//
//  APIHelper.swift
//  SOB
//
//  Created by Ketan Parekh on 17/11/20.
//

import Foundation
import CoreLocation
import Alamofire
enum ReposneError : Error {
        case invalidRepsonse
        case internalError
    }

class APIHelper{
    static func getCaseCounts(latitude: Double, longitude: Double, completion: @escaping (Swift.Result<Double, Error>) -> Void) {
        //let location = CLLocation(latitude: 48.7904, longitude: 11.4979)
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let urlString : String = String(format: Constants.Common.baseURL, location.coordinate.longitude ,location.coordinate.latitude)
        
        AF.request(urlString).responseDecodable(of: NPGEOCoronaResponse.self) { response in
            guard let cases7Per100K = response.value?.features[0].attributes.cases7Per100K else {
                completion(.failure(ReposneError.invalidRepsonse))
                return
            }
            let defaults = UserDefaults.standard
            let date = String(DateFormatter.localizedString(from: NSDate() as Date, dateStyle: .short, timeStyle: .short))
            defaults.set(cases7Per100K, forKey: Constants.Common.savedCases7Per100K)
            defaults.set(date, forKey: Constants.Common.lastUpdated)
            defaults.synchronize()
            completion(.success(cases7Per100K))
        }
    }
}
