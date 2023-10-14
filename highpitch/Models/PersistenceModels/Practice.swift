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
    var utterances: [Utterance]
    
    init(audioPath: URL, utterances: [Utterance]) {
        self.audioPath = audioPath
        self.utterances = utterances
    }
}
