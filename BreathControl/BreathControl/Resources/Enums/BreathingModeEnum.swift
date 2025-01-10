//
//  BreathingModeEnum.swift
//  BreathControl
//
//  Created by Panagiotis Theodosiadis on 8/1/25.
//

import Foundation

enum BreathingModeEnum: String, CaseIterable {
    
    case boxBreathing = "Box Breathing" // 4 - 4 - 4
    case relaxation = "Relaxation" // 5 - 3 - 5
    case breathing478 = "4-7-8 Breathing" // 4 - 7 - 8
    
    // MARK: - Methods
    
    func breathingTimes() -> [Double] {
        switch self {
        case .boxBreathing:
            return [4,4,4]
        case .relaxation:
            return [5,3,5]
        case .breathing478:
            return [4,7,8]
        }
    }

}
