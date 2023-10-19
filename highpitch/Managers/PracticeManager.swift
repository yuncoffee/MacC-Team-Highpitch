//
//  PracticeManager.swift
//  highpitch
//
//  Created by yuncoffee on 10/19/23.
//

import Foundation

enum PracticeLevel {
    case level1
    case level2
    case level3
    case level4
    case level5
}

@Observable
final class PracticeManager {
    var current: [PracticeModel]?
    
    func getLevel() -> PracticeLevel {
        PracticeLevel.level1
    }
}

extension PracticeManager {
    private func calcSpeedRate(accEPMs: Double) {
        let average = accEPMs / Double(current?.count ?? 1)
        let standard = (min: 336, max: 377)
    }
    
    private func calcFillerWordRate(accEPMs: Double) {
        
    }
}
