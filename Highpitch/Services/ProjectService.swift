//
//  ProjectService.swift
//  Highpitch
//
//  Created by Yun Dongbeom on 2023/09/21.
//

import Foundation

protocol ProjectServiceable: ProjectRepository {}

class ProjectService: ProjectServiceable {
    let repo: ProjectRepository
    
    init(repo: ProjectRepository) {
        self.repo = repo
    }
    
    // 인터넷 연결 체크.. 계속!
    // 로컬로
    // 노션 -> 로컬
    
//    if(인터넷 연결){
//        repo = RemoteRepository
//    } else{
//        repo = LocalRepo
//    }
}

extension ProjectService {
    convenience init() {
        self.init(repo: LocalProjectRepository())
    }
}

extension ProjectService {
    func getProjects() -> [HPProject] {
        repo.getProjects()
    }
    func makeNewProject() {
        let project = HPProject(
            projectName: "Test",
            createAt: Date(),
            presentationPath: Bundle.main.url(forResource: .samplePPT, withExtension: "pdf")!)
        
//        repo.makeNewProject(project: project)
    }
}