//
//  PersonalEvent.swift
//  StudyShift
//
//  Created by Đức Anh on 6/5/26.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class PersonalEvent: UUIDIdentifiableModel {
    var id = UUID()
    var title: String
    var startDate: Date?
    var endDate: Date?
    var location: String?
    var notes: String?
    var colorHex: String
    
    var notificationEnabled: Bool
    var reminderMinutesBefore: Int?
    var notificationId: String?

    init(
        id: UUID = UUID(),
        title: String,
        startDate: Date? = nil,
        endDate: Date? = nil,
        location: String? = nil,
        notes: String? = nil,
        colorHex: String,
        notificationEnabled: Bool = false,
        reminderMinutesBefore: Int? = nil,
        notificationId: String? = nil
    ) {
        self.id = id
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        self.location = location
        self.notes = notes
        self.colorHex = colorHex
        self.notificationEnabled = notificationEnabled
        self.reminderMinutesBefore = reminderMinutesBefore
        self.notificationId = notificationId
    }
}
