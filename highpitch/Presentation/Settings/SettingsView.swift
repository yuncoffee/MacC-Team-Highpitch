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
    
    @State
    private var systemManager: SystemManager = SystemManager.shared
    
    var body: some View {

        TabView(selection: $selectedTab) {
            // 첫 번째 탭
            GeneralSettingView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("General")
                }
                .tag(0)
                
            // 두 번째 탭
            FeedbackSettingView()
                .tabItem {
                    Image(systemName: "pencil")
                    Text("Feedback")
                }
                .tag(1)
        }
        .frame(minWidth: 508, idealWidth: 508, minHeight: 512, idealHeight: 512, alignment: .topLeading)
        .background(Color.HPGray.systemWhite)
        
    }
}

#Preview {
    SettingsView()
        .environment(MediaManager())
}
