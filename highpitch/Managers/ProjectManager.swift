//
//  ProjectManager.swift
//  highpitch
//
//  Created by yuncoffee on 10/14/23.
//

import Foundation
import SwiftUI
import SwiftData

@Observable
final class ProjectManager {
    // MARK: - 임시 샘플 프로젝트들 저장
    var projects: [ProjectModel]?
    var current: ProjectModel? {
        didSet {
            self.practiceManager.practices = current?.practices
        }
    }
    var temp: PersistentIdentifier?
    var currentTabItem = 1
    var path: NavigationPath = .init()
    // MARK: PracticeManager
    var practiceManager: PracticeManager = PracticeManager()
}
