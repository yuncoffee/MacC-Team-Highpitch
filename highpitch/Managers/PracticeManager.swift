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
    var practices: [PracticeModel]?
    var current: PracticeModel?
}

extension PracticeManager {
    func getPracticeDetail() {
        var fillerWordList = FillerWordList().defaultList
        var utterances = current?.utterances
    }
}
