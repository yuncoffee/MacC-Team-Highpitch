//
//  ProjectManager.swift
//  highpitch
//
//  Created by yuncoffee on 10/14/23.
//

import Foundation
import SwiftUI

@Observable
final class ProjectManager {
    // MARK: - 임시 샘플 프로젝트들 저장
    var projects: [Project]?
    var current: Project?
    var path: NavigationPath = .init()
}
