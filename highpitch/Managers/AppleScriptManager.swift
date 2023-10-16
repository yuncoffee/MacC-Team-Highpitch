//
//  AppleScriptManager.swift
//  highpitch
//
//  Created by yuncoffee on 10/11/23.
//
#if os(macOS)
import Foundation

/// 애플 스크립트를 담당하는 매니저 클래스
@Observable
final class AppleScriptManager {
    /// AppleScript 실행함수
    public func runScript(_ script: CustomAppleScript) async -> AppleScriptResult? {
        var result: AppleScriptResult?
        switch script {
        case .isActiveKeynoteApp:
            if let _result = getIsActiveKeynoteApp() {
                result = .boolResult(_result)
            }
        }
        return result
    }
}

// MARK: - Keynote Script
extension AppleScriptManager {
    private func getIsActiveKeynoteApp() -> Bool? {
        var result: Bool?
        
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
            let scriptResult = script.executeAndReturnError(&error)

            if error != nil {
                fatalError("This Script Has Error")
            } else {
                result = scriptResult.booleanValue
            }
        }
        return result
    }
}
#endif
