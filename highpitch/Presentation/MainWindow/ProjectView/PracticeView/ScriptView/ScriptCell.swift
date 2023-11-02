//
//  ScriptCell.swift
//  highpitch
//
//  Created by yuncoffee on 11/1/23.
//

import SwiftUI

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

// #Preview {
//    ScriptCell()
// }
