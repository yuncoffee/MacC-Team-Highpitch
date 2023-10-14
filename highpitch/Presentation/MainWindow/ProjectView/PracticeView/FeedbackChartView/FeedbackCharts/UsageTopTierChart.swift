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
    var data = Practice(audioPath: NSURL.fileURL(withPath: ""), utterences: [])
    
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
    
}

#Preview {
    UsageTopTierChart()
}
