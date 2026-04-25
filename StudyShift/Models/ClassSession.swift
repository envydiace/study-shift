//
//  ClassSession.swift
//  StudyShift
//
//  Created by Đức Anh on 26/4/26.
//

import Foundation
import SwiftData

@Model
final class ClassSession {
    var id = UUID()
    var title: String
    var sessionType: ClassSessionType
    var location: String
    var dayOfWeek: Weekday
    var startTime: Date
    var endTime: Date
    var isRepeatingWeekly: Bool

    var subject: Subject?

    init(
        id: UUID = UUID(),
        title: String,
        sessionType: ClassSessionType,
        location: String = "",
        dayOfWeek: Weekday,
        startTime: Date,
        endTime: Date,
        isRepeatingWeekly: Bool = true,
        subject: Subject? = nil
    ) {
        self.id = id
        self.title = title
        self.sessionType = sessionType
        self.location = location
        self.dayOfWeek = dayOfWeek
        self.startTime = startTime
        self.endTime = endTime
        self.isRepeatingWeekly = isRepeatingWeekly
        self.subject = subject
    }
}
