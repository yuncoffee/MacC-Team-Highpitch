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
    var data = Practice(audioPath: NSURL.fileURL(withPath: ""), utterances: [])
    
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

extension UsageTopTierChart {
    
    // MARK: 습관어 사용 횟수를 리턴합니다.
    func getFillerRate() -> Int {
        let fillerWordList = FillerWordList()
        // index에 맞게 fillerword 사용 횟수를 확인합니다.
        var fillerCount = [Int](repeating: 0, count: 22)
        var messagesArray: [[String]] = []
        for utterence in data.utterances {
            messagesArray.append(utterence.message.components(separatedBy: " "))
        }
        for messageArray in messagesArray {
            for message in messageArray {
                for index in 0..<fillerWordList.defaultList.count {
                    if fillerWordList.defaultList[index] == message {
                        fillerCount[index] += 1
                    }
                }
            }
        }
        return 0
    }
}

#Preview {
    UsageTopTierChart()
}
