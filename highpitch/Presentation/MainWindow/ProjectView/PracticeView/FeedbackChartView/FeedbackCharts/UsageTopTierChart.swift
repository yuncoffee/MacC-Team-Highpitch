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
    var data: PracticeModel
    let fillerWordList = FillerWordList()
    
    @State
    var selectedIndex: Double?
    
    @State
    var cumulativeRangesForStyles: [(index: Int, range: Range<Double>)]?
    
    var selectedStyle: (name: String, selected: Int)? {
        if let selectedIndex = selectedIndex {
            let _selected = cumulativeRangesForStyles?.firstIndex(where: { $0.range.contains(selectedIndex) })
            return (name: self.fillerWordList.defaultList[_selected ?? 0], selected: Int(_selected ?? 0))
        }
        return nil
    }

    var body: some View {
        let maxHeight: CGFloat = 500
        VStack(alignment:.leading, spacing: 0) {
            header
            GeometryReader { geometry in
                let breakPoint: (chartSize: CGFloat, offset: CGFloat) = if geometry.size.width < 320 {
                    (chartSize: maxHeight * 0.5, offset: geometry.size.height/3)
                } else if geometry.size.width < 500 {
                    (chartSize: maxHeight * 0.5, offset: geometry.size.height/2.3)
                } else if geometry.size.width > 999 {
                    (chartSize: maxHeight, offset: geometry.size.height/1.7)
                } else {
                    (chartSize: maxHeight * 0.6, offset: geometry.size.height/2)
                }
                
                if (useFillerWord()) {
                    ZStack {
                        VStack(spacing: 0) {
                            Text("\(getFillerTypeCount())가지")
                                .systemFont(.title)
                                .foregroundStyle(Color.HPPrimary.base)
                            Text("습관어")
                                .systemFont(.footnote)
                                .foregroundStyle(Color.HPTextStyle.base)
                        }
                        Chart(Array(getFillerCount().enumerated()), id: \.1.id) { index, each in
                            if let color = each.color {
                                SectorMark(
                                    angle: .value("count", each.value),
                                    innerRadius: .ratio(0.618),
                                    outerRadius: .ratio(1),
                                    angularInset: 1.5
                                )
                                .cornerRadius(2)
                                .foregroundStyle(color)
                                .opacity(selectedStyle?.selected == index ? 0.5 : 1)
                            }
                        }
                        .chartLegend(alignment: .center, spacing: 18)
                        .chartAngleSelection(value: $selectedIndex)
                        .scaledToFit()
                        .frame(
                            maxWidth: breakPoint.chartSize,
                            maxHeight: breakPoint.chartSize,
                            alignment: .center
                        )
                    }
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: geometry.size.height,
                        alignment: .center
                    )
                }
            }
            
        }
        .padding(.bottom, .HPSpacing.large)
        .padding(.trailing, .HPSpacing.large + .HPSpacing.xxxxsmall)
        .frame(
            maxWidth: .infinity,
            minHeight: maxHeight,
            maxHeight: maxHeight,
            alignment: .topLeading
        )
        .onAppear {
            var cumulative = 0.0
            cumulativeRangesForStyles = getFillerCount().enumerated().map {
                let newCumulative = cumulative + Double($1.value)
                let result = (index: $0, range: cumulative ..< newCumulative)
                cumulative = newCumulative
                return result
            }
        }
    }
}

extension UsageTopTierChart {
    @ViewBuilder
    var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("습관어 종류 및 횟수")
                .systemFont(.subTitle)
                .foregroundStyle(Color.HPTextStyle.darker)
            Text("이번 연습에서 자주 언급된 습관어에요.")
                .systemFont(.body)
                .foregroundStyle(Color.HPTextStyle.dark)
        }
        .padding(.bottom, .HPSpacing.large)
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
struct FillerCountOffset: Identifiable, Hashable {
    var id = UUID()
    var index: Int
    var value: Int
    var offset: CGSize
    
    func hash(into hasher: inout Hasher) {}
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
    func fillerWordOffset(size: CGFloat) -> [FillerCountOffset] {
        let fillerCnt = getFillerCount()
        var sumValue = 0
        for index in fillerCnt { sumValue += index.value }
        var radiusContainer: [Double] = []
        
        for index in fillerCnt where index.value > 0 {
            radiusContainer.append(Double(index.value) * 2.0 * CGFloat.pi / Double(sumValue))
        }
        var returnContainer: [FillerCountOffset] = []
        var temp = 0.0
        for index in 0..<radiusContainer.count {
            returnContainer.append(
                FillerCountOffset(
                    index: fillerCnt[index].index, value: fillerCnt[index].value,
                    offset:
                        CGSize(
                            width: Double(size) * cos((temp + radiusContainer[index] / 2) - CGFloat.pi / 2),
                            height:
                                Double(size) * sin((temp + radiusContainer[index] / 2) - CGFloat.pi / 2)))
                        )
            temp += radiusContainer[index]
        }
        return returnContainer
    }
}

// #Preview {
//    @State var practice = Practice(audioPath: Bundle.main.bundleURL, utterances: [])
//    return UsageTopTierChart(data: $practice)
// }
