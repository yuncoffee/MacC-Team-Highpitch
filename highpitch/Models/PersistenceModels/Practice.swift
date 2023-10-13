//
//  PracticeModel.swift
//  highpitch
//
//  Created by yuncoffee on 10/12/23.
//

import Foundation
import SwiftData

@Model
final class Practice {
    var audioPath: URL
    var utterences: [Utterence]
    
    init(audioPath: URL, utterences: [Utterence]) {
        self.audioPath = audioPath
        self.utterences = utterences
    }
}
