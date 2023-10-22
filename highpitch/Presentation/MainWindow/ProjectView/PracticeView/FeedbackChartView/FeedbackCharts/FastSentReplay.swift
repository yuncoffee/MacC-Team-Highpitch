//
//  FastSentReplay.swift
//  highpitch
//
//  Created by 이용준의 Macbook on 10/17/23.
//

import SwiftUI

struct FastSentReplay: View {
    @Binding
    var data: PracticeModel
    @State
    var isDetailActive = false
    var body: some View {
        VStack(spacing: 0) {
            if !data.summary.fastSentenceIndex.isEmpty {
                header
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation {
                            isDetailActive.toggle()
                        }
                    }
                if isDetailActive {
                    ForEach(
                        Array(data.sentences.sorted(by: {$0.epmValue! < $1.epmValue! }).enumerated()),
                        id: \.1.id
                    ) { index, each in
                        if each.epmValue! > 422.4 {
                            FastSentReplayCell(
                                isOdd: index % 2 != 0,
                                startAt: each.startAt!,
                                sentence: each.sentence
                            ) {
                                print("hello")
                            }
                            .border(
                                .HPComponent.stroke,
                                width: index == data.sentences.count - 1 ? 0 : 1,
                                edges: [.bottom]
                            )
                        }
                    }
                }
            }
        }
        .padding(.HPSpacing.xsmall + .HPSpacing.xxxxsmall)
        .frame(
            maxWidth: .infinity,
            minHeight: 70,
            alignment: .top
        )
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(lineWidth: 2)
                .foregroundStyle(Color.HPComponent.stroke)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal, .HPSpacing.xxxlarge)
        .padding(.bottom, .HPSpacing.xxxlarge + .HPSpacing.xxxsmall)
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
        .padding(.bottom, isDetailActive ? .HPSpacing.xsmall + .HPSpacing.xxxxsmall : 0)
    }
}

struct FastSentReplayCell: View {
    var isOdd: Bool
    var startAt: Int
    var sentence: String
    var completion: () -> Void
    
    var body: some View {
        HStack(spacing: .HPSpacing.xsmall) {
            Button {
                print(startAt)
            } label: {
                Label("play", systemImage: "play.fill")
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
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(isOdd ? Color.HPComponent.mainWindowDetailsBackground : .clear)
    }
}

// #Preview {
//    @State var practice = Practice(audioPath: Bundle.main.bundleURL, utterances: [])
//    return FastSentReplay(data: $practice)
// }
