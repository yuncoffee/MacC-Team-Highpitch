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
                    ForEach(project.practices, id: \.id) { practice in
                        VStack {
                            Text("연습카드")
                            NavigationLink("연습 상세보기", value: practice)
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
                    PracticeView(practice: sortPractice(oldPractice: practice))
                }
                .navigationTitle("Practice")
            }
        }
    }
}

extension PracticesTabItem {
    func sortPractice(oldPractice: PracticeModel) -> PracticeModel {
        var returnPractice = oldPractice
        
        var items = oldPractice.utterances.map { model in
            Utterance(startAt: model.startAt, duration: model.duration, message: model.message)
        }
        
        items.sort(by: {$0.startAt < $1.startAt})
        
        var items2 = items.map { utterance in
            UtteranceModel(startAt: utterance.startAt, duration: utterance.duration, message: utterance.message)
        }
//        for item in items2 {
//            print(item.message)
//        }
//        returnPractice.utterances = items2
//        returnPractice.utterances.removeAll()
//        returnPractice.utterances = oldPractice.utterances.sorted(by: {$0.startAt < $1.startAt})
        // return returnPractice
        
        return oldPractice
    }
}

//#Preview {
//    PracticesTabItem()
//        .environment(ProjectManager())
//}
