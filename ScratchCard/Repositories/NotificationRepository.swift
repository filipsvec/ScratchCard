//
//  NotificationRepository.swift
//  ScratchCard
//
//  Created by Filip Svec on 08/05/2023.
//

import Foundation
import UserNotifications

protocol NotificationRepository {

    func showNotification(title: String, text: String)
}

protocol NotificationManagerProtocol: AnyObject {
    
    var delegate: UNUserNotificationCenterDelegate? { get set }
    
    func add(_ request: UNNotificationRequest) async throws
    
    func requestAuthorization(options: UNAuthorizationOptions) async throws -> Bool
}

class RealNotificationRepository: NSObject, NotificationRepository {
    
    private let manager: NotificationManagerProtocol
    
    init(manager: NotificationManagerProtocol) {
        self.manager = manager
        super.init()
        manager.delegate = self
    }
    
    func showNotification(title: String, text: String) {
        Task {
            do {
                guard try await manager.requestAuthorization(options: [.alert, .sound]) else {
                    return
                }
                let content = UNMutableNotificationContent()
                let uuid = UUID().uuidString
                
                content.title = title
                content.subtitle = text
                content.sound = .default
                
                let request = UNNotificationRequest(identifier: uuid, content: content, trigger: nil)
                
                try await manager.add(request)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

extension RealNotificationRepository: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler( [.banner, .sound])
    }
}

extension UNUserNotificationCenter: NotificationManagerProtocol {
    
}
