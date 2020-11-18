//
//  Constants.swift
//  SOB
//
//  Created by Ketan Parekh on 14/11/20.
//

import Foundation
class Constants {
    struct Common {
        static let savedCases7Per100K = "savedCases7Per100K"
        static let lastUpdated = "lastUpdated"
        static let lastLocationLatitude = "lastLocationLatitude"
        static let lastLocationLongitude = "lastLocationLongitude"
        static let baseURL = "https://services7.arcgis.com/mOBPykOjAyBO2ZKk/arcgis/rest/services/RKI_Landkreisdaten/FeatureServer/0/query?where=1=1&outFields=OBJECTID,county,cases7_per_100k,cases7_bl_per_100k,Shape__Area,cases_per_100k,cases_per_population,last_update&geometry=%.4f,%.4f&geometryType=esriGeometryPoint&inSR=4326&spatialRel=esriSpatialRelWithin&returnGeometry=false&outSR=4326&f=json"
    }
}
