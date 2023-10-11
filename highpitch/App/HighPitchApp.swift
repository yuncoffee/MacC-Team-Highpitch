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
    @State private var mediaManager = MediaManager()
    // MARK: - SwiftData
    let container: ModelContainer
    
    var body: some Scene {
        WindowGroup {
            MainWindowView()
                .environment(mediaManager)
        }
        .modelContainer(container)
        
        #if os(macOS)
        Settings {
            SettingsView()
                .environment(mediaManager)
        }
        .modelContainer(container)
        
        MenuBarExtra("MenubarExtra", systemImage: "heart") {
            MenubarExtraView()
                .environment(mediaManager)
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
    }
}
