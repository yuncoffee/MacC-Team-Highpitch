//
//  PracticeListCell.swift
//  highpitch
//
//  Created by yuncoffee on 10/23/23.
//

import SwiftUI
import AVFoundation

struct PracticeListCell: View {
    var practice: PracticeModel
    var index: Int
    @State
    var duration = 0.0
    @State
    var isSelected = false
    
    @Binding
    var selectedPractices: [PracticeModel]
    
    var isEditMode: Bool
    
    var body: some View {
        HStack(spacing: .HPSpacing.small) {
            Toggle(isOn: $isSelected) {
            }
            .frame(width: 16, height: 16)
            .accentColor(Color.HPPrimary.base)
            .opacity(isEditMode ? 1 : 0)
            .disabled(!isEditMode)
            HStack(spacing: 0) {
                // 인포
                VStack(alignment: .leading, spacing: .HPSpacing.xxxsmall) {
                    Text("\(Date().createAtToPracticeDate(input: practice.creatAt))")
                        .systemFont(.footnote)
                        .foregroundStyle(Color.HPTextStyle.base)
                    Text("\(indexToOrdinalNumber(index: practice.index))번째 연습")
                        .systemFont(.title, weight: .semibold)
                        .foregroundStyle(Color.HPTextStyle.darker)
                    HPStyledLabel(content: "\(parseDurationToLabel(duration: duration)) 소요")
                }
                .frame(alignment: .leading)
                .padding(.trailing, .HPSpacing.medium)
                .border(.HPComponent.stroke, width: 1, edges: [.trailing])
                ZStack(alignment: .topTrailing) {
                    // 평균 레벨, 습관어, 말 빠르기
                    HStack(spacing: .HPSpacing.xlarge) {
                        VStack(spacing: 0) {
                            Text("평균 레벨")
                                .systemFont(.caption, weight: .semibold)
                                .foregroundStyle(Color.HPTextStyle.darker)
                            HStack(spacing: 0) {
                                Text("LV.")
                                    .systemFont(.body, weight: .semibold)
                                    .foregroundStyle(Color.HPPrimary.dark)
                                Text("\(String(format: "%.1f", practice.summary.level))")
                                    .systemFont(.largeTitle)
                                    .foregroundStyle(Color.HPPrimary.dark)
                                Text("/5")
                                    .systemFont(.body)
                                    .foregroundStyle(Color.HPTextStyle.light)
                            }
                        }
                        .padding(.vertical, .HPSpacing.xxsmall)
                        .padding(.horizontal, .HPSpacing.small)
                        .frame(maxWidth: 160)
                        .background(Color.HPComponent.Section.background)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        HStack(spacing: 0) {
                            VStack(spacing: 0) {
                                Text("습관어")
                                    .systemFont(.caption, weight: .semibold)
                                    .foregroundStyle(Color.HPTextStyle.darker)
                                HStack(spacing: 0) {
                                    Text("\(practice.summary.fillerWordCount)")
                                        .systemFont(.largeTitle)
                                        .foregroundStyle(Color.HPPrimary.base)
                                    Text("회")
                                        .systemFont(.body)
                                        .foregroundStyle(Color.HPTextStyle.light)
                                }
                            }
                            .frame(minWidth: 48, maxWidth: 102)
                            .padding(.trailing, .HPSpacing.small)
                            .border(.HPComponent.stroke, width: 1, edges: [.trailing])
                            VStack(spacing: 0) {
                                Text("말 빠르기")
                                    .systemFont(.caption, weight: .semibold)
                                    .foregroundStyle(Color.HPTextStyle.darker)
                                HStack(spacing: 0) {
                                    Text("\(Int(practice.summary.epmAverage ?? 0).description)")
                                        .systemFont(.largeTitle)
                                        .foregroundStyle(Color.HPPrimary.base)
                                    Text("EPM")
                                        .systemFont(.body)
                                        .foregroundStyle(Color.HPTextStyle.light)
                                }
                            }
                            .frame(minWidth: 96, maxWidth: 108)
                            .padding(.leading, .HPSpacing.small)
                        }
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                    Button {
                        print("자세히 보기..!")
                    } label: {
                        Label("자세히 보기", systemImage: "chevron.right")
                            .systemFont(.caption, weight: .semibold)
                            .labelStyle(TextWithIconLabelStyle())
                            .foregroundStyle(Color.HPTextStyle.light)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.leading, .HPSpacing.medium)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            }
            .padding(.vertical, .HPSpacing.xsmall)
            .padding(.horizontal, .HPSpacing.medium)
            .background(Color.HPComponent.Section.background)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: Color.HPComponent.shadowColor ,radius: 10, y: .HPSpacing.xxxxsmall)
        }
        .onAppear {
            do {
                duration = try AVAudioPlayer(contentsOf: practice.audioPath!).duration
            } catch {
                print(error)
            }
        }
        .onChange(of: isSelected) { _, newValue in
            if newValue {
                selectedPractices.append(practice)
            } else {
                if let index = selectedPractices.firstIndex(of: practice) {
                    selectedPractices.remove(at: index)
                }
            }
        }
    }
}

extension PracticeListCell {
    private func parseDurationToLabel(duration: Double) -> String {
        var result = ""
        let _duration = Int(duration)
        
        let hour =  _duration / 3600
        let minute = _duration % 3600 / 60
        let second = _duration % 60
        
        if hour > 0 {
            result += "\(hour)시"
        }
        if minute > 0 {
            result += "\(minute)분"
        }
        if second > 0 {
            result += "\(second)초"
        }

        return result
    }

private func indexToOrdinalNumber(index: Int) -> String {
    let ordinalNumber = ["첫", "두", "세", "네", "다섯", "여섯", "일곱", "여덟", "아홉", "열",
                         "열한", "열두", "열세", "열네", "열다섯", "열여섯", "열일곱", "열여덟"]
    
    if ordinalNumber.count < index {
        return "Index 초과"
    }
    return ordinalNumber[index]
}

}

#Preview {
    var practice = PracticeModel(
        practiceName: "",
        index: 0,
        isVisited: false,
        creatAt: "",
        utterances: [],
        summary: PracticeSummaryModel()
    )
    
    @State
    var selectedPractices: [PracticeModel] = []
    
    var isEditMode = false
    
    return PracticeListCell(practice: practice, index: 0, selectedPractices: $selectedPractices, isEditMode: isEditMode)
        .padding()
}
