//
//  PracticesTabItem.swift
//  highpitch
//
//  Created by yuncoffee on 10/14/23.
//

import SwiftUI

struct PracticesTabItem: View {
    @Environment(ProjectManager.self)
    private var projectManager
    
    var body: some View {
        @Bindable var projectManager = projectManager
        NavigationStack(path: $projectManager.path) {
            if let project = projectManager.current {
                List(Array(project.practices), id: \.id) { practice in
                    VStack {
                        Text("연습카드")
                        NavigationLink("연습 상세보기", value: practice)
                    }
                }
                .navigationDestination(for: Practice.self) { practice in
                    PracticeView(practice: practice)
                }
                .navigationTitle("Practice")
            }
        }
    }
}

#Preview {
    PracticesTabItem()
        .environment(ProjectManager())
}
