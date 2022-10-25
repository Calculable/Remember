//
//  NotificationSettingsView-ViewModel.swift
//  Remember
//
//  Created by Jan Huber on 21.10.22.
//

import Foundation

extension NotificationSettingsView {
    @MainActor class ViewModel: ObservableObject {


        let notificationsHelper = NotificationHelper()
        let availableNotificationDaysBeforeEvent = 0...7

        func describeDaysBeforeEvent(_ daysBeforeEvent: Int) -> String {
            switch (daysBeforeEvent) {
            case 0:
                return String(localized: "On the same day")
            case 1:
                return String(localized: "1 day before the event")
            default:
                return String(format: NSLocalizedString("%d days before the event", comment: "number of days before the event"), daysBeforeEvent)

            }
        }


    }
}
