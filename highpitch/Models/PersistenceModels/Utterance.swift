//
//  UtterenceModel.swift
//  highpitch
//
//  Created by yuncoffee on 10/12/23.
//

import Foundation
import SwiftData

@Model
final class Utterance {
    var startAt: Int
    var duration: Int
    var message: String
    
    init(startAt: Int, duration: Int, message: String) {
        self.startAt = startAt
        self.duration = duration
        self.message = message
    }
}
