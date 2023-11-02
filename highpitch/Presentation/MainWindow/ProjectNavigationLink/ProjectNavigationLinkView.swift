//
//  ProjectNavigationLinkView.swift
//  highpitch
//
//  Created by yuncoffee on 10/14/23.
//

import SwiftUI
import SwiftData

struct ProjectNavigationLink: View {
    @Environment(FileSystemManager.self)
    private var fileSystemManager
    @Environment(ProjectManager.self)
    private var projectManager
    @Environment(KeynoteManager.self)
    private var keynoteManager
    //
    @Environment(\.modelContext)
    var modelContext
    @Query(sort: \ProjectModel.creatAt)
    var projects: [ProjectModel]
    
    var body: some View {
        VStack(alignment: .leading, spacing: .HPSpacing.xxsmall) {
            Text("프로젝트 이름")
                .systemFont(.body, weight: .semibold)
                .foregroundStyle(Color.HPTextStyle.darker)
                .padding(.top, .HPSpacing.small)
                .padding(.horizontal, .HPSpacing.xxsmall)
                .padding(.bottom, .HPSpacing.xsmall)

            ForEach(projects, id: \.id) { project in
                ProjectLinkItem(
                    title : project.projectName,
                    isSelected: checkIsSelected(project.projectName)) {
                        if !projectManager.path.isEmpty {
                            projectManager.path.removeLast()
                        }
                        projectManager.current = project
                    }
                    .contextMenu {
                        Button("Delete") {
                            // 해당 프로젝트 밑에 연습들 경로 하나하나 조회 -> 해당 경로를 통해서 녹음본 삭제
                            for practice in project.practices {
                                guard let fileURL = practice.audioPath else {
                                    print("[프로젝트 삭제] 연습 음성파일 URL이 nil입니다.")
                                    return
                                }
                                
                                let fileManager = FileManager.default
                                do {
                                    try fileManager.removeItem(at: fileURL)
                                    print("[프로젝트 삭제] 연습 파일 삭제 성공: \(fileURL.path)")
                                } catch {
                                    print("[프로젝트 삭제] 연습 파일 삭제 실패: \(error.localizedDescription)")
                                }
                            }
                            
                            modelContext.delete(project)
                        }
                    }
            }
            .padding(.leading, 8)
            .padding(.trailing, 12)
        }
        .frame(
            maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,
            maxHeight: .infinity,
            alignment: .topLeading
        )
    }
    
}

extension ProjectNavigationLink {
    func checkIsSelected(_ projectName: String) -> Bool {
        projectName == projectManager.current?.projectName
    }
}

#Preview {
    ProjectNavigationLink()
        .environment(FileSystemManager())
        .environment(ProjectManager())
        .frame(maxWidth: 200)
        .frame(minHeight: 860)
}
