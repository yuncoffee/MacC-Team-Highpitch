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
    @State private var fillerWord: String = ""
    @State private var list: [String] = FillerWordList.userFillerWordList
    @State private var selected: String?
    @State private var validateText: String = ""
    @State private var isValid = true
    @FocusState private var fillerWordFocus: Bool
//    @FocusState private var epmFocus1: Bool
//    @FocusState private var epmFocus2: Bool
    
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
                    .onTapGesture {
                        FillerWordList.resetFillerWordList()
                    }
                Text("고치고 싶은 습관어를 추가 입력해주세요. 피드백을 원치 않는 습관어는 삭제할 수 있어요.")
                    .systemFont(.caption2, weight: .medium)
                    .foregroundStyle(Color.HPTextStyle.dark)
            }
            ListView(list + ["lastIdentifier"] + ["errorIdentifier"]) { item in
                if item == "lastIdentifier" {
                    TextField("습관어 입력(최대 30개)", text: $fillerWord)
                        .textFieldStyle(.plain)
                        .systemFont(.caption,weight: .regular)
                        .foregroundStyle(Color.HPTextStyle.dark)
                        .frame(width:130,height: 20)
                        .focused($fillerWordFocus)
                        .onSubmit {
                            do {
                                try textValidate()
                                list.append(fillerWord)
                                FillerWordList.userFillerWordList = list
                                isValid = true
                            } catch {
                                switch error as! FillerWordErr {
                                case .outOfIndex : validateText = "30개 이상의 습관어를 등록할 수 없어요"
                                case .textLengthErr : validateText = "6글자 이상은 등록할 수 없어요"
                                case .duplicate : validateText = "중복되는 습관어는 등록할 수 없어요"
                                }
                                isValid = false
                            }
                            fillerWord = ""
                            fillerWordFocus = false
                        }
                } else if item == "errorIdentifier"{
                    HStack {
                        Text(validateText)
                            .systemFont(.caption2,weight: .semibold)
                            .foregroundStyle(Color.HPRed.base)
                            .opacity(isValid ? 0 : 1)
                        Spacer()
                    }
                } else {
                    Button(action: {
                        if selected == item {
                            selected = nil
                        } else {
                            selected = item
                        }
                    }, label: {
                        Text(item)
                            .systemFont(.caption,weight: .semibold)
                            .foregroundStyle(
                                item == selected ?
                                Color.HPGray.system200 :
                                Color.HPTextStyle.darker)
                            .padding(.horizontal,.HPSpacing.xxxsmall)
                            .background(
                                RoundedRectangle(cornerRadius: .HPSpacing.xxxxsmall)
                                    .foregroundStyle(
                                        item == selected ?
                                        Color.HPSecondary.base :
                                        Color.HPComponent.Sidebar.select)
                            )
                    }).buttonStyle(.plain)
                }
            }.frame(maxWidth: 460)
//            Divider()
//            VStack(alignment: .leading, spacing: .HPSpacing.xxxxsmall) {
//                Text("내 적정 발화속도")
//                    .systemFont(.caption,weight: .semibold)
//                    .foregroundStyle(Color.HPTextStyle.darker)
//                Text("기본 설정 EPM 기준의 피드백을 원치 않으시면 내 속도에 적합하도록 수정할 수 있어요.")
//                    .systemFont(.caption2, weight: .medium)
//                    .foregroundStyle(Color.HPTextStyle.dark)
//            }
//            HStack {
//                TextField(firstEPM,text: $firstEPM)
//                .frame(width:60,height: 20)
//                .multilineTextAlignment(.center)
//                .textFieldStyle(.roundedBorder)
//                .accentColor(Color.HPPrimary.light)
//                Text("~")
//                    .systemFont(.caption,weight: .regular)
//                    .foregroundStyle(Color.HPTextStyle.base)
//                TextField(secondEPM,text: $secondEPM)
//                .frame(width:60,height: 20)
//                .multilineTextAlignment(.center)
//                .textFieldStyle(.roundedBorder)
//                
//            }
//            Text("내 평균 발화속도 290EPM")
//                .systemFont(.caption,weight: .regular)
//                .foregroundStyle(Color.HPTextStyle.dark)
//            //MARK: keybordShortcut을 위한 가짜 버튼
            Button("") {
                if selected != nil {
                    list.removeAll { $0 == selected}
                    FillerWordList.userFillerWordList = list
                }
            }
            .offset(y : 1000)
            .keyboardShortcut(.delete,modifiers: [])
        }
        .padding(.leading, .HPSpacing.small)
        .onTapGesture {
            print("hi")
            fillerWordFocus = false
        }
    }
}
struct ListView<Content:View>: View {
    let platforms: [String]
    let content: (String) -> Content
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
extension FeedbackSettingView {
    enum FillerWordErr: Error {
        case outOfIndex
        case textLengthErr
        case duplicate
    }
    private func textValidate() throws{
        //1. 리스트 30개 이상
        if FillerWordList.userFillerWordList.count > 30 {
            throw FillerWordErr.outOfIndex
        //2. 6글자 이상
        } else if fillerWord.count > 6 {
            throw FillerWordErr.textLengthErr
        // 중복
        } else if !FillerWordList.userFillerWordList.filter({$0 == fillerWord}).isEmpty {
            throw FillerWordErr.duplicate
        }
    }
}
#Preview {
    FeedbackSettingView()
}
