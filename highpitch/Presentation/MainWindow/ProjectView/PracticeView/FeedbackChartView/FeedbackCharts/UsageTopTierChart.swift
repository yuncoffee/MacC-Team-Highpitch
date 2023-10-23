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
    var summary: PracticeSummaryModel
    let fillerWordList = FillerWordList()
    var epmtyData = [FillerCountData(
        index: 0,
        value: 1,
        word: "",
        color: Color("F1EDFF")
    )]
    
//    @State
//    var selectedIndex: Double?
//    
//    @State
//    var cumulativeRangesForStyles: [(index: Int, range: Range<Double>)]?
//    
//    var selectedStyle: (name: String, selected: Int)? {
//        if let selectedIndex = selectedIndex {
//            let _selected = cumulativeRangesForStyles?.firstIndex(where: { $0.range.contains(selectedIndex) })
//            return (name: self.fillerWordList.defaultList[_selected ?? 0], selected: Int(_selected ?? 0))
//        }
//        return nil
//    }

    var body: some View {
        let maxHeight: CGFloat = 500
        VStack(alignment:.leading, spacing: 0) {
            header
            GeometryReader { geometry in
                let breakPoint: (chartSize: CGFloat, offset: CGFloat) = if geometry.size.width < 320 {
                    (chartSize: maxHeight * 0.5, offset: geometry.size.height/3)
                } else if geometry.size.width < 500 {
                    (chartSize: maxHeight * 0.5, offset: geometry.size.height * 0.37)
                } else if geometry.size.width > 999 {
                    (chartSize: maxHeight, offset: geometry.size.height * 0.5)
                } else {
                    (chartSize: maxHeight * 0.6, offset: geometry.size.height * 0.45)
                }
                
                if (summary.fillerWordCount > 0) {
                    ZStack {
                        VStack(spacing: 0) {
                            Text("\(getFillerTypeCount())가지")
                                .systemFont(.title)
                                .foregroundStyle(Color.HPPrimary.base)
                            Text("습관어")
                                .systemFont(.footnote)
                                .foregroundStyle(Color.HPTextStyle.base)
                        }
                        Chart(Array(getFillerCount().enumerated()), id: \.1.id) { _, each in
                            if let color = each.color {
                                SectorMark(
                                    angle: .value("count", each.value),
                                    innerRadius: .ratio(0.618),
                                    outerRadius: .ratio(0.8)
                                )
                                .foregroundStyle(color)
//                                .opacity(selectedStyle?.selected == index ? 0.5 : 1)
                            }
                        }
//                        .chartAngleSelection(value: $selectedIndex)
                        .scaledToFit()
                        .frame(
                            maxWidth: breakPoint.chartSize,
                            maxHeight: breakPoint.chartSize,
                            alignment: .center
                        )
                        ForEach(fillerWordOffset(size: breakPoint.offset)) {each in
                            VStack(alignment: .center, spacing: 0) {
                                Text("\(each.word)")
                                    .systemFont(.title)
                                    .foregroundStyle(Color.HPTextStyle.dark)
                                Text("\(each.value)회")
                                    .systemFont(.footnote)
                                    .foregroundStyle(Color.HPTextStyle.dark)
                                
                            }
                            .offset(CGSize(width: each.offset.width, height: each.offset.height))
                        }
                    }
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: geometry.size.height,
                        alignment: .center
                    )
                } else {
                    ZStack {
                            Text("사용된 습관어가\n없어요!")
                            .multilineTextAlignment(.center)
                                .systemFont(.footnote)
                                .foregroundStyle(Color.HPTextStyle.base)
                    Chart(Array(epmtyData.enumerated()), id: \.1.id) { _, each in
                            if let color = each.color {
                                SectorMark(
                                    angle: .value("count", each.value),
                                    innerRadius: .ratio(0.618),
                                    outerRadius: .ratio(0.8)
                                )
                                .foregroundStyle(color)
//                                .opacity(selectedStyle?.selected == index ? 0.5 : 1)
                            }
                        }
//                        .chartAngleSelection(value: $selectedIndex)
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
        .padding(.bottom, .HPSpacing.small)
        .padding(.trailing, .HPSpacing.large + .HPSpacing.xxxxsmall)
        .frame(
            maxWidth: .infinity,
            minHeight: maxHeight,
            maxHeight: maxHeight,
            alignment: .topLeading
        )
//        .onAppear {
//            var cumulative = 0.0
//            cumulativeRangesForStyles = getFillerCount().enumerated().map {
//                let newCumulative = cumulative + Double($1.value)
//                let result = (index: $0, range: cumulative ..< newCumulative)
//                cumulative = newCumulative
//                return result
//            }
//        }
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
        .padding(.bottom, .HPSpacing.xsmall)
    }
}

// 각 습관어의 사용 횟수를 기록하기 위한 구조체입니다.
struct FillerCountData: Identifiable {
    var id = UUID()
    var index: Int
    var value: Int
    var word: String
    var color: Color?
}

// donut chart의 annotation offset을 설정하기 위한 구조체입니다.
struct FillerCountOffset: Identifiable {
    var id = UUID()
    var index: Int
    var value: Int
    var word: String
    var offset: CGSize
}

extension UsageTopTierChart {
    
    // 습관어 사용 횟수를 '순서대로' 반환합니다.
    func getFillerCount() -> [FillerCountData] {
        let eachFillerCount = summary.eachFillerWordCount
            .sorted(by: { $0.count > $1.count })
        var returnFillerCount: [FillerCountData] = []
        var index = -1, temp = 0
        for fillerWord in eachFillerCount {
            if (index != 4) { index += 1 }
            if (index == 4) {
                temp += fillerWord.count
            } else {
                returnFillerCount.append(FillerCountData(
                    index: index,
                    value: fillerWord.count,
                    word: fillerWord.fillerWord
                ))
            }
        }
        if (index == 4) {
            returnFillerCount.append(FillerCountData(
                index: index,
                value: temp,
                word: "기타"
            ))
        }
        for rightIndex in 0..<returnFillerCount.count {
            if rightIndex == 0 {
                returnFillerCount[rightIndex].color = Color("8B6DFF")
            } else if rightIndex == 1 {
                returnFillerCount[rightIndex].color = Color("AD99FF")
            } else if rightIndex == 2 {
                returnFillerCount[rightIndex].color = Color("D0C5FF")
            } else if rightIndex == 3 {
                returnFillerCount[rightIndex].color = Color("E1DAFF")
            } else {
                returnFillerCount[rightIndex].color = Color("F1EDFF")
            }
        }
        return returnFillerCount
    }
    
    // 사용된 습관어의 종류 수를 반환합니다.
    func getFillerTypeCount() -> Int {
        var fillerTypeCnt = 0
        let eachFillerCount = summary.eachFillerWordCount
        for fillerWord in eachFillerCount where fillerWord.count > 0 {
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
                    word: fillerCnt[index].word,
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
