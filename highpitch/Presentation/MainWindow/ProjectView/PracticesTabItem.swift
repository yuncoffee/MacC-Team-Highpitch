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
    
    @State private var isEditing: Bool = false
    @State private var selectedItems: Set<Int> = []
    @State private var editButtonOn: Bool = false
    
    var body: some View {
        PracticeList()
    }
    
    func toggleSelection(_ index: Int) {
        if selectedItems.contains(index) {
            selectedItems.remove(index)
        } else {
            selectedItems.insert(index)
        }
    }
}

// #Preview {
//    PracticesTabItem()
//        .environment(ProjectManager())
// }

extension PracticesTabItem {
    
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
            HStack(alignment: .bottom, spacing: 0) {
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
