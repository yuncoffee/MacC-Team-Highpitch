//
//  ScriptView.swift
//  highpitch
//
//  Created by yuncoffee on 10/14/23.
//

import SwiftUI

@Observable
final class ScriptVM {
    var offsetX = 0.0
}

struct ScriptView: View {
    @Environment(MediaManager.self)
    private var mediaManager
    var sentences: [SentenceModel]
    var words: [WordModel]
    @State
    private var wordSizes: [CGSize] = []
    @State
    private var range: [(start: Int, end: Int)] = []
    @State
    var nowSentece = 0
    @State
    private var startIndex = 0
    
    private let SCRIPT_CONTAINER_WIDTH: CGFloat = 279
    
    var scriptVM = ScriptVM()
    
    var body: some View {
        VStack(alignment: .leading, spacing: .HPSpacing.small) {
            HStack(alignment:.top, spacing: .HPSpacing.xxxxsmall) {
                Text("내 연습 다시보기")
                    .systemFont(.title)
                    .foregroundStyle(Color.HPTextStyle.darker)
                HPTooltip(tooltipContent: "다시보기", arrowEdge: .bottom, content: {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("내 연습 다시보기란?")
                            .systemFont(.footnote, weight: .bold)
                            .foregroundStyle(Color.HPTextStyle.darker)
                            .padding(.bottom, .HPSpacing.xxxxsmall)
                        Text("연습했던 해당 회차의 녹음본을 토대로 추출된 스크립트에요.")
                            .systemFont(.caption)
                            .foregroundStyle(Color.HPTextStyle.darker)
                        Text("스크립트 내에 보라색 표시 글씨는 내가 사용한 습관어를, 형광펜 밑줄은 빠르게 말한 구간을 나타내요.")
                            .fixedSize(horizontal: false, vertical: true)
                            .systemFont(.caption, weight: .semibold)
                            .foregroundStyle(Color.HPTextStyle.darker)
                            .padding(.bottom, .HPSpacing.xxxxsmall)
                        Text("* 스크립트에서도 듣고싶은 구간을 클릭하면 해당 부분부터 재생돼요.")
                            .systemFont(.caption2, weight: .medium)
                            .foregroundStyle(Color.HPPrimary.base)
                    }
                    .padding(.vertical, .HPSpacing.xsmall)
                    .padding(.horizontal, .HPSpacing.small)
                    .frame(maxWidth: 400, maxHeight: 145)
                })
            }
            .frame(maxHeight: 64)
            .padding(.horizontal, .HPSpacing.small)
            ScrollView {
                ScrollViewReader { scrollViewProxy in
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(Array(sentences.enumerated()), id: \.1.id) { index, sentence in
                            if !range.isEmpty {
                                ScriptCell(
                                    words: words[range[index].start...range[index].end],
                                    startAt: range[index].start,
                                    endAt: range[index].end,
                                    containerWidth: SCRIPT_CONTAINER_WIDTH,
                                    isFastSentence: sentence.epmValue > 422.4,
                                    nowSentece: nowSentece,
                                    sentenceIndex: index
                                ) { sentenceIndex in
                                    mediaManager.pausePlaying()
                                    mediaManager.playAt(atTime: Double(sentences[sentenceIndex].startAt))
                                    nowSentece = sentenceIndex
                                    mediaManager.play()
                                }
                            }
                        }
                    }
                    .frame(
                        minWidth: SCRIPT_CONTAINER_WIDTH,
                        maxWidth: SCRIPT_CONTAINER_WIDTH,
                        maxHeight:.infinity, alignment: .topLeading
                    )
                    .padding(.bottom, .HPSpacing.xxxlarge + .HPSpacing.xxxsmall)
                    .padding(.horizontal, .HPSpacing.medium)
                    .onChange(of: nowSentece) { _, newValue in
                        withAnimation {
                            scrollViewProxy.scrollTo(newValue, anchor: .center)
                        }
                    }
                }
            }
            .padding(.bottom, 100)
        }
        .border(Color.HPComponent.stroke, width: 1, edges: [.leading])
        .onAppear {
            sentences.forEach { sentence in
                var result = (start: 0, end: 0)
                result.start = startIndex
                let lastWord = sentence.sentence.components(separatedBy: " ").reversed().first
                
                if let lastWord = lastWord,
                    let lastIndex = words[startIndex...].firstIndex(where: {$0.word == lastWord}) {
                    result.end = lastIndex
                    if lastIndex < words.count - 1 {
                        startIndex = lastIndex + 1
                    }
                }
                range.append(result)
            }
            
        }
        .onChange(of: mediaManager.currentTime, { _, newValue in
            
            print(#line, newValue)
            if nowSentece < sentences.count {
                if newValue > Double(sentences[nowSentece].endAt)/1000 {
                    nowSentece += 1
                }
            }
        })
    }
}

struct ScriptCell: View {
    var words: ArraySlice<WordModel>
    var startAt: Int
    var endAt: Int
    var containerWidth: CGFloat
    var isFastSentence: Bool
    var nowSentece: Int
    var sentenceIndex: Int
    var completion: (_ sentenceIndex: Int) -> Void
    
    private let SCRIPT_CONTAINER_WIDTH: CGFloat = 279
    
    var body: some View {
        var offsetX = 0.0
        var offsetY = 0.0
        
        ZStack(alignment: .topLeading) {
            ForEach(words, id: \.id) { word in
                Text("\(word.word)")
                    .alignmentGuide(.leading) { item in
                        if abs(offsetX - item.width) > containerWidth {
                            offsetX = 0
                            offsetY -= item.height + 8
                        }
                        let result = offsetX
                        if endAt == word.index {
                            offsetX = 0
                        } else {
                            offsetX -= item.width
                        }
                        return result
                    }
                    .alignmentGuide(.top) { _ in
                        let result = offsetY
                        if endAt == word.index {
                            offsetY = 0
                        }
                        
                        return result
                    }
                    .systemFont(word.isFillerWord || nowSentece == word.sentenceIndex
                        ? .subTitle
                        : .body
                    )
                    .foregroundStyle(word.isFillerWord
                         ? Color.HPPrimary.base :
                            nowSentece == word.sentenceIndex
                         ? Color.HPTextStyle.darker
                         : Color.HPTextStyle.base
                    )
                    .background(
                        Rectangle()
                            .frame(height: 8, alignment: .bottom)
                            .offset(
                                y: nowSentece == word.sentenceIndex
                                ? 4
                                : word.isFillerWord
                                ? 6.5
                                : 4
                            )
                            .foregroundStyle(
                                isFastSentence
                                ? Color.HPComponent.highlight
                                : Color.clear
                            )
                    )
                    .offset(
                        y: nowSentece == word.sentenceIndex
                        ? 0
                        : word.isFillerWord
                        ? -4
                        : 0
                    )
            }
        }
        .frame(
            minWidth: SCRIPT_CONTAINER_WIDTH,
            maxWidth: SCRIPT_CONTAINER_WIDTH,
            alignment: .topLeading
        )
        .onTapGesture {
            completion(sentenceIndex)
        }
    }
}

extension ScriptView {
    private func play(startAt: Double, index: Int) {
        mediaManager.pausePlaying()
        
    }
}
