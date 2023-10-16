//
//  Project.swift
//  highpitch
//
//  Created by yuncoffee on 10/15/23.
//

import Foundation

struct Project {
    let id = UUID()
    var projectName: String
    var creatAt: String
    var keynotePath: URL?
    var practices: [Practice]
    var keynoteCreation: String
}

extension Project: Equatable {}
extension Project: Hashable {}
extension Project {
    init() {
        self.init(
            projectName: "새 프로젝트",
            creatAt: "--임시--",
            practices: [],
            keynoteCreation: "--임시--"
        )
    }
}
