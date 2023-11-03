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
    
    var recordStartCommand: String = UserDefaults.standard.string(forKey: "recordStartCommand") ?? "Default Value" {
        didSet {
            var keyCombinationArray = UserDefaults.standard.string(forKey: "recordStartCommand")!.split(separator: "+").map { String($0.trimmingCharacters(in: .whitespaces)) }
            let keykey = keyCombinationArray.last ?? ""
            
            if let keyEnum = Key(string: keykey) {
                var modifierArray : NSEvent.ModifierFlags = []
                for index in 0..<keyCombinationArray.count - 1 {
                    var temptemp = stringToModifierFlag(input: keyCombinationArray[index])
                    modifierArray.insert(temptemp)
                }
                hotkeySave = HotKey(key: keyEnum, modifiers: modifierArray)
            }
        }
    }
    
    var recordPauseCommand: String = UserDefaults.standard.string(forKey: "recordPauseCommand") ?? "Default Value"
    var recordSaveCommand: String = UserDefaults.standard.string(forKey: "recordSaveCommand") ?? "Default Value"
    
    var hotkeyStart = HotKey(key: .five, modifiers: [.command, .control])
    var hotkeyPause = HotKey(key: .space, modifiers: [.command, .control])
    var hotkeySave = HotKey(key: .escape, modifiers: [.command, .control])
    
    func stringToModifierFlag(input: String) -> NSEvent.ModifierFlags {
        if(input == "Command") {
            return NSEvent.ModifierFlags.command
        }
        if(input == "Option") {
            return NSEvent.ModifierFlags.option
        }
        if(input == "Control") {
            return NSEvent.ModifierFlags.control
        }
        return NSEvent.ModifierFlags.shift
    }
}
