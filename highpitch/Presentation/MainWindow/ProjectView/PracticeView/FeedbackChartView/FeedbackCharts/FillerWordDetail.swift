//
//  FillerWordDetail.swift
//  highpitch
//
//  Created by 이용준의 Macbook on 10/17/23.
//

import SwiftUI

struct FillerWordDetail: View {
    @Binding
    var data: PracticeModel
    let fillerWordList = FillerWordList()
    @State 
    var isDetailActive = false
    
    var body: some View {
        let summary = data.summary
        VStack(spacing: 0) {
            if (summary.fillerWordCount > 0) {
                header
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation {
                        isDetailActive.toggle()
                    }
                }
                if isDetailActive {
                    ScrollView {
                        ForEach(
                            Array(summary.eachFillerWordCount.sorted(by: {
                                $0.count > $1.count
                            }).enumerated()),
                            id: \.element.id) { index, each in
                            if each.count > 0 {
                                FillerWordDetailCell(
                                    isOdd: index % 2 != 0,
                                    count: each.count,
                                    word: each.fillerWord
                                )
                            }
                        }
                    }
                }
            }
        }
        .padding(.HPSpacing.xsmall + .HPSpacing.xxxxsmall)
        .frame(
            minWidth: 388,
            maxWidth: 388,
            minHeight: 70,
            maxHeight: 374,
            alignment: .top
        )
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(lineWidth: 2)
                .foregroundStyle(Color.HPComponent.stroke)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.trailing, .HPSpacing.xxxlarge)
    }
}

extension FillerWordDetail {
    @ViewBuilder
    var header: some View {
        HStack {
            Text("언급된 습관어 상세보기")
                .systemFont(.subTitle)
                .foregroundStyle(Color.HPTextStyle.darker)
            Spacer()
            Label("열기", systemImage: "chevron.right")
                .labelStyle(.iconOnly)
                .systemFont(.body)
                .foregroundStyle(Color.HPTextStyle.base)
                .rotationEffect(isDetailActive ? .degrees(90) : .zero)
        }
        .padding(.bottom, isDetailActive ? .HPSpacing.xsmall + .HPSpacing.xxxxsmall : 0)
    }
}

struct FillerWordDetailCell: View {
    var isOdd: Bool
    var count: Int
    var word: String
    
    var body: some View {
        HStack {
            Text("\(word)")
                .systemFont(.body)
                .foregroundStyle(Color.HPTextStyle.darker)
            Spacer()
            Text("\(count)회")
                .systemFont(.body)
                .foregroundStyle(Color.HPPrimary.base)
        }
        .padding(.vertical, .HPSpacing.xsmall + .HPSpacing.xxxxsmall)
        .padding(.horizontal, .HPSpacing.medium)
        .frame(width: 348)
        .background(!isOdd ? Color.HPComponent.Section.background : .clear)
        .clipShape(RoundedRectangle(cornerRadius: 4))
    }
}
