//
//  NPGEOCoronaResponse.swift
//  SOB
//
//  Created by Ketan Parekh on 13/11/20.
//

import Foundation

// MARK: - NPGEOCoronaResponse
struct NPGEOCoronaResponse: Codable {
    let objectIDFieldName: String
    let uniqueIDField: UniqueIDField
    let globalIDFieldName: String
    let geometryProperties: GeometryProperties
    let geometryType: String
    let spatialReference: SpatialReference
    let fields: [Field]
    let features: [Feature]
    
    enum CodingKeys: String, CodingKey {
        case objectIDFieldName = "objectIdFieldName"
        case uniqueIDField = "uniqueIdField"
        case globalIDFieldName = "globalIdFieldName"
        case geometryProperties, geometryType, spatialReference, fields, features
    }
}

// MARK: - Feature
struct Feature: Codable {
    let attributes: Attributes
}

// MARK: - Attributes
struct Attributes: Codable {
    let objectid: Int
    let county: String
    let cases7Per100K, cases7BlPer100K, shapeArea, casesPer100K: Double
    let casesPerPopulation: Double
    let lastUpdate: String
    
    enum CodingKeys: String, CodingKey {
        case objectid = "OBJECTID"
        case county
        case cases7Per100K = "cases7_per_100k"
        case cases7BlPer100K = "cases7_bl_per_100k"
        case shapeArea = "Shape__Area"
        case casesPer100K = "cases_per_100k"
        case casesPerPopulation = "cases_per_population"
        case lastUpdate = "last_update"
    }
}

// MARK: - Field
struct Field: Codable {
    let name, type, alias, sqlType: String
    let domain, defaultValue: JSONNull?
    let length: Int?
}

// MARK: - GeometryProperties
struct GeometryProperties: Codable {
    let shapeAreaFieldName, shapeLengthFieldName, units: String
}

// MARK: - SpatialReference
struct SpatialReference: Codable {
    let wkid, latestWkid: Int
}

// MARK: - UniqueIDField
struct UniqueIDField: Codable {
    let name: String
    let isSystemMaintained: Bool
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {
    
    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }
    
    public var hashValue: Int {
        return 0
    }
    
    public func hash(into hasher: inout Hasher) {
        // No-op
    }
    
    public init() {}
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
