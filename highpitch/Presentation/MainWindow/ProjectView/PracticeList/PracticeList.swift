//
//  PracticeList.swift
//  highpitch
//
//  Created by yuncoffee on 10/23/23.
//

import SwiftUI

struct PracticeList: View {
    @Environment(\.modelContext)
    var modelContext
    
    @Environment(ProjectManager.self)
    private var projectManager
    
    @State 
    var practices: [PracticeModel] = []
    
    @State
    private var isEditMode = false
    
    @State
    private var selectedPractices: [PracticeModel] = []
    
    var body: some View {
        @Bindable var projectManager = projectManager
        
        VStack(spacing: 0) {
            header
            ScrollView {
                NavigationStack(path: $projectManager.path) {
                    LazyVGrid(columns: [GridItem()], spacing: .HPSpacing.xsmall) {
                        ForEach(Array(practices.enumerated()), id: \.1.id) { index, practice in
                            NavigationLink(value: practice) {
                                PracticeListCell(
                                    practice: practice,
                                    index: index,
                                    selectedPractices: $selectedPractices,
                                    isEditMode: isEditMode
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.bottom, .HPSpacing.small)
                    .padding(.leading, .HPSpacing.medium + .HPSpacing.xxxxsmall)
                    .padding(.trailing, .HPSpacing.large)
                    .navigationDestination(for: PracticeModel.self) { practice in
                        PracticeView(practice: practice)
                        .environment(MediaManager())
                    }
                }
            }
        }
        .onAppear {
            if let current = projectManager.current {
                practices = current.practices.sorted(by: {$0.creatAt > $1.creatAt})
            }
        }
        .onChange(of: projectManager.current?.practices, { _, _ in
            if let current = projectManager.current {
                practices = current.practices.sorted(by: {$0.creatAt > $1.creatAt})
            }
        })
        .onChange(of: selectedPractices) { _, newValue in
            print(newValue.count)
        }
    }
}

extension PracticeList {
    @ViewBuilder
    var header: some View {
        HStack(spacing: 0) {
            if isEditMode {
                Text("\(selectedPractices.count)개 선택")
                    .systemFont(.footnote, weight: .semibold)
                    .foregroundStyle(Color.HPPrimary.base)
            }
            Spacer()
            Button {
                if isEditMode && !selectedPractices.isEmpty {
                    selectedPractices.forEach { item in
                        let index = projectManager.current?.practices.firstIndex(of: item)
                        if let index = index {
                            projectManager.current?.practices.remove(at: index)
                        }
                        do {
                            try modelContext.save()
                        } catch {
                            print(error)
                        }
                    }
                }
                isEditMode.toggle()
            } label: {
                Text(isEditMode ? "삭제하기" : "편집하기")
                    .systemFont(.footnote, weight: .semibold)
                    .foregroundStyle(isEditMode ? Color.HPRed.base : Color.HPPrimary.base)
            }
            .buttonStyle(.plain)
        }
        .padding(.bottom, .HPSpacing.xxxsmall)
        .padding(.leading, .HPSpacing.xxxlarge + .HPSpacing.xxsmall)
        .padding(.trailing, .HPSpacing.large)
        .frame(alignment: .trailing)
    }
}

#Preview {
    PracticeList()
        .padding(24)
        .border(.red, width: 2)
}
