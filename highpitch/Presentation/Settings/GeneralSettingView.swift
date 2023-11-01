//
//  GeneralSettingView.swift
//  highpitch
//
//  Created by musung on 11/1/23.
//

import SwiftUI

struct GeneralSettingView: View {
    
    @State private var isChecked1 = false
    @State private var isChecked2 = false
    @State private var isChecked3 = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: .HPSpacing.small) {
            VStack(alignment: .leading, spacing: 5) {
                Toggle(isOn: $isChecked1) {
                    Text("전원 켜졌을 시 실행")
                        .systemFont(.caption, weight: .regular)
                        .foregroundStyle(Color.HPTextStyle.darker)
                        .padding(.horizontal, 6)
                }
                Toggle(isOn: $isChecked2) {
                    Text("메뉴 막대 아이콘 숨김")
                        .systemFont(.caption, weight: .regular)
                        .foregroundStyle(Color.HPTextStyle.darker)
                        .padding(.horizontal, 6)
                }
                Toggle(isOn: $isChecked3) {
                    Text("연습 녹음 저장 시 피드백 창 바로 띄우기")
                        .systemFont(.caption, weight: .regular)
                        .foregroundStyle(Color.HPTextStyle.darker)
                        .padding(.horizontal, 6)
                }
            }
            Divider()
            VStack(alignment: .leading, spacing: 5) {
                Text("단축키 설정")
                    .systemFont(.caption, weight: .regular)
                    .foregroundStyle(Color.HPTextStyle.darker)
                HStack {
                    Text("연습 녹음 시작")
                        .systemFont(.caption, weight: .regular)
                        .foregroundStyle(Color.HPTextStyle.darker)
                    Image(systemName: "play.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(Color.gray600)
                        .frame(width: 16, height: 16)
                    hotKeySettingButton
                }
                HStack {
                    Text("연습 녹음 일시정지")
                        .systemFont(.caption, weight: .regular)
                        .foregroundStyle(Color.HPTextStyle.darker)
                    Image(systemName: "pause.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(Color.gray600)
                        .frame(width: 16, height: 16)
                    hotKeySettingButton
                }
                HStack {
                    Text("연습 녹음 저장")
                        .systemFont(.caption, weight: .regular)
                        .foregroundStyle(Color.HPTextStyle.darker)
                    Image(systemName: "stop.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(Color.gray600)
                        .frame(width: 16, height: 16)
                    hotKeySettingButton
                }
            }
            
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 24)
        .frame(alignment:. topLeading)
    }
}
@ViewBuilder
var hotKeySettingButton: some View {
    HStack(spacing:0) {
        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
            ZStack {
                LeftRoundedRectangle(cornerRadius: 4)
                    .stroke(Color.HPGray.system600,lineWidth: 1)
                    .frame(width: 140,height: 20)
                Text("⌘⌥ F5")
                    .systemFont(.caption2,weight: .semibold)
                    .foregroundStyle(Color.HPTextStyle.darker)
            }
        }).buttonStyle(.plain)
        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
            ZStack {
                RightRoundedRectangle(cornerRadius: 4)
                    .stroke(Color.HPGray.system600,lineWidth: 1)
                    .frame(width: 20,height: 20)
                Image(systemName: "xmark")
                    .resizable()
                    .frame(width:8.1,height: 8.1)
                    .foregroundStyle(Color.HPGray.system600)
            }
        }).buttonStyle(.plain)
    }.padding(.horizontal, 20)
}
struct LeftRoundedRectangle: Shape {
    var cornerRadius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX + cornerRadius, y: rect.maxY))
        path.addArc(center: CGPoint(x: rect.minX + cornerRadius, y: rect.maxY - cornerRadius),
                    radius: cornerRadius, startAngle: .degrees(90), endAngle: .degrees(180),
                    clockwise: false)
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + cornerRadius))
        path.addArc(center: CGPoint(x: rect.minX + cornerRadius, y: rect.minY + cornerRadius),
                    radius: cornerRadius, startAngle: .degrees(180), endAngle: .degrees(270),
                    clockwise: false)
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        
        return path
    }
}
struct RightRoundedRectangle: Shape {
    var cornerRadius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - cornerRadius, y: rect.minY))
        path.addArc(center: CGPoint(x: rect.maxX - cornerRadius, y: rect.minY + cornerRadius),
                    radius: cornerRadius, startAngle: .degrees(270), endAngle: .degrees(0),
                    clockwise: false)
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - cornerRadius))
        path.addArc(center: CGPoint(x: rect.maxX - cornerRadius, y: rect.maxY - cornerRadius),
                    radius: cornerRadius, startAngle: .degrees(0), endAngle: .degrees(90),
                    clockwise: false)
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        return path
    }
}
#Preview {
    GeneralSettingView()
}
