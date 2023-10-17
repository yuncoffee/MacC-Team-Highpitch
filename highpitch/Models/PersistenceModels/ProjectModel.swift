//
//  HPProject.swift
//  highpitch
//
//  Created by yuncoffee on 10/12/23.
//

import Foundation
import SwiftData

@Model
class ProjectModel {
    var projectName: String
    var creatAt: String
    var keynotePath: URL?
    var keynoteCreation: String
    @Relationship(deleteRule: .cascade) var practices = [PracticeModel]()
    
    init(projectName: String, creatAt: String, keynotePath: URL? = nil, keynoteCreation: String) {
        self.projectName = projectName
        self.creatAt = creatAt
        self.keynotePath = keynotePath
        self.keynoteCreation = keynoteCreation
    }
}

@Model
class PracticeModel {
    var practiceName: String
    var creatAt: String
    var audioPath: URL?
    @Relationship(deleteRule: .cascade) var utterances = [UtteranceModel]()
    
    init(practiceName: String, creatAt: String, audioPath: URL? = nil) {
        self.practiceName = practiceName
        self.creatAt = creatAt
        self.audioPath = audioPath
    }
}

@Model
class UtteranceModel {
    var startAt: Int
    var duration: Int
    var message: String
        
    init(startAt: Int, duration: Int, message: String) {
        self.startAt = startAt
        self.duration = duration
        self.message = message
    }
}
