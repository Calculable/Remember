//
//  NotificationHelper.swift
//  Remember
//
//  Created by Jan Huber on 17.08.22.
//

import Foundation
import UserNotifications

func tryToSendNotification() {
    let center = UNUserNotificationCenter.current()

    center.getNotificationSettings { settings in
        if settings.authorizationStatus == .authorized {
            sendNotification()
        } else {
            center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                if success {
                    sendNotification()
                } else {
                    print("notifications not enabled")
                }
            }
        }
    }
}

private func sendNotification() {
    let content = UNMutableNotificationContent()
    content.title = "Feed the cat"
    content.subtitle = "It looks hungry"
    content.sound = UNNotificationSound.default

    // show this notification five seconds from now
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

    // choose a random identifier
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

    // add our notification request
    UNUserNotificationCenter.current().add(request)
}

