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
    @State var disclosureToggle = false
    
    var body: some View {
        if outOfRangeEPM().count != 0 {
            Text("빠르게 말한 구간 듣기")
                .onTapGesture {
                    disclosureToggle.toggle()
                }
            if disclosureToggle {
                ForEach(outOfRangeEPM()) { each in
                    Text("\(each.message)")
                        .onTapGesture {
                            print(each.index)
                        }
                }
            }
        }
    }
}

// 각 문장의 EPM을 기록하기 위한 구조체입니다.
struct SentenceEPM: Identifiable {
    var id = UUID()
    var index: Int
    var message: String
    var value: Double
}

extension FastSentReplay {
    
    // 각 문장별 EPM을 '순서대로' 반환합니다.
    func outOfRangeEPM() -> [SentenceEPM] {
        // 길이가 짧은 문장을 합칩니다.
        var addedData: [UtteranceModel] = []
        var tempString = ""
        var tempStartAt = -1
        var tempDuration = 0
        for utterence in data.utterances {
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
                addedData.append(UtteranceModel(
                    startAt: tempStartAt == -1 ? utterence.startAt : tempStartAt,
                    duration: tempDuration,
                    message: tempString
                ))
                tempString = ""
                tempStartAt = -1
                tempDuration = 0
            }
        }
        // 문장별 EPM을 저장합니다.
        var EPMCount: [SentenceEPM] = []
        var messagesArray: [[String]] = []
        for utterence in addedData {
            messagesArray.append(utterence.message.components(separatedBy: " "))
        }
        for sentenceNum in 0..<messagesArray.count {
            EPMCount.append(SentenceEPM(
                index: sentenceNum,
                message: addedData[sentenceNum].message,
                value: 0.0))
            for word in messagesArray[sentenceNum] {
                EPMCount[sentenceNum].value += Double(word.count)
            }
            EPMCount[sentenceNum].value /= Double(addedData[sentenceNum].duration)
            EPMCount[sentenceNum].value *= 60000.0
        }
        // 문장별 EPM에서 기준값 이상이 되지 않는 값은 제거합니다.
        var returnEPMCount = EPMCount.sorted(by: {$0.value > $1.value})
        if !returnEPMCount.isEmpty {
            while returnEPMCount.last!.value < 400.0 {
                _ = returnEPMCount.popLast()
            }
        }
        return returnEPMCount
    }
}

//#Preview {
//    @State var practice = Practice(audioPath: Bundle.main.bundleURL, utterances: [])
//    return FastSentReplay(data: $practice)
//}
