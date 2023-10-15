//
//  HPProject.swift
//  highpitch
//
//  Created by yuncoffee on 10/12/23.
//

import Foundation
import SwiftData

@Model
final class ProjectModel {
    var projectName: String
    var creatAt: String
    var keynotePath: URL?
    var practices: [Practice]
    var keynoteCreation: String
        
    init(
        projectName: String,
        creatAt: String,
        keynotePath: URL? = nil,
        practices: [Practice],
        keynoteCreation: String
    ) {
        self.projectName = projectName
        self.creatAt = creatAt
        self.keynotePath = keynotePath
        self.practices = practices
        self.keynoteCreation = keynoteCreation
    }
}
