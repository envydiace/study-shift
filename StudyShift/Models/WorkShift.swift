//
//  WorkShift.swift
//  StudyShift
//
//  Created by Đức Anh on 26/4/26.
//

import Foundation
import SwiftData

@Model
final class WorkShift: UUIDIdentifiableModel {
    var id: UUID
    var title: String
    var workplace: String
    var startTime: Date
    var endTime: Date
    var colorHex: String
    var note: String

    init(
        id: UUID = UUID(),
        title: String = "Work Shift",
        workplace: String = "",
        startTime: Date,
        endTime: Date,
        colorHex: String = EventColorOption.defaultColor.hex,
        note: String = ""
    ) {
        self.id = id
        self.title = title
        self.workplace = workplace
        self.startTime = startTime
        self.endTime = endTime
        self.colorHex = colorHex
        self.note = note
    }

    var totalHours: Double {
        return endTime.timeIntervalSince(startTime) / 3600
    }

    var durationLabel: String {
        let totalMinutes = Int(endTime.timeIntervalSince(startTime) / 60)
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60
        if minutes == 0 {
            return "\(hours) h"
        }
        return "\(hours) h \(minutes) m"
    }
}
