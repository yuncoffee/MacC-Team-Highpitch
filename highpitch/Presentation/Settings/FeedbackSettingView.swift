//
//  FeedbackSettingView.swift
//  highpitch
//
//  Created by musung on 11/1/23.
//

import SwiftUI

struct FeedbackSettingView: View {
    @State private var firstEPM: String = "300"
    @State private var secondEPM: String = "310"
    @State private var list: [String] = FillerWordList().defaultList
    let rows = [
        GridItem(.adaptive(minimum: 50,maximum: 500))
        
    ]
    var body: some View {
        VStack(alignment: .leading, spacing:.HPSpacing.xxsmall) {
            Text("피드백 커스텀")
                .systemFont(.caption,weight: .semibold)
                .foregroundStyle(Color.HPTextStyle.darker)
                .padding(.top,.HPSpacing.small)
            VStack(alignment: .leading, spacing: .HPSpacing.xxxxsmall) {
                Text("내 습관어 필터")
                    .systemFont(.caption,weight: .semibold)
                    .foregroundStyle(Color.HPTextStyle.darker)
                Text("고치고 싶은 습관어를 추가 입력해주세요. 피드백을 원치 않는 습관어는 삭제할 수 있어요.")
                    .systemFont(.caption2, weight: .medium)
                    .foregroundStyle(Color.HPTextStyle.dark)
            }
            ListView(list + ["lastID"]) { item in
                if item != "lastID" {
                    Text(item)
                        .systemFont(.caption,weight: .semibold)
                        .foregroundStyle(Color.HPTextStyle.darker)
                        .padding(.horizontal,.HPSpacing.xxxsmall)
                        .background(
                            RoundedRectangle(cornerRadius: .HPSpacing.xxxxsmall)
                                .foregroundStyle(Color.HPPrimary.lightnest)
                        )
                } else {
                    Text("습관어 입력(최대 30개)")
                        .systemFont(.caption,weight: .regular)
                        .foregroundStyle(Color.HPTextStyle.dark)
                }
            }
            Divider()
            VStack(alignment: .leading, spacing: .HPSpacing.xxxxsmall) {
                Text("내 적정 발화속도")
                    .systemFont(.caption,weight: .semibold)
                    .foregroundStyle(Color.HPTextStyle.darker)
                Text("기본 설정 EPM 기준의 피드백을 원치 않으시면 내 속도에 적합하도록 수정할 수 있어요.")
                    .systemFont(.caption2, weight: .medium)
                    .foregroundStyle(Color.HPTextStyle.dark)
            }
            //MARK: teritary color 없는 것 같아요~
            HStack {
                TextField(firstEPM,text: $firstEPM)
                .frame(width:60,height: 20)
                .multilineTextAlignment(.center)
                .textFieldStyle(.roundedBorder)
                Text("~")
                    .systemFont(.caption,weight: .regular)
                    .foregroundStyle(Color.HPTextStyle.base)
                TextField(secondEPM,text: $secondEPM)
                .frame(width:60,height: 20)
                .multilineTextAlignment(.center)
                .textFieldStyle(.roundedBorder)
            }
            Text("내 평균 발화속도 290EPM")
                .systemFont(.caption,weight: .regular)
                .foregroundStyle(Color.HPTextStyle.dark)
        }.padding(.leading, .HPSpacing.small)
    }
}
struct ListView<Content:View>: View {
    let platforms: [String]
    let content: (String) -> Content
    var viewList : [[any View]] = []
    init(_ platforms: [String], @ViewBuilder content: @escaping (String) -> Content) {
        self.platforms = platforms
        self.content = content
    }
    var body: some View {
        GeometryReader(content: { geometry in
            self.generateContent(in: geometry)
        })
    }
    private func generateContent(in geometry: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero

        return ZStack(alignment: .topLeading) {
            ForEach(self.platforms, id: \.self) { platform in
                self.content(platform)
                    .padding([.horizontal, .vertical], 4)
                    .alignmentGuide(.leading, computeValue: { demension in
                        if (abs(width - demension.width) > geometry.size.width) {
                            width = 0
                            height -= demension.height
                        }
                        let result = width
                        if platform == self.platforms.last! {
                            width = 0
                        } else {
                            width -= demension.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: { _ in
                        let result = height
                        if platform == self.platforms.last! {
                            height = 0
                        }
                        return result
                    })
            }
        }
    }
}
#Preview {
    FeedbackSettingView()
}
