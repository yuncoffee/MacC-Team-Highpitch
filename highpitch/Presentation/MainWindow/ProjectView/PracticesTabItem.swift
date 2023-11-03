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
