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
    let fillerWordList = FillerWordList()
    @State var nowSentece: Int?
    @State var scriptWordCnt = 0
    @State var isFastArray: [Bool] = []
    
    var body: some View {
        var width = 0.0
        var height = 0.0
        var currentSent = 0
        return VStack(alignment: .leading, spacing: 24) {
            Text("내 연습 다시보기")
                .systemFont(.title)
                .foregroundStyle(Color.HPTextStyle.darker)
                .padding(.top, 24)
            ScrollView {
                ZStack(alignment: .topLeading) {
                    ForEach(getScriptWord()) { word in
                        Text(word.word)
                            .font(word.sentenceIndex == nowSentece ? .custom(
                                FoundationTypoSystemFont.FontWeight.semibold.fontName,
                                size: 20) : .custom(
                                    FoundationTypoSystemFont.FontWeight.semibold.fontName,
                                    size: 18))
                            .foregroundStyle(
                                isFillerWord(word: word.word) ?
                                Color.HPPrimary.base : word.sentenceIndex == nowSentece ?
                                Color.HPTextStyle.darker : Color.HPTextStyle.base)
                            .background(
                                isFastArray.count == 0 ?
                                getFastSentence(index:word.sentenceIndex) ?
                                        Color.HPComponent.highlight : Color.clear :
                                            isFastArray[word.sentenceIndex] ?
                                Color.HPComponent.highlight : Color.clear
                            )
                            .onTapGesture {
                                nowSentece = word.sentenceIndex
                            }
                            .alignmentGuide(.leading) { item in
                                if abs(width - item.width) > 436 || word.sentenceIndex != currentSent {
                                    width = 0.0; height -= item.height + 13
                                    currentSent = word.sentenceIndex
                                }
                                let result = width
                                if word.index == scriptWordCnt {
                                    width = 0
                                } else { width -= item.width }
                                return result
                            }
                            .alignmentGuide(.top) { _ in
                                let result = height
                                if word.index == scriptWordCnt {
                                    height = 0
                                }
                                return result
                            }
                    }
                    .onAppear {
                        scriptWordCnt = getScriptWord().count
                        isFastArray = getFastSentence()
                    }
                }
                .frame(minWidth: 436, maxWidth: 436, alignment: .topLeading)
            }
            .padding(.bottom, .HPSpacing.xxxlarge + .HPSpacing.xxxsmall)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// 단어, 문장 index
// 문장 index에 따른 fast, startAt
struct WordData: Identifiable {
    var id = UUID()
    var index: Int
    var sentenceIndex: Int
    var word: String
}

struct SentenceData: Identifiable {
    var id = UUID()
    var fast: Bool
    var startAt: Int
}

extension ScriptView {
    
    // 해당 단어가 습관어인지 반환합니다.
    func isFillerWord(word: String) -> Bool {
        var nword = word
        while nword.last! == "." || nword.last! == " " {
            _ = nword.popLast()
        }
        for fillerword in fillerWordList.defaultList
        where fillerword == nword { return true }
        return false
    }
    
    // 단어를 문장 index와 함께 반환합니다.
    func getScriptWord() -> [WordData] {
        // 길이가 짧은 문장을 합칩니다.
        var addedData: [Utterance] = []
        var tempString = ""
        var tempStartAt = -1
        var tempDuration = 0
        var temp = 0
        for utterence in data.utterances.sorted() {
            if (tempString != "") {
                tempString += " "
            }
            tempString += utterence.message
            if tempString.last! == "." {
                temp += 1
            }
            tempDuration += utterence.duration
            if tempString.count < 10 + temp {
                if tempStartAt == -1 {
                    tempStartAt = utterence.startAt
                }
            } else {
                addedData.append(Utterance(
                    startAt: tempStartAt == -1 ? utterence.startAt : tempStartAt,
                    duration: tempDuration,
                    message: tempString
                ))
                tempString = ""; tempStartAt = -1; tempDuration = 0; temp = 0
            }
        }
        var returnData: [WordData] = []
        var sentNum = 0
        var wordNum = 1
        for sentence in addedData {
            let messageArray = sentence.message.components(separatedBy: " ")
            for index in 0..<messageArray.count {
                if index == messageArray.count - 1 {
                    returnData.append(WordData(
                        index: wordNum,
                        sentenceIndex: sentNum,
                        word: messageArray[index]))
                } else {
                    returnData.append(WordData(
                        index: wordNum,
                        sentenceIndex: sentNum,
                        word: messageArray[index] + " "))
                }
                wordNum += 1
            }
            sentNum += 1
        }
        return returnData
    }
    
    // 문장의 index에 맞게 빠른 문장인지 배열로 반환합니다.
    func getFastSentence(index: Int) -> Bool {
        // 길이가 짧은 문장을 합칩니다.
        var addedData: [Utterance] = []
        var tempString = ""
        var tempStartAt = -1
        var tempDuration = 0
        for utterence in data.utterances.sorted() {
            if (tempString != "") {
                tempString += " "
            }
            tempString += utterence.message
            if tempString.last! == "." {
                _ = tempString.popLast()
            }
            tempDuration += utterence.duration
            if tempString.count < 10 {
                if tempStartAt == -1 {
                    tempStartAt = utterence.startAt
                }
            } else {
                addedData.append(Utterance(
                    startAt: tempStartAt == -1 ? utterence.startAt : tempStartAt,
                    duration: tempDuration,
                    message: tempString
                ))
                tempString = ""
                tempStartAt = -1
                tempDuration = 0
            }
        }
        
        var returnData: [Bool] = []
        for sentence in addedData {
            var wordList: [String] = []
            // EPM이 400.0보다 큰지 확인합니다.
            var dmawjf = 0
            for word in sentence.message.components(separatedBy: " ") {
                wordList.append(word)
                dmawjf += word.count
            }
            returnData.append(Double(dmawjf) * 60000.0 > 400.0 * Double(sentence.duration))
        }
        return returnData[index]
    }
    
    // 문장의 index에 맞게 빠른 문장인지 배열로 반환합니다.
    func getFastSentence() -> [Bool] {
        // 길이가 짧은 문장을 합칩니다.
        var addedData: [Utterance] = []
        var tempString = ""
        var tempStartAt = -1
        var tempDuration = 0
        for utterence in data.utterances.sorted() {
            if (tempString != "") {
                tempString += " "
            }
            tempString += utterence.message
            if tempString.last! == "." {
                _ = tempString.popLast()
            }
            tempDuration += utterence.duration
            if tempString.count < 10 {
                if tempStartAt == -1 {
                    tempStartAt = utterence.startAt
                }
            } else {
                addedData.append(Utterance(
                    startAt: tempStartAt == -1 ? utterence.startAt : tempStartAt,
                    duration: tempDuration,
                    message: tempString
                ))
                tempString = ""
                tempStartAt = -1
                tempDuration = 0
            }
        }
        
        var returnData: [Bool] = []
        for sentence in addedData {
            var wordList: [String] = []
            // EPM이 400.0보다 큰지 확인합니다.
            var dmawjf = 0
            for word in sentence.message.components(separatedBy: " ") {
                wordList.append(word)
                dmawjf += word.count
            }
            returnData.append(Double(dmawjf) * 60000.0 > 400.0 * Double(sentence.duration))
        }
        return returnData
    }
}
