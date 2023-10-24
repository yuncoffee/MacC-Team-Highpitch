//
//  SettingsView.swift
//  highpitch
//
//  Created by yuncoffee on 10/10/23.
//

/**
 사용자화 기능 필요
 */
import AppKit
import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(MediaManager.self)
    private var mediaStore
    @State private var selectedTab = 0
    @State private var isAlertActive = false
    
//    init() {
//        // 사용자 정의 TabView 스타일을 생성
//        let appearance = UITabBarAppearance()
//        appearance.selectionIndicatorTintColor = .purple
//        
//        // 모든 TabView에서 사용할 수 있도록 전역적으로 설정
//        UITabBar.appearance().scrollEdgeAppearance = appearance
//        UITabBar.appearance().compactAppearance = appearance
//    }
    
    var body: some View {
        
//        VStack {
//            Image(.settingView1)
//                .resizable()
//                .scaledToFill()
//                .onTapGesture {
//                    isAlertActive = true
//                }
//                .alert(isPresented: $isAlertActive) {
//                    Alert(title: Text("준비 중입니다!"))
//                }
//        }
//        .frame(width: 508, height: 512)
        TabView(selection: $selectedTab) {
            // 첫 번째 탭
            FirstSettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("General")
                }
                .tag(0)
                
            // 두 번째 탭
            SecondSettingsView()
                .tabItem {
                    Image(systemName: "pencil")
                    Text("Feedback")
                }
                .tag(1)
        }
        .frame(minWidth: 508, idealWidth: 508, minHeight: 512, idealHeight: 512, alignment: .topLeading)
        .background(Color.white)
        
    }
}

#Preview {
    SettingsView()
        .environment(MediaManager())
}

struct FirstSettingsView: View {
    
    @State private var isChecked1 = false
    @State private var isChecked2 = false
    @State private var isChecked3 = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
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
                    .foregroundStyle(Color("000000"))
                HStack {
                    Text("연습 녹음 시작")
                        .systemFont(.caption, weight: .regular)
                        .foregroundStyle(Color("000000"))
                    Image(systemName: "play.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(Color.gray600)
                        .frame(width: 16, height: 16)
                    Image(.F_5)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 20)
                        .padding(.horizontal, 20)
                }
                HStack {
                    Text("연습 녹음 일시정지")
                        .systemFont(.caption, weight: .regular)
                        .foregroundStyle(Color("000000"))
                    Image(systemName: "pause.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(Color.gray600)
                        .frame(width: 16, height: 16)
                    Image(.space)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 20)
                        .padding(.horizontal, 20)
                }
                HStack {
                    Text("연습 녹음 저장")
                        .systemFont(.caption, weight: .regular)
                        .foregroundStyle(Color("000000"))
                    Image(systemName: "stop.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(Color.gray600)
                        .frame(width: 16, height: 16)
                    Image(.ESC)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 20)
                        .padding(.horizontal, 20)
                }
            }
            
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 24)
        .frame(alignment:. topLeading)
    }
}

struct SecondSettingsView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Image(.feedback)
                .resizable()
                .scaledToFit()
        }
        .frame(width: 508, height: 452)
    }
}
