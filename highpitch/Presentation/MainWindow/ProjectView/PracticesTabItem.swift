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
            
            HStack {
                Spacer()
                Text("편집하기")
                    .systemFont(.footnote, weight: .semibold)
                    .foregroundStyle(Color("8B6DFF"))
            }
            
            if let project = projectManager.current {
                List {
                    ForEach(Array(project.practices.enumerated()).reversed(), id: \.element.id) { index, practice in
                        HStack(alignment: .center, spacing: .HPSpacing.xxsmall) {
                            VStack(alignment:.leading, spacing: 0) {
                                // let reversedIndex = project.practices.count - index
                                Text(fileNameDateToPracticeDate(input: practice.creatAt))
                                    .systemFont(.footnote, weight: .medium)
                                    .foregroundStyle(Color.HPTextStyle.dark)
                                NavigationLink("\(index + 1)번째 연습 상세보기", value: practice)
                                    .systemFont(.title, weight: .semibold)
                                    .foregroundStyle(Color.HPTextStyle.dark)
                                    .border(Color.yellow, width: 2)
                                HPStyledLabel(content: "1시간 30분 48초 소요")
                            }
                            .border(Color.red, width: 2)
                            .padding(.horizontal, .HPSpacing.medium)
                            
                            Spacer()
                            
                            // 구분선
                            Rectangle()
                                .fill(Color.HPComponent.stroke) // 수직 줄의 색상을 설정
                                .frame(width: 1, height: 100) // 너비와 높이를 조절
                                .padding(.vertical, 5) // 원하는 간격으로 조절
                            
                            VStack {
                                Text("자세히 보기")
                                HStack {
                                    AverageLevelBox(measure: "4.5")
                                    FillerWordBox(measure: "12")
                                    // 구분선
                                    Rectangle()
                                        .fill(Color.HPComponent.stroke) // 수직 줄의 색상을 설정
                                        .frame(width: 1, height: 52) // 너비와 높이를 조절
                                        .padding(.vertical, 5) // 원하는 간격으로 조절
                                    SpeechSpeedBox(measure: "138")
                                }
                            }
                            .padding(.horizontal, 32)
                        }
                        .frame(minWidth: 672, minHeight: 136, maxHeight: 136)
                        .border(Color.red, width: 2)
                        .listRowSeparator(.hidden)
                        
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
            }
        }
    }
    
}

// #Preview {
//    PracticesTabItem()
//        .environment(ProjectManager())
// }

extension PracticesTabItem {

    func fileNameDateToPracticeDate(input: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZ"
        
        if let date = inputFormatter.date(from: input) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "YYYY.MM.dd(E) HH:mm:ss"
            outputFormatter.locale = Locale(identifier: "ko_KR")
            
            let dateString = outputFormatter.string(from: date)
            
            return dateString
        } else {
            return "Invalid Date"
        }
    }
    
}

struct AverageLevelBox: View {
    var measure = ""
    
    var body: some View {
        /// 결과 요약
        VStack(alignment: .center, spacing: 0) {
            Text("평균 레벨")
                .systemFont(.caption, weight: .semibold)
                .foregroundStyle(Color.text900)
            HStack(alignment: .lastTextBaseline, spacing: 0) {
                Text("LV.")
                    .systemFont(.body, weight: .semibold)
                    .foregroundStyle(Color.primary600)
                Text(measure)
                    .font(.custom("Pretendard-Bold", size: 24))
                    .foregroundStyle(Color.primary600)
                Text("/5")
                    .systemFont(.body, weight: .medium)
                    .foregroundStyle(Color.text500)
            }
        }
        .frame(width: 123, height: 80)
        .background(Color.HPComponent.mainWindowSidebarBackground)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct FillerWordBox: View {
    var measure = ""
    
    var body: some View {
        /// 결과 요약
        VStack(alignment: .center, spacing: 0) {
            Text("습관어")
                .systemFont(.caption, weight: .semibold)
                .foregroundStyle(Color.text900)
            HStack(alignment: .lastTextBaseline, spacing: 0) {
                Text(measure)
                    .systemFont(.largeTitle, weight: .bold)
                    .foregroundStyle(Color.primary600)
                Text("회")
                    .systemFont(.body, weight: .medium)
                    .foregroundStyle(Color.text500)
            }
        }
        .frame(width: 123, height: 80)
    }
}

struct SpeechSpeedBox: View {
    var measure = ""
    
    var body: some View {
        /// 결과 요약
        VStack(alignment: .center, spacing: 0) {
            Text("발화 속도")
                .systemFont(.caption, weight: .semibold)
                .foregroundStyle(Color.text900)
            HStack(alignment: .lastTextBaseline, spacing: 0) {
                Text(measure)
                    .systemFont(.largeTitle, weight: .bold)
                    .foregroundStyle(Color.primary600)
                Text("EPM")
                    .systemFont(.body, weight: .medium)
                    .foregroundStyle(Color.text500)
            }
        }
        .frame(width: 123, height: 80)
    }
}

