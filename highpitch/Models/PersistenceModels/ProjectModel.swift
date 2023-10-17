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
