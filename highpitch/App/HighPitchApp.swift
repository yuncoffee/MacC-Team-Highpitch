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
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.openWindow) var openWindow
    
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
        
    @State
    var refreshable = false
    
    @State
    var menubarAnimationCount = 0 {
        didSet {
            if menubarAnimationCount > 6 {
                menubarAnimationCount = 0
            } else if SystemManager.shared.isAnalyzing {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    menubarAnimationCount += 1
                }
            }
        }
    }
    
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
        #if os(macOS)
        // MARK: - MainWindow Scene
//        Window("overlay", id: "overlay") {
//            @Bindable var systemManager = SystemManager.shared
//            if systemManager.isOverlayView1Active {
//                OverlayView(isActive: $systemManager.isOverlayView1Active)
//            }
//        }
//        .windowResizability(.contentSize)
//        Window("overlay2", id: "overlay2") {
//            @Bindable var systemManager = SystemManager.shared
//            if systemManager.isOverlayView2Active {
//                OverlayView(isActive: $systemManager.isOverlayView2Active)
//            }
//        }
//        .windowResizability(.contentSize)
//        Window("overlay3", id: "overlay3") {
//            @Bindable var systemManager = SystemManager.shared
//            if systemManager.isOverlayView3Active {
//                OverlayView(isActive: $systemManager.isOverlayView3Active)
//            }
//        }
//        .windowResizability(.contentSize)
//        .defaultPosition(.bottomTrailing)
//        .windowResizability(.contentSize)
//        .commandsRemoved()
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
        MenuBarExtra {
            MenubarExtraView(
                refreshable: $refreshable,
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
                .introspectMenuBarExtraWindow { window in
                    window.animationBehavior = .utilityWindow
                }
        } label: {
            if SystemManager.shared.isDarkMode {
                if SystemManager.shared.isAnalyzing {
                    Label("MenubarExtra", image: "menubar-loading-light-\(menubarAnimationCount)")
                } else if SystemManager.shared.hasUnVisited {
                    Label("MenubarExtra", image: "menubar-noti-dark")
                } else {
                    Label("MenubarExtra", image: "menubarextra")
                }
                
            } else {
                if SystemManager.shared.isAnalyzing {
                    Label("MenubarExtra", image: "menubar-loading-light-\(menubarAnimationCount)")
                } else if SystemManager.shared.hasUnVisited {
//                    Image(systemName: "note.text.badge.plus")
                    Image("test-noti")
                        .renderingMode(.template)
                        .foregroundStyle(.red, .blendMode(.overlay))
                } else {
                    Label("MenubarExtra", image: "menubarextra")
                }
            }
        }
        .menuBarExtraStyle(.window)
        .menuBarExtraAccess(isPresented: $isMenuPresented)
        .commandsRemoved()
        .onChange(of: isMenuPresented, { _, newValue in
            refreshable = newValue
        })
        .onChange(of: mediaManager.isRecording, { _, newValue in
            print("TEST!!!!")
            if !newValue {
                menubarAnimationCount += 1
            }
        })
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
