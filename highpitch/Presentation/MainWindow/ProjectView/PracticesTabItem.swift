//
//  PracticesTabItem.swift
//  highpitch
//
//  Created by yuncoffee on 10/14/23.
//

import SwiftUI
import SwiftData

struct PracticesTabItem: View {
    @Environment(ProjectManager.self)
    private var projectManager
    
    var body: some View {
        @Bindable var projectManager = projectManager
        NavigationStack(path: $projectManager.path) {
            if let project = projectManager.current {
                List {
                    ForEach(Array(project.practices.enumerated()).reversed(), id: \.element.id) { index, practice in
                        VStack {
                            let reversedIndex = project.practices.count - index
                            Text(practice.creatAt)
                            NavigationLink("\(index)번째 연습 상세보기", value: practice)
                        }
                    }
                    // MARK: 연습 삭제하기 버튼 임시로 만들었습니다. 순서 상관없이 인덱스 0번째꺼 지우는 코드니깐 나중에 수정 필요!!
                    .contextMenu {
                        Button("delete") {
                            projectManager.current?.practices.remove(at: 0)
                        }
                    }
                 }
                .navigationDestination(for: PracticeModel.self) { practice in
                    PracticeView(practice: practice)
                }
                .navigationTitle("Practice")
            }
        }
    }
}

//#Preview {
//    PracticesTabItem()
//        .environment(ProjectManager())
//}
