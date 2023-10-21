//
//  PracticeResultCell.swift
//  highpitch
//
//  Created by yuncoffee on 10/21/23.
//

import SwiftUI

struct PracticeResultCell: View {
    var practice: PracticeModel
    var completion: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Circle()
                        .frame(width: 8)
                        .foregroundStyle(practice.isVisited ? .clear : .HPRed.base)
                    Text("\(practice.index)번째 연습의 피드백이 생성되었어요")
                        .systemFont(.caption, weight: .semibold)
                        .foregroundStyle(Color.HPTextStyle.darker)
                }
                Text("\(practice.practiceName) •  \(practice.creatAt)")
                    .systemFont(.caption2)
                    .foregroundStyle(Color.HPTextStyle.base)
                    .offset(x: 16)
            }
            Spacer()
            VStack {
                Button {
                    completion()
                } label: {
                    Label("확인하기", systemImage: "chevron.right")
                        .labelStyle(TextWithIconLabelStyle())
                        .systemFont(.caption)
                        .foregroundStyle(Color.HPTextStyle.base)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.vertical, .HPSpacing.xxsmall)
        .padding(.trailing, .HPSpacing.xxxsmall)
        .border(.HPComponent.stroke, width: 1, edges: [.bottom])
    }
}

#Preview {
    @State var practice = PracticeModel(
        practiceName: "1234",
        index: 0,
        isVisited: true, 
        creatAt: "3423",
        utterances: [],
        summary: PracticeSummaryModel()
    )
    
    return PracticeResultCell(practice: practice) {
        print("Hello")
    }
    .padding(8)
}
