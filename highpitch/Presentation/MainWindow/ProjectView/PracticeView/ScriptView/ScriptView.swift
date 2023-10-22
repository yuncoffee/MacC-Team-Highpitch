//
//  ScriptView.swift
//  highpitch
//
//  Created by yuncoffee on 10/14/23.
//

import SwiftUI

struct ScriptView: View {
    @Binding
    var data: PracticeModel
    @State var nowSentece: Int?
    
    var body: some View {
        var width = 0.0
        var height = 0.0
        var currentSent = 0
        var sentenceModel = data.sentences.sorted(by: { $0.index < $1.index })
        var wordArray = data.words.sorted(by: { $0.index < $1.index })
        VStack(alignment: .leading, spacing: .HPSpacing.small) {
            HStack(alignment:.top, spacing: .HPSpacing.xxxxsmall) {
                Text("내 연습 다시보기")
                    .systemFont(.title)
                    .foregroundStyle(Color.HPTextStyle.darker)
                HPTooltip(tooltipContent: "다시보기 ㅎㅎ")
            }
            .frame(maxHeight: 64)
            .padding(.horizontal, .HPSpacing.small)
            ScrollView {
                ZStack(alignment: .topLeading) {
                    ForEach(wordArray) { word in
                        Text(word.word)
                            .font(word.sentenceIndex == nowSentece ? .custom(
                                FoundationTypoSystemFont.FontWeight.semibold.fontName,
                                size: 20) : .custom(
                                    FoundationTypoSystemFont.FontWeight.semibold.fontName,
                                    size: 18))
                            .foregroundStyle(
                                word.isFillerWord ?
                                Color.HPPrimary.base : word.sentenceIndex == nowSentece ?
                                Color.HPTextStyle.darker : Color.HPTextStyle.base)
                            .background(
                                sentenceModel[word.sentenceIndex].epmValue! > 422.4 ?
                                Color.HPComponent.highlight : Color.clear
                            )
                            .onTapGesture {
                                nowSentece = word.sentenceIndex
                            }
                            .alignmentGuide(.leading) { item in
                                if abs(width - item.width) > 279 || word.sentenceIndex != currentSent {
                                    width = 0.0; height -= item.height + 13
                                    currentSent = word.sentenceIndex
                                }
                                let result = width
                                if word.index == wordArray.count - 1 {
                                    width = 0
                                } else { width -= item.width }
                                return result
                            }
                            .alignmentGuide(.top) { _ in
                                let result = height
                                if word.index == wordArray.count - 1 {
                                    height = 0
                                }
                                return result
                            }
                    }
                }
                .frame(minWidth: 279, maxWidth: 279, alignment: .topLeading)
                .padding(.bottom, .HPSpacing.xxxlarge + .HPSpacing.xxxsmall)
                .padding(.horizontal, .HPSpacing.medium)
            }
            .padding(.bottom, 100)
        }
        .frame(
            minWidth:343,
            maxWidth: 343,
            maxHeight: .infinity,
            alignment: .topLeading
        )
        .border(Color.HPComponent.stroke, width: 1, edges: [.leading])
    }
}
