//
//  SettingsView.swift
//  highpitch
//
//  Created by yuncoffee on 10/10/23.
//

/**
 사용자화 기능 필요
 */

import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(MediaManager.self)
    private var mediaStore
    @State private var selectedTab = 0
    
    var body: some View {
        
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
                    Image(systemName: "gearshape.fill")
                    Text("Feedback")
                }
                .tag(1)
        }
        .frame(minWidth: 508, idealWidth: 508, minHeight: 512, idealHeight: 512)
        .accentColor(Color.primary200)
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
        VStack(alignment: .leading) {
            Toggle(isOn: $isChecked1) {
                Text("전원 켜졌을 시 실행")
                    .systemFont(.caption, weight: .regular)
                    .foregroundStyle(Color("000000"))
            }
            Toggle(isOn: $isChecked2) {
                Text("메뉴 막대 아이콘 숨김")
                    .systemFont(.caption, weight: .regular)
                    .foregroundStyle(Color("000000"))
            }
            Toggle(isOn: $isChecked3) {
                Text("연습 녹음 저장 시 피드백 창 바로 띄우기")
                    .systemFont(.caption, weight: .regular)
                    .foregroundStyle(Color("000000"))
            }
            
            Divider()
            
            Text("단축키 설정")
                .systemFont(.caption, weight: .regular)
                .foregroundStyle(Color("000000"))
            HStack {
                Text("연습 녹음 시작")
                    .systemFont(.caption, weight: .regular)
                    .foregroundStyle(Color("000000"))
                Image(systemName: "play.fill")
                    .foregroundStyle(Color.gray600)
            }
            HStack {
                Text("연습 녹음 일시정지")
                    .systemFont(.caption, weight: .regular)
                    .foregroundStyle(Color("000000"))
                Image(systemName: "pause.fill")
                    .foregroundStyle(Color.gray600)
            }
            HStack {
                Text("연습 녹음 저장")
                    .systemFont(.caption, weight: .regular)
                    .foregroundStyle(Color("000000"))
                Image(systemName: "stop.fill")
                    .foregroundStyle(Color.gray600)
            }
            
        }
        .padding()
    }
}

struct SecondSettingsView: View {
    var body: some View {
        Text("두번째 탭")
    }
}
