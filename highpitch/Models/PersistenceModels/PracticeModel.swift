//
//  PracticeModel.swift
//  highpitch
//
//  Created by 이재혁 on 10/17/23.
//

import Foundation
import SwiftData

@Model
class PracticeModel {
    var practiceName: String
    var creatAt: String
    var audioPath: URL?
    @Relationship(deleteRule: .cascade) var utterances: [UtteranceModel]
    
    init(practiceName: String, creatAt: String, audioPath: URL? = nil, utterances: [UtteranceModel]) {
        self.practiceName = practiceName
        self.creatAt = creatAt
        self.audioPath = audioPath
        self.utterances = utterances
    }
}
