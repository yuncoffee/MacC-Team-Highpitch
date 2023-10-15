//
//  SpeedAverageChart.swift
//  highpitch
//
//  Created by yuncoffee on 10/14/23.
//

/**
 꺽은선 차트
 */
import SwiftUI

struct SpeedAverageChart: View {
    var data = Practice(audioPath: NSURL.fileURL(withPath: ""), utterances: [])
    
    var body: some View {
        VStack {
            Text("Hello, SpeedAverageChart!")
        }
        .frame(
            maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,
            minHeight: 500,
            maxHeight: .infinity
        )    }
}

// swiftlint:disable identifier_name
struct EPMData: Identifiable {
    var id = UUID()
    var index: Int
    var EPM: String
}

extension SpeedAverageChart {
    
    // MARK: EPM 지수를 리턴합니다.
    func getEPM() -> [EPMData] {
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
        return []
    }
}

#Preview {
    SpeedAverageChart()
}
