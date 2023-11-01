//
//  App.swift
//  highpitch
//
//  Created by yuncoffee on 10/10/23.
//

import SwiftUI
import SwiftData
import MenuBarExtraAccess
import SettingsAccess
import HotKey

@main
struct HighpitchApp: App {
    // MARK: - 데이터 컨트롤을 위한 매니저 객체 선언(전역 싱글 인스턴스)
    @State
    private var fileSystemManager = FileSystemManager()
    @State
    private var mediaManager = MediaManager()
    @State 
    private var projectManager = ProjectManager()
    #if os(macOS)
    @State 
    private var appleScriptManager = AppleScriptManager()
    @State 
    private var keynoteManager = KeynoteManager()
    @State
    private var practiceManager = PracticeManager()
    @State
    private var isMenuPresented: Bool = false
    #endif
    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State
    private var selectedProject: ProjectModel?
    @State
    private var selectedKeynote: OpendKeynote?
    
    // HotKeys
    let hotkeyStart = HotKey(key: .f5, modifiers: [.command, .control])
    let hotkeyPause = HotKey(key: .space, modifiers: [.command, .control])
    let hotkeySave = HotKey(key: .escape, modifiers: [.command, .control])
    
    let container: ModelContainer
    
    init() {
        do {
            container = try ModelContainer(for: ProjectModel.self, configurations: ModelConfiguration())
        } catch {
            fatalError("Could not initialize ModelContainer")
        }
    }

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
        Window("mainwindow", id: "main") {
            MainWindowView()
                .environment(appleScriptManager)
                .environment(fileSystemManager)
                .environment(keynoteManager)
                .environment(mediaManager)
                .environment(projectManager)
                .modelContainer(container)
                .onAppear {
                    hotkeyStart.keyDownHandler = playPractice
                    hotkeyPause.keyDownHandler = projectManager.pausePractice
                    hotkeySave.keyDownHandler = stopPractice
                }
        }
        .defaultSize(width: 1080, height: 600)
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
        // MARK: - Settings Scene
        Settings {
            SettingsView()
                .environment(appleScriptManager)
                .environment(keynoteManager)
                .environment(mediaManager)
                .modelContainer(container)
        }
        // MARK: - MenubarExtra Scene
        MenuBarExtra("MenubarExtra", 
//                     image: practiceManager.isAnalyzing
//                     ? .ESC
//                     : .menubarextra
                     image : .menubarextra
        ) {
            MenubarExtraView(
                isMenuPresented: $isMenuPresented,
                selectedProject: $selectedProject,
                selectedKeynote: $selectedKeynote
            )
                .environment(appleScriptManager)
                .environment(fileSystemManager)
                .environment(keynoteManager)
                .environment(mediaManager)
                .environment(projectManager)
                .openSettingsAccess()
                .modelContainer(container)
                .onAppear(perform: {
                    practiceManager.isAnalyzing = false
                })
        }
//        .onChange(of: practiceManager.isAnalyzing, { oldValue, newValue in
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                practiceManager.isAnalyzing.toggle()
//            }
//        })
        .menuBarExtraAccess(isPresented: $isMenuPresented)
        .menuBarExtraStyle(.window)
        .commandsRemoved()
        #endif
    }
    func updateWeatherData() async {
        // fetches new weather data and updates app state
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
    
    func playPractice() {
        projectManager.playPractice(
            selectedKeynote: selectedKeynote,
            selectedProject: selectedProject,
            appleScriptManager: appleScriptManager,
            keynoteManager: keynoteManager,
            mediaManager: mediaManager
        )
    }
    
    func stopPractice() {
        Task {
            await MainActor.run {
                projectManager.stopPractice(
                    mediaManager: mediaManager,
                    keynoteManager: keynoteManager,
                    modelContext: container.mainContext
                )
            }
        }
    }
}
