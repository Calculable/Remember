import Foundation
import UserNotifications
import SwiftUI


/// Contains helper functions to work with the notification center
class NotificationHelper {
    
    /// describes how many days before an anniversary a local notification should be triggeret
    @AppStorage("notifications.days.before.anniversary") private var daysBeforeAnniversary = 1
    
    /// describes at which time of the day notifications should be triggeret
    @AppStorage("notification.time") private var timeOfNotifications = SettingsHelper.defaultNotificationTime()
    
    private let notificationCenter = UNUserNotificationCenter.current()
    
    /// removes all pending notifications for a memory
    /// - Parameter memory: the memory for which all pending notifications should be removed
    func removeNotification(forMemory memory: Memory) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [memory.id.uuidString]);
    }
    
    /// updating pending notifications for a memory should always be done if something about the memory was changed: for example the title or the date. Otherwise the user would receive notifications with outdated-information
    /// - Parameter memories: the memory for which all pending notifications should be updated
    func updateNotifications(forMemories memories: Memories) {
        notificationCenter.removeAllPendingNotificationRequests()
        for memory in memories.memories {
            updateNotification(forMemory: memory)
        }
    }
    
    /// Sends a local notification. If the notification cannot be pushed to the device (for example because the user has deactivated notifications), the notification is ignored
    /// - Parameters:
    ///   - notificationTrigger: the trigger that describes when the notification should be sent
    ///   - memory: the memory for which a notification should be generated
    func tryToSendNotification(notificationTrigger: UNNotificationTrigger, memory: Memory) {
        Task.init {
            let isAuthorizedToSendNotification = await requestNotificationAuthorization()
            guard isAuthorizedToSendNotification else {
                return
            }
            self.sendNotification(notificationTrigger: notificationTrigger, memory: memory)
        }
    }
    
    private func updateNotification(forMemory memory: Memory) {
        
        removeNotification(forMemory: memory)
        
        if (memory.notificationsEnabled && !memory.isMarkedForDeletion) {
            let trigger = createNotificationTriggerFor(date: memory.date);
            tryToSendNotification(notificationTrigger: trigger, memory: memory)
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
        return "\(memory.name): \(memory.date.formatted(date: .long, time: .omitted))"
    }
    
    private func createNotificationContent(forMemory memory: Memory) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = notificationTitle(daysBeforeEvent: daysBeforeAnniversary)
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
        let shiftedDate = Calendar.current.date(byAdding: .day, value: -(daysBeforeAnniversary), to: date)!
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
