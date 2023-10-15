//
//  UsageTopTierChart.swift
//  highpitch
//
//  Created by yuncoffee on 10/14/23.
//

/**
 버블 차트 + 사용한 필러단어 상세보기
 */
import SwiftUI

struct UsageTopTierChart: View {
    @Binding
    var data: Practice
    
    var body: some View {
        VStack {
            Text("Hello, UsageTopTierChart!")
        }
        .frame(
            maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,
            minHeight: 500,
            maxHeight: .infinity
        )
    }
}

struct FillerCountData: Identifiable {
    var id = UUID()
    var index: Int
    var value: Int
}

extension UsageTopTierChart {
    
    // MARK: 습관어 사용 횟수를 '순서대로' 리턴합니다.
    func getFillerRate() -> [FillerCountData] {
        let fillerWordList = FillerWordList()
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
        let returnFillerCount = fillerCount.sorted(by: {$0.value > $1.value})
        return returnFillerCount
    }
}

#Preview {
    @State var practice = Practice(audioPath: Bundle.main.bundleURL, utterances: [])
    return UsageTopTierChart(data: $practice)
}
