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
    @State var disclosureToggle = false
    
    var body: some View {
        VStack {
            if (useFillerWord()) {
                Text("언급된 습관어 상세보기")
                    .onTapGesture {
                        disclosureToggle.toggle()
                    }
                if (disclosureToggle) {
                    ForEach(getFillerCount()) { each in
                        HStack {
                            Text("\(fillerWordList.defaultList[each.index])")
                            Spacer()
                            Text("\(each.value)회")
                        }
                    }
                }
            }
        }
        .frame(
            maxWidth: .infinity,
            minHeight: 500,
            maxHeight: .infinity
        )
    }
}

extension FillerWordDetail {
    
    // 습관어를 사용했는지 반환합니다.
    func useFillerWord() -> Bool {
        let fillerWordList = FillerWordList()
        var messagesArray: [[String]] = []
        for utterence in data.utterances {
            messagesArray.append(utterence.message.components(separatedBy: " "))
        }
        for messageArray in messagesArray {
            for message in messageArray {
                for index in 0..<fillerWordList.defaultList.count
                where fillerWordList.defaultList[index] == message {
                    return true
                }
            }
        }
        return false
    }
    
    // 습관어 사용 횟수를 '순서대로' 반환합니다.
    func getFillerCount() -> [FillerCountData] {
        // index에 맞게 fillerword 사용 횟수를 확인합니다.
        var fillerCount: [FillerCountData] = []
        for index in 0..<fillerWordList.defaultList.count {
            fillerCount.append(FillerCountData(index: index, value: 0))
        }
        var messagesArray: [[String]] = []
        for utterence in data.utterances {
            messagesArray.append(utterence.message.components(separatedBy: " "))
        }
        for messageArray in messagesArray {
            for message in messageArray {
                for index in 0..<fillerWordList.defaultList.count
                where fillerWordList.defaultList[index] == message {
                    fillerCount[index].value += 1
                }
            }
        }
        var returnFillerCount = fillerCount.sorted(by: {$0.value > $1.value})
        // 사용한 적이 없는 습관어는 제거합니다.
        while returnFillerCount.last!.value == 0 {
            _ = returnFillerCount.popLast()
        }
        return returnFillerCount
    }
}

// #Preview {
//    @State var practice = Practice(audioPath: Bundle.main.bundleURL, utterances: [])
//    return FillerWordDetail(data: $practice)
// }
