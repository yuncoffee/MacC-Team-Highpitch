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
    @Environment(PracticeManager.self)
    private var practiceManager
    var sentences: [SentenceModel]
    var words: [WordModel]
    @State
    private var wordSizes: [CGSize] = []
    @State
    private var range: [(start: Int, end: Int)] = []
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
                                    nowSentece: practiceManager.nowSentence,
                                    sentenceIndex: index
                                ) { sentenceIndex in
                                    mediaManager.pausePlaying()
                                    mediaManager.playAt(atTime: Double(sentences[sentenceIndex].startAt))
                                    practiceManager.nowSentence = sentenceIndex
                                    mediaManager.play()
                                }
                                .id(sentence.index)
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
                    .onChange(of: practiceManager.nowSentence) { _, newValue in
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
            practiceManager.nowSentence = 0
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
            if practiceManager.nowSentence < sentences.count {
                if newValue > Double(sentences[practiceManager.nowSentence].endAt)/1000 {
                    practiceManager.nowSentence += 1
                }
            }
        })
    }
}

extension ScriptView {
    private func play(startAt: Double, index: Int) {
        mediaManager.pausePlaying()
    }
}
