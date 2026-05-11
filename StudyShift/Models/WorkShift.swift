//
//  WorkShift.swift
//  StudyShift
//
//  Created by Đức Anh on 26/4/26.
//

import Foundation
import SwiftData

@Model
final class WorkShift {
    var id: UUID
    var title: String
    var workplace: String
    var startTime: Date
    var endTime: Date
    var note: String

    init(
        id: UUID = UUID(),
        title: String = "Work Shift",
        workplace: String = "",
        startTime: Date,
        endTime: Date,
        note: String = ""
    ) {
        self.id = id
        self.title = title
        self.workplace = workplace
        self.startTime = startTime
        self.endTime = endTime
        self.note = note
    }

    var totalHours: Double {
//        let duration = endTime.timeIntervalSince(startTime) / 3600
//        let breakHours = Double(breakMinutes) / 60
//        return max(duration - breakHours, 0)
        return endTime.timeIntervalSince(startTime) / 3600
    }
}
