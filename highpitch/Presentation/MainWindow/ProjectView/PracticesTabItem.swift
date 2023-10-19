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
                        HStack {
                            VStack(alignment:.leading, spacing: 0) {
                                // let reversedIndex = project.practices.count - index
                                Text(fileNameDateToPracticeDate(input: practice.creatAt))
                                NavigationLink("\(index + 1)번째 연습 상세보기", value: practice)
                                    .border(Color.yellow, width: 2)
                                Text("1시간 30분 48초 소요")
                            }
                            .background(Color.blue)
                            .border(Color.red, width: 2)
                            
                            Divider()
                            
                            VStack {
                                Text("자세히 보기")
                                HStack {
                                    VStack {
                                        Text("평균 레벨")
                                    }
                                    VStack {
                                        Text("습관어")
                                    }
                                    Divider()
                                    VStack {
                                        Text("발화 속도")
                                    }
                                }
                            }
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
                        .environment(MediaManager())
                }
                .navigationTitle("Practice")
                .background(Color.pink)
                .border(Color.black, width: 2)
            }
        }
        .border(Color.pink, width: 2)
    }
}

// #Preview {
//    PracticesTabItem()
//        .environment(ProjectManager())
// }

extension PracticesTabItem {
    @ViewBuilder
    var eachPracticeCard: some View {
        let projectLevel = 4.5.description
        let tier = 34.description
        let MAX_LEVEL = 5.description
        /// 결과 요약
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 2) {
                    Text("총 평균 레벨")
                        .systemFont(.body)
                        .foregroundStyle(Color.HPTextStyle.darker)
                    HPTooltip(tooltipContent: "도움말 컨텐츠")
                        .offset(y: -.HPSpacing.xxxsmall)
                }
                HStack(alignment: .center, spacing: .HPSpacing.xxsmall) {
                    HStack(alignment: .firstTextBaseline, spacing: 0) {
                        Text("LV. ")
                            .systemFont(.caption, weight: .semibold)
                            .foregroundStyle(Color.HPPrimary.base)
                        Text("\(projectLevel)")
                            .styledFont(.largeTitleLv)
                            .foregroundStyle(Color.HPPrimary.base)
                        Text("/\(MAX_LEVEL)")
                            .systemFont(.caption, weight: .semibold)
                            .foregroundStyle(Color.HPTextStyle.light)
                    }
                    .frame(alignment: .bottom)
                    HStack(spacing: 0) {
                        HPStyledLabel(content: "상위 \(tier)%")
                    }
                    .frame(alignment: .center)
                }
            }
            .padding(.vertical, .HPSpacing.xsmall)
            .padding(.horizontal, .HPSpacing.medium)
            .frame(minHeight: 100, maxHeight: 100, alignment: .leading)
            .background(Color.HPGray.systemWhite)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: Color.HPComponent.shadowColor ,radius: 10, y: .HPSpacing.xxxxsmall)
        }
    }
    
    func fileNameDateToPracticeDate(input: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZ"
        
        if let date = inputFormatter.date(from: input) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "YYYY.MM.dd (E) HH:mm:ss"
            outputFormatter.locale = Locale(identifier: "ko_KR")
            
            let dateString = outputFormatter.string(from: date)
            
            return dateString
        } else {
            return "Invalid Date"
        }
    }
    
}
