//
//  AppleScriptsManager.swift
//  HighPitchMacC
//
//  Created by yuncoffee on 10/9/23.
//

import Foundation

final class AppleScriptsManager: ObservableObject {
    static let shared = AppleScriptsManager()
    private init() {}
    
    public func runAppleScript(scriptSource: AppleScriptEnum, param: String = "") async -> Any? {
        var result: Any?
        switch scriptSource {
        case .isActiveKeynoteApp:
            result = getIsActiveKeynoteApp()
        case .getCurrentKeynoteProcessList:
            result = getCurrentKeynoteProcessList()
        case .bringToFrontKeynote:
            result = bringFrontKeynoteFile(fileName: param)
        }
        return result
    }
}

extension AppleScriptsManager {
    private func getIsActiveKeynoteApp() -> Bool {
        let scriptSource = """
        tell application "System Events"
            if (name of processes) contains "Keynote" then
                return true
            else
                return false
            end if
        end tell
        """
        
        if let script = NSAppleScript(source: scriptSource) {
            var error: NSDictionary?
            return script.executeAndReturnError(&error).booleanValue
        } else {
            return false
        }
    }
    
    private func getCurrentKeynoteProcessList() -> [String] {
        let scriptSource = """
        tell application "Keynote"
            set documentList to {}
            repeat with aDocument in documents

                set documentPath to the file of aDocument

                set end of documentList to documentPath
            end repeat
            return documentList
        end tell
        """
        
        var processInfoList: [String] = []
        
        if let script = NSAppleScript(source: scriptSource) {
            var error: NSDictionary?
            if let arr = script.executeAndReturnError(&error).coerce(toDescriptorType: typeAEList) {
                
                for idx in 1...arr.numberOfItems {
                    if let item = arr.atIndex(idx) {
                        if let stringValue = item.stringValue {
                            processInfoList.append(stringValue)
                        }
                    }
                }
            }
        }
        return processInfoList
    }
    
    private func bringFrontKeynoteFile(fileName: String) {
        let scriptSource = """
                
        tell application "Keynote"
            activate
            open alias "\(fileName)"
            tell document 1
                start from first slide
            end tell
            
        end tell
        """
        if let script = NSAppleScript(source: scriptSource) {
            var error: NSDictionary?
            script.executeAndReturnError(&error)
//            print(script.executeAndReturnError(&error))
        }
        
    }
}



//if running of application "Keynote" is true then
//    tell application "Keynote"
//        activate
//        try
//            if playing is false then start the front document
//        end try
//    end tell
//end if



