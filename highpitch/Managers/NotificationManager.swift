//
//  NotificationManager.swift
//  highpitch
//
//  Created by yuncoffee on 10/13/23.
//
import Foundation
import SwiftUI
import UserNotifications
import CoreLocation

@MainActor
final class NotificationManager :NSObject,ObservableObject {
    static let shared = NotificationManager()
    let notificationCenter = UNUserNotificationCenter.current()
    @Published var name: String?
    
    override init() {
        super.init()
        notificationCenter.delegate = self
    }
    
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        notificationCenter.requestAuthorization(options: options) { (success, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("SUCCESS")
            }
        }
    }
    
    func sendNotification(name: String) {
        let content = UNMutableNotificationContent()
        content.title = "HighPitch"
        content.subtitle = "분석 결과가 도착했어요"
        content.sound = .default
        content.badge = 1
        content.userInfo = ["name" : name]
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval:1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        notificationCenter.add(request)
    }
    
    func cancelNotification() {
        notificationCenter.removeAllPendingNotificationRequests()
    }
}
extension NotificationManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse) async {
        if let value = response.notification.request.content.userInfo["name"] as? String {
            NotificationCenter.default.post(name: Notification.Name("projectName"), object: value)
        }
        
    }
    
}

enum NextView: String,Identifiable {
    case view1,view2
    var id: String {
        self.rawValue
    }
    @ViewBuilder
    func helloView() -> some View {
        switch self {
        case .view1:
            Text("")
        case .view2:
            Text("")
        }
    }
}
