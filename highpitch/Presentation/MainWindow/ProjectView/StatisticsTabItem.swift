//
//  StatisticsTabItem.swift
//  highpitch
//
//  Created by yuncoffee on 10/14/23.
//

import SwiftUI
import Charts

struct StatisticsTabItem: View {
    @Environment(ProjectManager.self)
    private var projectManager

    @State
    var isLevelTooltipActive = false
    
    var body: some View {
        if let practices = projectManager.current?.practices.sorted(by: { $0.creatAt < $1.creatAt }) {
            if (practices.count != 0) {
                /// 연습 진행 기간
                let startDate = Date().createAtToYMD(input: practices.first!.creatAt)
                let endDate = Date().createAtToYMD(input: practices.last!.creatAt)
                let practiceDuration = "\(startDate) - \(endDate)"
                
                VStack(alignment:.leading, spacing: 0) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("총 \(practices.count)번의 연습에 대한 결과예요")
                            .systemFont(.largeTitle)
                            .foregroundStyle(Color.HPTextStyle.darker)
                        Text("\(practiceDuration) 동안 연습했어요")
                            .systemFont(.body)
                            .foregroundStyle(Color.HPTextStyle.base)
                    }
                    .padding(.bottom, .HPSpacing.xsmall)
                    HStack(spacing: .HPSpacing.xxsmall) {
                        /// 총 평균 레벨
                        averageLevelCard
                        /// 최고 연습 회차
                        bestLevelPracticeCard
                    }
                    .padding(.bottom, .HPSpacing.xxsmall)
                    /// [레벨, 습관어, 말 빠르기] 그래프
                    StatisticTabGraph()
                }
            } else { emptyView }
        } else { emptyView }
    }
}

extension StatisticsTabItem {
    // MARK: - emptyView
    @ViewBuilder
    var emptyView: some View {
        VStack {
            Text("연습결과가 없습니다.")
        }
    }
    // MARK: - 총 평균 레벨
    @ViewBuilder
    var averageLevelCard: some View {
        let projectLevel = getProjectLevel()
        let MAX_LEVEL = 5.description
        /// 결과 요약
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 2) {
                    Text("총 평균 레벨")
                        .systemFont(.body)
                        .foregroundStyle(Color.HPTextStyle.darker)
                        .frame(height: 27)
                    tooltipLevel
                }
                HStack(alignment: .center, spacing: .HPSpacing.xxsmall) {
                    HStack(alignment: .firstTextBaseline, spacing: 0) {
                        Text("LV.")
                            .systemFont(.caption, weight: .semibold)
                            .foregroundStyle(Color.HPPrimary.dark)
                        Text(" \(projectLevel, specifier: "%.1f")")
                            .styledFont(.largeTitleLv)
                            .foregroundStyle(Color.HPPrimary.dark)
                        Text("/\(MAX_LEVEL)")
                            .systemFont(.caption, weight: .semibold)
                            .foregroundStyle(Color.HPTextStyle.light)
                    }
                    .frame(alignment: .bottom)
                    HStack(spacing: 0) {
                        HPStyledLabel(content: "상위 ??%")
                    }
                    .frame(alignment: .center)
                }
            }
            .padding(.vertical, .HPSpacing.xsmall)
            .padding(.horizontal, .HPSpacing.medium)
            .frame(minHeight: 100, maxHeight: 100, alignment: .leading)
            .background(Color.HPComponent.Section.background)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: Color.HPComponent.shadowColor ,radius: 10, y: .HPSpacing.xxxxsmall)
        }
    }
    // MARK: - 평균 레벨 툴팁
    @ViewBuilder
    private var tooltipLevel: some View {
        Button {
            isLevelTooltipActive.toggle()
        } label: {
            Label("도움말", systemImage: "questionmark.circle")
                .systemFont(.footnote)
                .labelStyle(.iconOnly)
                .foregroundStyle(Color.HPGray.system400)
                .frame(width: 20, height: 20)
        }.sheet(isPresented: $isLevelTooltipActive) {
            ZStack(alignment: .topTrailing) {
                Button {
                    isLevelTooltipActive = false
                } label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 14, height: 14)
                        .foregroundStyle(Color.HPGray.system800)
                }
                .buttonStyle(.plain)
                .frame(width: 28, height: 28)
                .offset(x: -16, y: 16)
                VStack(alignment: .leading, spacing: .HPSpacing.small) {
                    VStack(alignment: .leading, spacing: .HPSpacing.xxxsmall) {
                        Text("총 평균 레벨이란?")
                            .systemFont(.footnote, weight: .bold)
                            .foregroundStyle(Color.HPTextStyle.darker)
                            .padding(.bottom, .HPSpacing.xxxsmall)
                        HStack(spacing: 0) {
                            Text("이 프로젝트에서 연습한 ")
                            + Text("모든 회차 레벨들의 평균").bold()
                            + Text("이예요.\n")
                            + Text("습관어를 말한 횟수가 적을수록 레벨이 높아져요.")
                        }
                        .fixedSize(horizontal: false, vertical: true)
                        .systemFont(.caption)
                        .foregroundStyle(Color.HPTextStyle.darker)
                        Text("*상위 % 데이터는 highpitch 이용자의 데이터가 어느 정도 모인 후에, 전체 진단 데이터를 토대로 제\n공될 예정이에요. 조금만 더 기다려 주세요!")
                            .fixedSize(horizontal: false, vertical: true)
                            .systemFont(.caption2, weight: .medium)
                            .foregroundStyle(Color.HPPrimary.base)
                        Text("*레벨 환산에 활용될 데이터 요소들은 추후 업데이트와 함께 제공될 예정이에요.\n(현재는 습관어 데이터 기준으로만 제공)")
                            .fixedSize(horizontal: false, vertical: true)
                            .systemFont(.caption2, weight: .medium)
                            .foregroundStyle(Color.HPPrimary.base)
                    }
                    VStack(alignment: .leading, spacing: 0) {
                        Text("습관어 LV 기준")
                            .systemFont(.caption, weight: .semibold)
                            .foregroundStyle(Color.HPTextStyle.darker)
                            .padding(.bottom, .HPSpacing.xxxsmall)
                        ZStack(alignment: .topTrailing) {
                            Text("(단위: %)")
                                .systemFont(.caption2)
                                .foregroundStyle(Color.HPGray.system600)
                                .offset(y: -22)
                            VStack(spacing: 0) {
                                HStack(spacing: 0) {
                                    Text("LV.1").frame(maxWidth: .infinity)
                                    Text("LV.2").frame(maxWidth: .infinity)
                                    Text("LV.3").frame(maxWidth: .infinity)
                                    Text("LV.4").frame(maxWidth: .infinity)
                                    Text("LV.5").frame(maxWidth: .infinity)
                                }
                                .systemFont(.caption2, weight: .medium)
                                .foregroundStyle(Color.HPTextStyle.base)
                                .frame(maxWidth: .infinity)
                                .background(Color.sectionpoint)
                                .border(.HPComponent.stroke, width: 1, edges: [.top, .bottom])
                                HStack(spacing: 0) {
                                    VStack(spacing: 0) {
                                        Text("6.5 < x")
                                            .systemFont(.caption2)
                                            .foregroundStyle(Color.HPTextStyle.base)
                                    }
                                    .frame(maxWidth: .infinity)
                                    VStack(spacing: 0) {
                                        Text("5.5 < x ≤ 6.5")
                                            .systemFont(.caption2)
                                            .foregroundStyle(Color.HPTextStyle.base)
                                    }
                                    .frame(maxWidth: .infinity)
                                    VStack(spacing: 0) {
                                        Text("4.5 < x ≤ 5.5")
                                            .systemFont(.caption2)
                                            .foregroundStyle(Color.HPTextStyle.base)
                                    }
                                    .frame(maxWidth: .infinity)
                                    VStack(spacing: 0) {
                                        Text("3.5 < x ≤ 4.5")
                                            .systemFont(.caption2)
                                            .foregroundStyle(Color.HPTextStyle.base)
                                    }
                                    .frame(maxWidth: .infinity)
                                    VStack(spacing: 0) {
                                        Text("0.0 ≤ x ≤ 3.5")
                                            .systemFont(.caption2)
                                            .foregroundStyle(Color.HPTextStyle.base)
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .border(.HPComponent.stroke, width: 1, edges: [.bottom])
                        }
                    }
                }
                .padding(.vertical, .HPSpacing.xsmall)
                .padding(.horizontal, .HPSpacing.small)
                .frame(maxWidth: 540, maxHeight: 314)
            }
        }
        .buttonStyle(.plain)
        .offset(y: -2)
    }
    // MARK: - 최고 연습 회차
    @ViewBuilder
    var bestLevelPracticeCard: some View {
        /// 최고 연습
        let bestPractice = getBestPractice()
        let MAX_LEVEL = 5.description
        if let bestPractice = bestPractice {
            /// 최고 카드
            VStack(alignment: .leading, spacing: 0) {
                /// 최고 연습 회차 정보
                HStack(spacing: 2) {
                    HStack(spacing: 0) {
                        Text("내 최고 연습 회차는 ")
                            .systemFont(.body)
                            .foregroundStyle(Color.HPTextStyle.darker)
                        Text("\(bestPractice.practiceName)")
                            .systemFont(.body, weight: .bold)
                            .foregroundStyle(Color.HPPrimary.base)
                        Text("이에요")
                            .systemFont(.body)
                            .foregroundStyle(Color.HPTextStyle.darker)
                    }
                    .frame(height: 27)
                    Spacer()
                    Label("자세히보기", systemImage: "chevron.right")
                        .systemFont(.caption, weight: .semibold)
                        .foregroundStyle(Color.HPTextStyle.light)
                        .labelStyle(TextWithIconLabelStyle())
                        .contentShape(Rectangle())
                }
                /// 최고 연습 회차 세부 정보
                HStack(alignment: .center, spacing: .HPSpacing.xxsmall) {
                    HStack(alignment: .firstTextBaseline, spacing: 0) {
                        Text("LV. ")
                            .systemFont(.caption, weight: .semibold)
                            .foregroundStyle(Color.HPPrimary.dark)
                        Text(" \(bestPractice.summary.level, specifier: "%.1f")")
                            .styledFont(.largeTitleLv)
                            .foregroundStyle(Color.HPPrimary.dark)
                        Text("/\(MAX_LEVEL)")
                            .systemFont(.caption, weight: .semibold)
                            .foregroundStyle(Color.HPTextStyle.light)
                    }
                    .frame(alignment: .bottom)
                    HStack(spacing: 0) {
                        HPStyledLabel(
                            content:
                                "습관어 \(bestPractice.summary.fillerWordCount)회 • 말 빠르기 "
                                + String(format: "%.1f", bestPractice.summary.epmAverage) + "EPM")
                    }
                }
                .frame(alignment: .center)
            }
            .padding(.vertical, .HPSpacing.xsmall)
            .padding(.horizontal, .HPSpacing.medium)
            .frame(maxWidth: .infinity, minHeight:100, maxHeight: 100, alignment: .leading)
            .background(Color.HPComponent.Section.background)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: Color.HPComponent.shadowColor ,radius: 10, y: 4)
            /// 해당 연습으로 이동합니다.
            .onTapGesture {
                if let practices = projectManager.current?.practices.sorted() {
                    projectManager.currentTabItem = 1
                    if !projectManager.path.isEmpty {
                        projectManager.path.removeLast()
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        projectManager.path.append(bestPractice)
                    }
                }
            }
        }
    }
    
    /// 프로젝트 전체 평균 레벨을 반환한다.
    func getProjectLevel() -> Double {
        var answer = 0.0
        if let practices = projectManager.current?.practices {
            for practice in practices {
                answer += Double(practice.summary.level)
            }
            answer /= Double(practices.count)
            return answer
        }
        return -1
    }
    
    /// 최고 연습 회차를 반환한다.
    func getBestPractice() -> PracticeModel? {
        if let practices = projectManager.current?.practices.sorted(
            by: { $0.summary.level > $1.summary.level }) {
            let answer = practices[0]
            return answer
        }
        return nil
    }
}
