//
//  GAManager.swift
//  highpitch
//
//  Created by yuncoffee on 11/5/23.
//

import Foundation
import FirebaseAnalyticsSwift
import FirebaseAnalytics

enum GAClickEventType: String {
    case play = "play_button"
    case stop = "stop_button"
    case home = "home_button"
    case history = "history_button"
    case notification = "notification_button"
    case menubarClick = "menubar_click"
    
}

final class GAManager {
    private init() {}
    static let shared = GAManager()
    
    func analyticsOnClick(_ gaType: GAClickEventType) {
        Analytics.logEvent("menubarExtra_click_button", parameters: ["type": gaType.rawValue])
    }
}
