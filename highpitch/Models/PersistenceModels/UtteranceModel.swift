//
//  UtteranceModel.swift
//  highpitch
//
//  Created by 이재혁 on 10/17/23.
//

import Foundation
import SwiftData

@Model
class UtteranceModel: Comparable {
    var startAt: Int
    var duration: Int
    var message: String
    var temp: String = "12"
    
    init(startAt: Int, duration: Int, message: String) {
        self.startAt = startAt
        self.duration = duration
        self.message = message
    }
    
    static func < (lhs: UtteranceModel, rhs: UtteranceModel) -> Bool {
        return lhs.startAt < rhs.startAt
    }

    static func == (lhs: UtteranceModel, rhs: UtteranceModel) -> Bool {
        return lhs.startAt == rhs.startAt
    }
}
