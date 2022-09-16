//
//  NotificationHelper.swift
//  Remember
//
//  Created by Jan Huber on 17.08.22.
//

import Foundation
import UserNotifications
import SwiftUI

struct NotificationHelper {
    
    @AppStorage("notifications.days.before.event") private var daysBeforeEvent = 1
    @AppStorage("notification.time") private var timeOfNotifications = SettingsHelper.getDefaultNotificationTime()

    
    func removeNotification(for memory: Memory) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [memory.id.uuidString]);
    }
    
    func updateNotification(for memory: Memory) {
        
        removeNotification(for: memory)
        
        if (memory.notificationsEnabled) {
            let trigger = createNotificationTriggerFor(date: memory.date);
            tryToSendNotification(notificationTrigger: trigger, memory: memory)
        }
    }


    func updateNotifications(memories: Memories) {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        for memory in memories.memories {
            updateNotification(for: memory)
        }
    }

    func tryToSendNotification(notificationTrigger: UNNotificationTrigger, memory: Memory) {
        let center = UNUserNotificationCenter.current()

        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                sendNotification(notificationTrigger: notificationTrigger, memory: memory)
            } else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        sendNotification(notificationTrigger: notificationTrigger, memory: memory)
                    } else {
                        print("notifications not enabled")
                    }
                }
            }
        }
    }

    private func sendNotification(notificationTrigger: UNNotificationTrigger, memory: Memory) {
        let content = UNMutableNotificationContent()
        
        switch daysBeforeEvent {
            case 0: content.title = "New anniversary today"
            case 1: content.title = "New anniversary tomorrow"
            default: content.title = "New anniversary in \(daysBeforeEvent) days"
        }

        content.subtitle = "\(memory.name) \(memory.date.formatted(date: .long, time: .omitted))"
        content.sound = UNNotificationSound.default

        // choose a random identifier
        let request = UNNotificationRequest(identifier: memory.id.uuidString, content: content, trigger: notificationTrigger)

        // add our notification request
        UNUserNotificationCenter.current().add(request)
    }

    private func createNotificationTriggerFor(date: Date) -> UNNotificationTrigger {
        
        var notificationDate = DateComponents()
        notificationDate.hour = Calendar.current.component(.hour, from: timeOfNotifications)
        notificationDate.minute = Calendar.current.component(.minute, from: timeOfNotifications)
        notificationDate.second = 0
        
        let shiftedDate = Calendar.current.date(byAdding: .day, value: -(daysBeforeEvent), to: date)!
        
        notificationDate.day = Calendar.current.component(.day, from: shiftedDate)
        notificationDate.month = Calendar.current.component(.month, from: shiftedDate)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: notificationDate, repeats: true) //repeat once per year
        return trigger;
        
    }

}
