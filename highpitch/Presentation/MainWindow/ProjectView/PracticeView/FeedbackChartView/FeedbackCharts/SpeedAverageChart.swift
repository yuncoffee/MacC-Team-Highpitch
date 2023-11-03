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
import Charts

struct SpeedAverageChart: View {
    @State
    var sentences: [SentenceModel]
    var practice: PracticeModel
    var epmRange: [Double]
    
    var body: some View {
        VStack {
            header
            Chart {
                /// 빠른/느린 구간 인디케이터
                RectangleMark(
                    xStart: .value("", 0.5),
                    xEnd: .value("", Double(sentences.count) + 0.5),
                    yStart: .value("", epmRange.first! - 10.0),
                    yEnd: .value(
                        "",
                        max(
                            epmRange.first! - 10.0,
                            practice.summary.epmAverage - 100.0
                    ))
                )
                .foregroundStyle(Color("FFD3AC").opacity(0.4))
                RectangleMark(
                    xStart: .value("", 0.5),
                    xEnd: .value("", Double(sentences.count) + 0.5),
                    yStart: .value("", min(epmRange.last! + 10.0,
                                           practice.summary.epmAverage + 100.0)),
                    yEnd: .value("", epmRange.last! + 10.0)
                )
                .foregroundStyle(Color("FFD3AC").opacity(0.4))
                
                /// 한 문장만 녹음했을 때
                if (sentences.count == 1) {
                    PointMark(
                        x: .value("문장 번호", 1),
                        y: .value("EPM", sentences.first?.epmValue ?? 0)
                    )
                    .foregroundStyle(Color.HPPrimary.base)
                    .lineStyle(StrokeStyle(lineWidth: 2))
                }
                
                /// LineChart
                ForEach(sentences) { sentence in
                    LineMark(
                        x: .value("문장 번호", sentence.index + 1),
                        y: .value("EPM", sentence.epmValue)
                    )
                    .foregroundStyle(Color.HPPrimary.base)
                    .lineStyle(StrokeStyle(lineWidth: 2))
                }
            }
            .chartXAxisLabel(alignment: .trailing) {
                Text("(총 문장 수)")
                    .systemFont(.caption)
                    .foregroundStyle(Color.HPTextStyle.base)
            }
            .chartYAxisLabel(alignment: .topLeading) {
                Text("(EPM)")
                    .systemFont(.caption)
                    .foregroundStyle(Color.HPTextStyle.base)
            }
            .chartPlotStyle { plotArea in
                plotArea
                    .border(Color("EAEAEA"), width: 1)
                
            }
            .chartXAxis {
                AxisMarks(values: Array(stride(
                    from: 1,
                    to: sentences.count + 1,
                    by: 1
                ))) { value in
                    AxisValueLabel(centered: false) {
                        if (value.index == 0
                            || value.index == sentences.count - 1) {
                            Text("\(value.index + 1)")
                                .frame(height: 21)
                                .fixedSize()
                                .systemFont(.caption)
                                .offset(x: -7)
                                .foregroundStyle(Color.HPTextStyle.base)
                        }
                    }
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading, values: .automatic) { value in
                    AxisGridLine(centered: true, stroke: StrokeStyle(lineWidth: 1, dash: [4, 2]))
                        .foregroundStyle(Color.HPGray.system200)
                    AxisValueLabel {
                        if let value = value.as(Int.self) {
                            Text("\(value)")
                                .systemFont(.caption)
                                .foregroundStyle(Color.HPTextStyle.base)
                                .padding(.trailing, 8)
                        }
                    }
                    AxisGridLine(centered: true, stroke: StrokeStyle(lineWidth: 1))
                        .foregroundStyle(Color.HPGray.system200)
                }
            }
            .chartXScale(domain: [0.5, Double(sentences.count) + 0.5])
            .chartYScale(domain: [epmRange.first! - 10.0, epmRange.last! + 10.0])
            .chartLegend(.hidden)
            .padding(.trailing, .HPSpacing.xxxlarge)
            .padding(.bottom, .HPSpacing.large)
            .frame(maxWidth: 800, maxHeight: 300, alignment: .topTrailing)
            .scaledToFill()
            .overlay {
                HStack {
                    HStack(spacing: .HPSpacing.xxxxsmall) {
                        RoundedRectangle(cornerRadius: 2)
                            .stroke(Color.HPComponent.stroke)
                            .background(Color("FFD3AC").opacity(0.4))
                            .frame(width: 12, height: 12)
                        Text("빠른/느린 구간")
                            .systemFont(.caption)
                            .foregroundStyle(Color.HPTextStyle.base)
                    }
                    HStack(spacing: .HPSpacing.xxxxsmall) {
                        RoundedRectangle(cornerRadius: 2)
                            .stroke(Color.HPPrimary.base)
                            .background(Color.HPPrimary.base)
                            .frame(width: 12, height: 12)
                        Text("이번 연습")
                            .systemFont(.caption)
                            .foregroundStyle(Color.HPTextStyle.base)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding(.trailing, .HPSpacing.xxxlarge)
            }
        }
        .onAppear {
            sentences = sentences.sorted(by: { $0.index < $1.index })
        }
    }
        
}

extension SpeedAverageChart {
    
    @ViewBuilder
    var header: some View {
        VStack(alignment: .leading, spacing: 0) {
            let problemSentenceCount = practice.summary.fastSentenceIndex.count
            + practice.summary.slowSentenceIndex.count
            if problemSentenceCount > 0 {
                Text("내 평균 페이스 대비 속도가")
                    .systemFont(.body)
                    .foregroundStyle(Color.HPTextStyle.dark)
                HStack(spacing: 0) {
                    Text("빠른/느린 구간은 ")
                        .systemFont(.body)
                        .foregroundStyle(Color.HPTextStyle.dark)
                    Text("\(problemSentenceCount)번 ")
                        .systemFont(.body)
                        .foregroundStyle(Color.HPPrimary.dark)
                    Text("있었어요.")
                        .systemFont(.body)
                        .foregroundStyle(Color.HPTextStyle.dark)
                }
                .padding(.bottom, .HPSpacing.xxxsmall)
            }
            Text("전문 연사 기준 평균 속도인 350EPM 대비")
                .systemFont(.body)
                .foregroundStyle(Color.HPTextStyle.dark)
            HStack(spacing: 0) {
                Text("평균 속도가 \(String(format: "%.0f", practice.summary.epmAverage))EPM으로 ")
                    .systemFont(.body)
                    .foregroundStyle(Color.HPTextStyle.dark)
                Text(
                    practice.summary.epmAverage >= 410.0
                    ? "빠른 편이에요."
                    : practice.summary.epmAverage >= 370.0
                    ? "조금 빠른 편이에요."
                    : practice.summary.epmAverage >= 330.0
                    ? "적절했어요."
                    : practice.summary.epmAverage >= 290.0
                    ? "조금 느린 편이에요."
                    : "느린 편이에요."
                )
                    .systemFont(.body)
                    .foregroundStyle(Color.HPPrimary.dark)
            }
        }
        .padding(.top, .HPSpacing.xsmall)
        .padding(.bottom, .HPSpacing.large)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    }
}
