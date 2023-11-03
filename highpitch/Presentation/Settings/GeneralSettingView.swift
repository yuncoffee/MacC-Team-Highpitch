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
    
    @State var keyPressedArray = ["Text1", "Text2", "Text3"]
    @State var clickIndex = 0
    @State var isMonitoringEnabled = false
    @State var nsevent: Any?
    
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
                    HotKeySettingButton1(textString: $keyPressedArray[0], clickIndexHere: $clickIndex, isMonitoringEnabled: $isMonitoringEnabled)
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
                    HotKeySettingButton2(textString: $keyPressedArray[1], clickIndexHere: $clickIndex, isMonitoringEnabled: $isMonitoringEnabled)
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
                    HotKeySettingButton3(textString: $keyPressedArray[2], clickIndexHere: $clickIndex, isMonitoringEnabled: $isMonitoringEnabled)
                }
            }
            
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 24)
        .frame(alignment:. topLeading)
        .onChange(of: isMonitoringEnabled) { _, newValue in
            if newValue {
                startMonitoring()
            } else {
                stopMonitoring()
            }
        }
        .onTapGesture {
            print("isMonitorEnabled = false")
            isMonitoringEnabled = false
        }
    }
    
    private func startMonitoring() {
        nsevent = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { (event) -> NSEvent? in
            if let characters = event.charactersIgnoringModifiers {
                var keyChar = characters.unicodeScalars.first!.description.uppercased()
                var keyDescription = ""
                
                keyChar = isKoreanCharacter(char: keyChar)

                if event.modifierFlags.contains(.command) {
                    keyDescription += "Command + "
                }
                if event.modifierFlags.contains(.option) {
                    keyDescription += "Option + "
                }
                if event.modifierFlags.contains(.control) {
                    keyDescription += "Control + "
                }
                if event.modifierFlags.contains(.shift) {
                    keyDescription += "Shift + "
                }

                keyDescription += "\(keyChar)"
                if clickIndex >= 0 && clickIndex <= 2 {
                    keyPressedArray[clickIndex] = keyDescription
                }

                //return event
            }
            return event
                
        }
    }

    private func stopMonitoring() {
        NSEvent.removeMonitor(nsevent!)
    }
    
    private func isKoreanCharacter(char: String) -> String {
        // 한글 자음 범위로 제한
        let koreanConsonants: [String:String] = [
            "ㅂ":"Q", "ㅈ":"W", "ㄷ":"E", "ㄱ":"R", "ㅅ":"T",
            "ㅛ":"Y", "ㅕ":"U", "ㅑ":"I", "ㅐ":"O", "ㅔ":"P",
            "ㅁ":"A", "ㄴ":"S", "ㅇ":"D", "ㄹ":"F", "ㅎ":"G",
            "ㅗ":"H", "ㅓ":"J", "ㅏ":"K", "ㅣ":"L", "ㅋ":"Z",
            "ㅌ":"X", "ㅊ":"C", "ㅍ":"V", "ㅠ":"B", "ㅜ":"N",
            "ㅡ":"M", "ㅃ":"Q", "ㅉ":"W", "ㄸ":"E", "ㄲ":"R",
            "ㅆ":"T", "ㅒ":"O", "ㅖ":"P"
        ]

        if koreanConsonants.keys.contains(char) {
            return koreanConsonants[char]!
        }
        return char
    }
    
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

struct HotKeySettingButton1: View {
    @Binding var textString: String
    @Binding var clickIndexHere: Int
    @Binding var isMonitoringEnabled: Bool
    
    var body: some View {
        HStack(spacing:0) {
            Button(action: {
                clickIndexHere = 0
                isMonitoringEnabled = true
                print("isMonitorEnabled = false -> 0")
            }, label: {
                ZStack {
                    LeftRoundedRectangle(cornerRadius: 4)
                        .stroke(Color.HPGray.system600,lineWidth: 1)
                        .frame(width: 140,height: 20)
                    Text(textString)
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
}

struct HotKeySettingButton2: View {
    @Binding var textString: String
    @Binding var clickIndexHere: Int
    @Binding var isMonitoringEnabled: Bool
    
    var body: some View {
        HStack(spacing:0) {
            Button(action: {
                clickIndexHere = 1
                isMonitoringEnabled = true
                print("isMonitorEnabled = false -> 1")
            }, label: {
                ZStack {
                    LeftRoundedRectangle(cornerRadius: 4)
                        .stroke(Color.HPGray.system600,lineWidth: 1)
                        .frame(width: 140,height: 20)
                    Text(textString)
                        .systemFont(.caption2,weight: .semibold)
                        .foregroundStyle(Color.HPTextStyle.darker)
                }
            }).buttonStyle(.plain)
            Button(action: {}, label: {
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
}

struct HotKeySettingButton3: View {
    @Binding var textString: String
    @Binding var clickIndexHere: Int
    @Binding var isMonitoringEnabled: Bool
    
    var body: some View {
        HStack(spacing:0) {
            Button(action: {
                clickIndexHere = 2
                print("isMonitorEnabled = false -> 2")
                isMonitoringEnabled = true
            }, label: {
                ZStack {
                    LeftRoundedRectangle(cornerRadius: 4)
                        .stroke(Color.HPGray.system600,lineWidth: 1)
                        .frame(width: 140,height: 20)
                    Text(textString)
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
}

#Preview {
    GeneralSettingView()
}
