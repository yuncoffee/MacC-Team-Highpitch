//
//  AppleScriptModel.swift
//  highpitch
//
//  Created by yuncoffee on 10/11/23.
//

import Foundation

enum AppleScriptResult {
    case boolResult(Bool)
    case stringArrayResult([String])
    case voidResult
    case error(String)
}

enum CustomAppleScript {
    case isActiveKeynoteApp
    case getOpendKeynotes
    case startPresentation(fileName: String)
}
