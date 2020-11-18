//
//  PhaseHelper.swift
//  SOB
//
//  Created by Ketan Parekh on 17/11/20.
//

import Foundation
class PhaseHelper{
    static func getPhase(caseCount : Double) -> [String:String] {
        if(caseCount < 35){
            return ["Phase" : "GreenPhase", "PhaseColor" : "GreenColor", "PhaseRules" : "GreenRules"]
        } else if(caseCount > 35 && caseCount < 50){
            return ["Phase" : "YellowPhase", "PhaseColor" : "YellowColor", "PhaseRules" : "YellowRules"]
        } else {
            return ["Phase" : "RedPhase", "PhaseColor" : "RedColor", "PhaseRules" : "RedRules"]
        } 
    }
    static func getPhaseName(caseCount : Double) -> String {
        if(caseCount < 35){
            return "GreenPhase"
        } else if(caseCount > 35 && caseCount < 50){
            return "YellowPhase"
        } else {
            return "RedPhase"
        }
    }
}
