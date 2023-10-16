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
        case .getOpendKeynotes:
            let _result = getOpendKeynotes()
            result = .stringArrayResult(_result)

        case .startPresentation(fileName: let fileName):
            startPresentation(filePath: fileName)
            result = .voidResult
        }
        return result
    }
}

// MARK: - Keynote Script
extension AppleScriptManager {
    /// 키노트가 열려있는지 여부 조회
    private func getIsActiveKeynoteApp() -> Bool? {
        var result: Bool?
        
        let scriptSource = """
        tell application "System Events"
            set isKeynoteRunning to (name of processes) contains "Keynote"
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
    
    /// 현재 열려있는 키노트 패스 리스트 생성
    private func getOpendKeynotes() -> [String] {
        var result: [String] = []
        
        let scriptSource = """
        tell application "Keynote"
            set documentList to {}
            repeat with aDocument in documents
                set documentPath to the file of aDocument
                set filePath to documentPath
                set end of documentList to POSIX path of filePath
            end repeat
            return documentList
        end tell
        """
        
        var error: NSDictionary?
        if let script = NSAppleScript(source: scriptSource) {
            if let documentList = script.executeAndReturnError(&error).coerce(toDescriptorType: typeAEList) {
                for index in 0...documentList.numberOfItems {
                    if let aDocument = documentList.atIndex(index) {
                        if let path = aDocument.stringValue {
                            result.append(path)
                        }
                    }
                }
            }
        }
        return result
    }
        
    /// 선택한 키노트 경로로 키노트 열기
    private func startPresentation(filePath: String) {
        let scriptSource = """
        tell application "Keynote"
            activate
            open "\(filePath)"
            tell document 1
                start from first slide
            end tell
        end tell
        """
        if let script = NSAppleScript(source: scriptSource) {
            var error: NSDictionary?
            script.executeAndReturnError(&error)
            if error != nil {
                fatalError("This Script Has Error")
            }
        }
    }
}
#endif
