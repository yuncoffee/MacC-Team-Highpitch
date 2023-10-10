//
//  HighPitchMacCApp.swift
//  HighPitchMacC
//
//  Created by yuncoffee on 10/9/23.
//

import SwiftUI
import SwiftData
import MenuBarExtraAccess


@main
struct HighPitchMacCApp: App {
    @State var isMenuPresented: Bool = false
    @State private var audioMediaManager = AudioMediaManager()
    /// 샘플 모델
//    var sharedModelContainer: ModelContainer = {
//        let schema = Schema([
//            Item.self,
//        ])
//        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
//
//        do {
//            return try ModelContainer(for: schema, configurations: [modelConfiguration])
//        } catch {
//            fatalError("Could not create ModelContainer: \(error)")
//        }
//    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowStyle(.hiddenTitleBar)
//        .modelContainer(sharedModelContainer)
        /// 앱 실행 시 사용할 수 있도록 조작하는 친구.
        MenuBarExtra("MenubarExtra", image: .appIcon24) {
            MenubarExtraView(isMenuPresented: $isMenuPresented)
                .environment(audioMediaManager)
        }
        .menuBarExtraAccess(isPresented: $isMenuPresented) { _ in }
        .defaultSize(width: .infinity, height: .infinity)
        .menuBarExtraStyle(.window)
        .commandsRemoved()

    }
}
