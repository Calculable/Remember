//
//  NotificationHelper.swift
//  Remember
//
//  Created by Jan Huber on 17.08.22.
//

import Foundation
import UserNotifications
import SwiftUI

class NotificationHelper {

    @AppStorage("notifications.days.before.event") private var daysBeforeEvent = 1
    @AppStorage("notification.time") private var timeOfNotifications = SettingsHelper.defaultNotificationTime()

    let notificationCenter = UNUserNotificationCenter.current()

    func removeNotification(forMemory memory: Memory) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [memory.id.uuidString]);
    }

    func updateNotification(forMemory memory: Memory) {

        removeNotification(forMemory: memory)

        if (memory.notificationsEnabled && !memory.isMarkedForDeletion) {
            let trigger = createNotificationTriggerFor(date: memory.date);
            tryToSendNotification(notificationTrigger: trigger, memory: memory)
        }
    }


    func updateNotifications(forMemories memories: Memories) {
        notificationCenter.removeAllPendingNotificationRequests()
        for memory in memories.memories {
            updateNotification(forMemory: memory)
        }
    }

    func tryToSendNotification(notificationTrigger: UNNotificationTrigger, memory: Memory) {
        Task.init {
            let isAuthorizedToSendNotification = await requestNotificationAuthorization()
            guard isAuthorizedToSendNotification else {
                return
            }
            self.sendNotification(notificationTrigger: notificationTrigger, memory: memory)
        }
    }

    private func notificationsAuthorized() async -> Bool {
        let center = notificationCenter
        let settings = await center.notificationSettings()
        return settings.authorizationStatus == .authorized
    }

    private func requestNotificationAuthorization() async -> Bool {
        let center = notificationCenter
        if (await notificationsAuthorized()) {
            return true
        } else {
            do {
                return try await center.requestAuthorization(options: [.alert, .badge, .sound])
            } catch let error {
                print("Error while requesting authorization from notification center: " + error.localizedDescription)
                return false
            }
        }

    }

    private func notificationTitle(daysBeforeEvent: Int) -> String {
        switch daysBeforeEvent {
        case 0: return String(localized: "New anniversary today")
        case 1: return String(localized: "New anniversary tomorrow")
        default: return String(localized: "New anniversary in \(daysBeforeEvent) days")
        }
    }

    private func notificationSubtitle(forMemory memory: Memory) -> String {
        return "\(memory.name) \(memory.date.formatted(date: .long, time: .omitted))"
    }

    private func createNotificationContent(forMemory memory: Memory) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = notificationTitle(daysBeforeEvent: daysBeforeEvent)
        content.subtitle = notificationSubtitle(forMemory: memory)
        content.sound = UNNotificationSound.default
        return content
    }


    private func sendNotification(notificationTrigger: UNNotificationTrigger, memory: Memory) {
        let notificationContent = createNotificationContent(forMemory: memory)

        // choose a random identifier
        let request = UNNotificationRequest(identifier: memory.id.uuidString, content: notificationContent, trigger: notificationTrigger)

        // add our notification request
        notificationCenter.add(request)
    }

    private func createNotificationDateComponents(forEventDate date: Date) -> DateComponents {
        var notificationDate = DateComponents()
        let shiftedDate = Calendar.current.date(byAdding: .day, value: -(daysBeforeEvent), to: date)!
        notificationDate.hour = Calendar.current.component(.hour, from: timeOfNotifications)
        notificationDate.minute = Calendar.current.component(.minute, from: timeOfNotifications)
        notificationDate.second = 0
        notificationDate.day = Calendar.current.component(.day, from: shiftedDate)
        notificationDate.month = Calendar.current.component(.month, from: shiftedDate)
        return notificationDate
    }


    private func createNotificationTriggerFor(date: Date) -> UNNotificationTrigger {
        let trigger = UNCalendarNotificationTrigger(dateMatching: createNotificationDateComponents(forEventDate: date), repeats: true) //repeat once per year
        return trigger;

    }

}
