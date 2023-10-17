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
import Charts

struct UsageTopTierChart: View {
    @Binding
    var data: Practice
    let fillerWordList = FillerWordList()
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("습관어 종류 및 횟수")
                Text("이번 연습에서 자주 언급된 습관어에요.")
            }
            Spacer()
            if (useFillerWord()) {
                ZStack {
                    Text("\(getFillerTypeCount())가지\n")
                    + Text("습관어")
                    Chart {
                        ForEach(getFillerCount()) { each in
                            SectorMark(
                                angle: .value("filler count", each.value),
                                innerRadius: .ratio(0.6),
                                outerRadius: .ratio(1.0),
                                angularInset: 0
                            )
                            .foregroundStyle(each.color!)
                        }
                    }
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: 300
                    )
                    ForEach(fillerWordOffset(size: 180)) { each in
                        Text("\(fillerWordList.defaultList[each.index])\n\(each.value)회")
                            .multilineTextAlignment(.center)
                            .offset(each.offset)
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

// 각 습관어의 사용 횟수를 기록하기 위한 구조체입니다.
struct FillerCountData: Identifiable {
    var id = UUID()
    var index: Int
    var value: Int
    var color: Color?
}

// donut chart의 annotation offset을 설정하기 위한 구조체입니다.
struct FillerCountOffset: Identifiable {
    var id = UUID()
    var index: Int
    var value: Int
    var offset: CGSize
}

extension UsageTopTierChart {
    
    // 습관어를 사용했는지 반환합니다.
    func useFillerWord() -> Bool {
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
        // 습관어 사용 횟수가 적은 부분은 기타로 합칩니다.
        while returnFillerCount.count > 5 {
            // 기타의 index는 -1로 배정합니다.
            returnFillerCount[4].index = -1
            returnFillerCount[4].value += returnFillerCount.last!.value
            _ = returnFillerCount.popLast()
        }
        // 습관어 사용 횟수가 많은 순으로 색을 배정합니다.
        returnFillerCount[0].color = Color("8B6DFF")
        returnFillerCount[1].color = Color("AD99FF")
        returnFillerCount[2].color = Color("D0C5FF")
        returnFillerCount[3].color = Color("E1DAFF")
        returnFillerCount[4].color = Color("F1EDFF")
        return returnFillerCount
    }
    
    // 사용된 습관어의 종류 수를 반환합니다.
    func getFillerTypeCount() -> Int {
        var fillerTypeCnt = 0
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
        // 한 번 이상 사용된 습관어의 수를 합산합니다.
        for fillerword in fillerCount where fillerword.value > 0 {
            fillerTypeCnt += 1
        }
        return fillerTypeCnt
    }
    
    // annotation의 offset을 반환합니다.
    func fillerWordOffset(size: Int) -> [FillerCountOffset] {
        var fillerCnt = getFillerCount()
        var sumValue = 0
        for index in fillerCnt { sumValue += index.value }
        var radiusContainer: [Double] = []
        for index in fillerCnt where index.value > 0 {
            radiusContainer.append(Double(index.value) * 2.0 * 3.1415926535 / Double(sumValue))
        }
        var returnContainer: [FillerCountOffset] = []
        var temp = 0.0
        for index in 0..<radiusContainer.count {
            returnContainer.append(
                FillerCountOffset(
                    index: fillerCnt[index].index, value: fillerCnt[index].value,
                    offset:
                        CGSize(
                            width: Double(size) * cos((temp + radiusContainer[index] / 2) - 3.1415926535 / 2),
                            height: 
                                Double(size) * sin((temp + radiusContainer[index] / 2) - 3.1415926535 / 2)))
                        )
            temp += radiusContainer[index]
        }
        return returnContainer
    }
}

#Preview {
    @State var practice = Practice(audioPath: Bundle.main.bundleURL, utterances: [])
    return UsageTopTierChart(data: $practice)
}
