//
//  FastSentReplay.swift
//  highpitch
//
//  Created by 이용준의 Macbook on 10/17/23.
//

import SwiftUI

struct FastSentReplay: View {
    @Environment(MediaManager.self)
    private var mediaManager
    var practice: PracticeModel
    
    @State
    var isDetailActive = false
    
    @State
    var selectedIndex = -1
        
    var body: some View {
        VStack(spacing: 0) {
            if !practice.summary.fastSentenceIndex.isEmpty {
                header
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation {
                            isDetailActive.toggle()
                        }
                    }
                if isDetailActive {
                    ForEach(
                        Array(practice.sentences.sorted(by: {$0.epmValue! < $1.epmValue! }).enumerated()),
                        id: \.1.id
                    ) { index, each in
                        if each.epmValue! > 422.4 {
                            FastSentReplayCell(
                                index: index,
                                isOdd: index % 2 == 0,
                                startAt: Double(each.startAt!),
                                endAt: Double(each.endAt!),
                                sentence: each.sentence,
                                isLast: index == practice.sentences.count - 1,
                                selectedIndex: $selectedIndex
                            )
                            .padding(.horizontal, 2)
                        }
                    }
                }
            }
        }
        .frame(
            minWidth: 388,
            maxWidth: 388,
            minHeight: 70,
            alignment: .top
        )
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(lineWidth: 2)
                .foregroundStyle(Color.HPComponent.stroke)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.bottom, .HPSpacing.xxxlarge + .HPSpacing.xxxsmall)
        .padding(.trailing, .HPSpacing.xxxlarge)
        .onReceive(mediaManager.timer, perform: { _ in
            if mediaManager.stopPoint != nil {
                if mediaManager.currentTime > (mediaManager.stopPoint!)/1000 {
                    mediaManager.stopPoint = nil
                    selectedIndex = -1
                    mediaManager.pausePlaying()
                }
            }
        })
    }
}

extension FastSentReplay {
    private func play(startAt: Double, endAt: Double) {
        mediaManager.playAt(atTime: startAt)
        mediaManager.play()
        mediaManager.stopPoint = endAt
    }
}

extension FastSentReplay {
    @ViewBuilder
    var header: some View {
        HStack {
            Text("빠르게 말한 구간 듣기")
                .systemFont(.subTitle)
                .foregroundStyle(Color.HPTextStyle.darker)
            Spacer()
            Label("열기", systemImage: "chevron.right")
                .labelStyle(.iconOnly)
                .systemFont(.body)
                .foregroundStyle(Color.HPTextStyle.base)
                .rotationEffect(isDetailActive ? .degrees(90) : .zero)
        }
        .padding(.top, .HPSpacing.xsmall + .HPSpacing.xxxxsmall)
        .padding(.bottom, isDetailActive ? .HPSpacing.xsmall + .HPSpacing.xxxxsmall : 0)
        .padding(.horizontal, .HPSpacing.xsmall + .HPSpacing.xxxxsmall)
    }
}

struct FastSentReplayCell: View {
    @Environment(MediaManager.self)
    private var mediaManager
    var index: Int
    var isOdd: Bool
    var startAt: Double
    var endAt: Double
    var sentence: String
    var isLast = false
    
    @State
    var isPlay = false
    
    @Binding
    var selectedIndex: Int {
        didSet {
            if selectedIndex != index {
                isPlay = false
            }
        }
    }

    var body: some View {
        HStack(spacing: .HPSpacing.xsmall) {
            Button {
                play(startAt: startAt, endAt: endAt)
            } label: {
                Label("play", systemImage: selectedIndex == index && isPlay ? "pause.fill" : "play.fill")
                    .labelStyle(.iconOnly)
                    .systemFont(.body)
                    .foregroundStyle(Color.HPPrimary.base)
            }
            .buttonStyle(.plain)
            .frame(width: 32, height: 32)
            .background(
                Circle()
                    .stroke(lineWidth: 2)
                    .foregroundStyle(Color.HPPrimary.lightness)
                    .background(Color.HPPrimary.lightnest)
            )
            .clipShape(Circle())
            Text("\(sentence)")
                .systemFont(.body)
                .foregroundStyle(Color.HPTextStyle.darker)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        }
        .padding(.vertical, .HPSpacing.xsmall + .HPSpacing.xxxxsmall)
        .border(
            .HPComponent.stroke,
            width: isLast ? 0 : 1,
            edges: [.bottom]
        )
        .padding(.horizontal, .HPSpacing.xsmall + .HPSpacing.xxxxsmall)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(isOdd ? Color.HPComponent.mainWindowDetailsBackground : .clear)
    }
}

extension FastSentReplayCell {
    private func play(startAt: Double, endAt: Double) {
        mediaManager.playAt(atTime: startAt)
        mediaManager.play()
        mediaManager.stopPoint = endAt
        isPlay.toggle()
        selectedIndex = index
    }
}

// #Preview {
//    @State var practice = Practice(audioPath: Bundle.main.bundleURL, utterances: [])
//    return FastSentReplay(data: $practice)
// }
