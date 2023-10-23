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
    
    @State private var editButtonOn: Bool = false
    
    var body: some View {
        @Bindable var projectManager = projectManager
        HStack {
            Text("0개 선택")
                .systemFont(.footnote, weight: .semibold)
                .foregroundStyle(Color.primary500)
            Spacer()
            Button("편집하기") {
                editButtonOn.toggle()
            }
            .systemFont(.footnote, weight: .semibold)
            .foregroundStyle(Color("8B6DFF"))
            .buttonStyle(.plain)
        }
        
        if editButtonOn {
            if let project = projectManager.current {
                List {
                    ForEach(Array(project.practices.sorted().enumerated()).reversed(), id: \.element.id) { index, practice in
                        
                        HStack(alignment: .center, spacing: .HPSpacing.xxsmall) {
                            
                            // 몇번째 연습
                            VStack(alignment:.leading, spacing: 0) {
                                // let reversedIndex = project.practices.count - index
                                Text(Date().createAtToPracticeDate(input: practice.creatAt))
                                    .systemFont(.footnote, weight: .medium)
                                    .foregroundStyle(Color.HPTextStyle.dark)
                                Text("\(indexToOrdinalNumber(index: index))번째 연습")
                                    .systemFont(.title, weight: .semibold)
                                    .foregroundStyle(Color.HPTextStyle.darker)
                                HPStyledLabel(content: "1시간 30분 48초 소요")
                            }
                            .padding(.horizontal, .HPSpacing.medium)
                            
                            Spacer()
                            
                            // 구분선
                            Rectangle()
                                .fill(Color.HPComponent.stroke) // 수직 줄의 색상을 설정
                                .frame(width: 1, height: 100) // 너비와 높이를 조절
                                .padding(.vertical, 5) // 원하는 간격으로 조절
                            
                            // 평균레벨 습관어 발화속도
                            VStack(alignment: .trailing) {
                                HStack {
                                    Text("자세히 보기")
                                        .systemFont(.caption, weight: .semibold)
                                        .foregroundStyle(Color("000000").opacity(0.35))
                                    Image(systemName: "chevron.right")
                                        .systemFont(.caption, weight: .semibold)
                                        .foregroundStyle(Color.HPTextStyle.light)
                                }
                                HStack {
                                    AverageLevelBox(measure: "\(practice.summary.level!)")
                                    FillerWordBox(measure: "\(practice.summary.fillerWordCount)")
                                    // 구분선
                                    Rectangle()
                                        .fill(Color.HPComponent.stroke) // 수직 줄의 색상을 설정
                                        .frame(width: 1, height: 52) // 너비와 높이를 조절
                                        .padding(.vertical, 5) // 원하는 간격으로 조절
                                    SpeechSpeedBox(measure: "\(Int(practice.summary.epmAverage!))")
                                }
                            }
                            .padding(.horizontal, 32)
                        }
                        .frame(minWidth: 672, minHeight: 136, maxHeight: 136)
                        .listRowSeparator(.hidden)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .listRowBackground(Color.HPComponent.mainWindowDetailsBackground)
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
        }
        else {
            NavigationStack(path: $projectManager.path) {
                
                if let project = projectManager.current {
                    List {
                        ForEach(Array(project.practices.sorted().enumerated()).reversed(), id: \.element.id) { index, practice in
                            
                            HStack(alignment: .center, spacing: .HPSpacing.xxsmall) {
                                
                                // 몇번째 연습
                                VStack(alignment:.leading, spacing: 0) {
                                    // let reversedIndex = project.practices.count - index
                                    Text(Date().createAtToPracticeDate(input: practice.creatAt))
                                        .systemFont(.footnote, weight: .medium)
                                        .foregroundStyle(Color.HPTextStyle.dark)
                                    NavigationLink("\(indexToOrdinalNumber(index: index))번째 연습", value: practice)
                                        .systemFont(.title, weight: .semibold)
                                        .foregroundStyle(Color.HPTextStyle.darker)
                                        .border(Color.red, width:2)
                                    HPStyledLabel(content: "1시간 30분 48초 소요")
                                }
                                .padding(.horizontal, .HPSpacing.medium)
                                
                                Spacer()
                                
                                // 구분선
                                Rectangle()
                                    .fill(Color.HPComponent.stroke) // 수직 줄의 색상을 설정
                                    .frame(width: 1, height: 100) // 너비와 높이를 조절
                                    .padding(.vertical, 5) // 원하는 간격으로 조절
                                
                                // 평균레벨 습관어 발화속도
                                VStack(alignment: .trailing) {
                                    HStack {
                                        Text("자세히 보기")
                                            .systemFont(.caption, weight: .semibold)
                                            .foregroundStyle(Color("000000").opacity(0.35))
                                        Image(systemName: "chevron.right")
                                            .systemFont(.caption, weight: .semibold)
                                            .foregroundStyle(Color.HPTextStyle.light)
                                    }
                                    HStack {
                                        AverageLevelBox(measure: "\(practice.summary.level!)")
                                        FillerWordBox(measure: "\(practice.summary.fillerWordCount)")
                                        // 구분선
                                        Rectangle()
                                            .fill(Color.HPComponent.stroke) // 수직 줄의 색상을 설정
                                            .frame(width: 1, height: 52) // 너비와 높이를 조절
                                            .padding(.vertical, 5) // 원하는 간격으로 조절
                                        SpeechSpeedBox(measure: "\(Int(practice.summary.epmAverage!))")
                                    }
                                }
                                .padding(.horizontal, 32)
                            }
                            .frame(minWidth: 672, minHeight: 136, maxHeight: 136)
                            .listRowSeparator(.hidden)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                            .listRowBackground(Color.HPComponent.mainWindowDetailsBackground)
                        }
                    }
                    .toolbar{
                        
                    }
                    // MARK: 연습 삭제하기 버튼 임시로 만들었습니다. 순서 상관없이 인덱스 0번째꺼 지우는 코드니깐 나중에 수정 필요!!
                    .contextMenu {
                        Button("delete") {
                            projectManager.current?.practices.remove(at: 0)
                        }
                    }
                    .listStyle(.plain)
                    .navigationDestination(for: PracticeModel.self) { practice in
                        PracticeView(practice: practice)
                            .environment(MediaManager())
                    }
                    .navigationTitle("Practice")
                    .scrollContentBackground(.hidden)
                }
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
    
    func indexToOrdinalNumber(index: Int) -> String {
        let ordinalNumber = ["첫", "두", "세", "네", "다섯", "여섯", "일곱", "여덟", "아홉", "열",
                             "열한", "열두", "열세", "열네", "열다섯", "열여섯", "열일곱", "열여덟"]
        
        if ordinalNumber.count < index {
            return "Index 초과"
        }
        return ordinalNumber[index]
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
                    .foregroundStyle(Color.primary500)
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
                    .foregroundStyle(Color.primary500)
                Text("EPM")
                    .systemFont(.body, weight: .medium)
                    .foregroundStyle(Color.text500)
            }
        }
        .frame(width: 123, height: 80)
    }
}

