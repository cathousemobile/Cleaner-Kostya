//
//  AppNotificationService.swift
//

import Foundation
import NetworkExtension
import UIKit
//import ApphudSDK

public enum AppNotificationService {

    public enum Event {
        /// Статус пользователя изменился (есть или нет подписка)
        case contactDeleted

        var name: Notification.Name {
            switch self {
            case .contactDeleted:
                return Notification.Name("serverChanged")
            }
        }
    }

    public static func send(event: Event) {
        NotificationCenter.default.post(name: event.name, object: nil)
    }

    public static func observe(event: Event, clousure: @escaping() -> Void) {
        NotificationCenter.default.addObserver(
            forName: event.name,
            object: nil,
            queue: .main) { _ in
            clousure()
        }
    }

    public static func observe(events: Set<Event>, clousure: @escaping() -> Void) {
        events.forEach { observe(event: $0, clousure: clousure) }
    }
    
    public static func observe(event: Notification.Name, clousure: @escaping() -> Void) {
        NotificationCenter.default.addObserver(
            forName: event,
            object: nil,
            queue: .main) { _ in
            clousure()
        }
    }

    public static func observe(events: Set<Notification.Name>, clousure: @escaping() -> Void) {
        events.forEach { observe(event: $0, clousure: clousure) }
    }
}
