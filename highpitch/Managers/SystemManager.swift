//
//  SystemManager.swift
//  highpitch
//
//  Created by yuncoffee on 11/2/23.
//

import Foundation
import HotKey
import AppKit

@Observable
final class SystemManager {
    private init() {}
    static let shared = SystemManager()
    var isDarkMode = false
    var isAnalyzing = false
    var hasUnVisited = false

    var isOverlayView1Active = true
    var isOverlayView2Active = true
    var isOverlayView3Active = true
    
    var recordStartCommand: String = 
        UserDefaults.standard.string(forKey: "recordStartCommand") ?? "Command + Control + P"
    var recordPauseCommand: String =
        UserDefaults.standard.string(forKey: "recordPauseCommand") ?? "Command + Control + Space"
    var recordSaveCommand: String = 
        UserDefaults.standard.string(forKey: "recordSaveCommand") ?? "Command + Control + Esc"
    
    var hotkeyStart = HotKey(key: .p, modifiers: [.command, .control])
    var hotkeyPause = HotKey(key: .space, modifiers: [.command, .control])
    var hotkeySave = HotKey(key: .escape, modifiers: [.command, .control])
}
