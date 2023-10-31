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
    var keynoteCreation: String // 키노트 파일에서 생성일을 조회해서 넣어줌 스트링으로.  FileSystemManager에 있는 getCreationMetadata함수에 path를 전달하면 keynoteCreation 반환해줌.
    @Relationship(deleteRule: .cascade) 
    var practices = [PracticeModel]()
    
    init(projectName: String, creatAt: String, keynotePath: URL? = nil, keynoteCreation: String) {
        self.projectName = projectName
        self.creatAt = creatAt
        self.keynotePath = keynotePath
        self.keynoteCreation = keynoteCreation
    }
}
