//
//  StatisticsTabItem.swift
//  highpitch
//
//  Created by yuncoffee on 10/14/23.
//

import SwiftUI

struct StatisticsTabItem: View {
    var body: some View {
        VStack {
            /// 결과 요약
            VStack {
                Text("총 연습에 대한 결과")
                /// 자세히보기
            }
            /// [평균 레벨 추이 ,필러워드 말빠르기] 그래프
            VStack {
                Text("그래프1")
            }
        }
    }
}

#Preview {
    StatisticsTabItem()
}
