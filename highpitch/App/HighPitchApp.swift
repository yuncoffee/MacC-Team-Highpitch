//
//  App.swift
//  highpitch
//
//  Created by yuncoffee on 10/10/23.
//

import SwiftUI
import SwiftData

@main
struct HighpitchApp: App {
    // MARK: - 데이터 컨트롤을 위한 매니저 객체 선언(전역 싱글 인스턴스)
    @State private var mediaManager = MediaManager()
    @State private var projectManager = ProjectManager()
    #if os(macOS)
    @State private var appleScriptManager = AppleScriptManager()
    @State private var keynoteManager = KeynoteManager()
    #endif
    
    // MARK: - SwiftData Container
    let container: ModelContainer
    
    var body: some Scene {
        #if os(iOS)
        /// iOS Sample
        WindowGroup {
            VStack(content: {
                Text("Placeholder")
            })
        }
        #endif
        #if os(macOS)
        // MARK: - MainWindow Scene
        WindowGroup {
            MainWindowView()
                .environment(appleScriptManager)
                .environment(keynoteManager)
                .environment(mediaManager)
                .environment(projectManager)
        }
        .modelContainer(container)
        .defaultSize(width: 1000, height: 600)
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentMinSize)
        #endif
        #if os(macOS)
        // MARK: - Settings Scene
        Settings {
            SettingsView()
                .environment(appleScriptManager)
                .environment(mediaManager)
                .environment(keynoteManager)
        }
        .modelContainer(container)
        // MARK: - MenubarExtra Scene
        MenuBarExtra("MenubarExtra", systemImage: "heart") {
            MenubarExtraView()
                .environment(appleScriptManager)
                .environment(mediaManager)
                .environment(keynoteManager)
        }
        .modelContainer(container)
        #endif
    }
    
    init() {
        do {
            container = try ModelContainer(for: Sample.self)
        } catch {
            fatalError("Failed to create ModelContainer for Sample")
        }
        setupInit()
    }
}

extension HighpitchApp {
    private func setupInit() {
        #if os(macOS)
        Task {
            let result = await appleScriptManager.runScript(.isActiveKeynoteApp)
            if case .boolResult(let isKeynoteOpen) = result {
                // logic 1
                if isKeynoteOpen {
                    print("열려있습니다")
                } else {
                    print("닫혀있습니다")
                }
            }
        }
        #endif
    }
}
