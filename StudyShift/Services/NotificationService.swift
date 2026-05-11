//
//  NotificationService.swift
//  StudyShift
//
//  Created by Đức Anh on 11/5/26.
//

import Foundation
import UserNotifications

final class NotificationService {
    static let shared = NotificationService()

    private init() {}

    func requestPermission() async -> Bool {
        do {
            return try await UNUserNotificationCenter.current().requestAuthorization(
                options: [.alert, .sound, .badge]
            )
        } catch {
            print("Notification permission error:", error)
            return false
        }
    }

    func scheduleEventNotification(
        id: String,
        title: String,
        body: String,
        eventStartDate: Date,
        minutesBefore: Int
    ) async throws {
        let notificationDate = Calendar.current.date(
            byAdding: .minute,
            value: -minutesBefore,
            to: eventStartDate
        )

        guard let notificationDate else {
            return
        }

        guard notificationDate > Date() else {
            return
        }

        try await scheduleNotification(
            id: id,
            title: title,
            body: body,
            date: notificationDate
        )
    }

    func scheduleTaskNotification(
        id: String,
        title: String,
        body: String,
        reminderDate: Date
    ) async throws {
        guard reminderDate > Date() else {
            return
        }

        try await scheduleNotification(
            id: id,
            title: title,
            body: body,
            date: reminderDate
        )
    }

    func cancelNotification(id: String) {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: [id])
    }

    private func scheduleNotification(
        id: String,
        title: String,
        body: String,
        date: Date
    ) async throws {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        let components = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute],
            from: date
        )

        let trigger = UNCalendarNotificationTrigger(
            dateMatching: components,
            repeats: false
        )

        let request = UNNotificationRequest(
            identifier: id,
            content: content,
            trigger: trigger
        )

        try await UNUserNotificationCenter.current().add(request)
    }
    
}
