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
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("내 연습 다시보기")
                .systemFont(.title)
                .foregroundStyle(Color.HPTextStyle.darker)
                .padding(.leading, 24)
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(getScriptData()) { each in
                        each.message.reduce(Text(""), {
                            $0
                            + Text($1)
                                .font(.custom(
                                    FoundationTypoSystemFont.FontWeight.semibold.fontName,
                                    size: 18))
                                .foregroundStyle(
                                isFillerWord(word: $1) ?
                                Color.HPPrimary.base : Color.black)
                            + Text(" ") })
                    }
                }.frame(maxWidth: .infinity)
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct SentenceData: Identifiable {
    var id = UUID()
    var index: Int
    var message: [String]
    var startAt: Int
    var fast: Bool
}

extension ScriptView {
    
    // 해당 단어가 습관어인지 반환합니다.
    func isFillerWord(word: String) -> Bool {
        for fillerword in fillerWordList.defaultList
        where fillerword == word { return true }
        return false
    }
    
    func getScriptData() -> [SentenceData] {
        // 길이가 짧은 문장을 합칩니다.
        var addedData: [Utterance] = []
        var returnData: [SentenceData] = []
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
        // 문장의 index입니다.
        var sentIndex = 0
        // 가공된 배열을 사용하여 SentenceData에 입력합니다.
        for sentence in addedData {
            var wordList: [String] = []
            // EPM이 400.0보다 큰지 확인합니다.
            var dmawjf = 0
            for word in sentence.message.components(separatedBy: " ") {
                wordList.append(word)
                dmawjf += word.count
                if word.last! == "." { dmawjf -= 1 }
            }
            returnData.append(SentenceData(
                index: sentIndex,
                message: wordList,
                startAt: sentence.startAt,
                fast: Double(dmawjf) * 60000.0 > 400.0 * Double(sentence.duration)
            ))
            sentIndex += 1
        }
        return returnData
    }
}
