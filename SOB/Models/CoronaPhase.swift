//
//  CoronaPhase.swift
//  SOB
//
//  Created by Ketan Parekh on 16/11/20.
//

import Foundation

// MARK: - CoronaPhase

struct CoronaPhase: Codable {
    let objectIDFieldName: String

    enum CodingKeys: String, CodingKey {
        case objectIDFieldName = "objectIdFieldName"
    }
}

