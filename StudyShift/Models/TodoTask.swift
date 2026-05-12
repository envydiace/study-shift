//
//  TodoTask.swift
//  StudyShift
//
//  Created by Đức Anh on 26/4/26.
//

import Foundation
import SwiftData

@Model
final class TodoTask: UUIDIdentifiableModel {
    var id: UUID
    var title: String
    var note: String
    var dueDate: Date?
    var isCompleted: Bool
    var priority: TaskPriority
    var createdAt: Date
    var scheduledStart: Date?
    var scheduledEnd: Date?

    var course: Course?
    var assignment: Assignment?

    init(
        id: UUID = UUID(),
        title: String,
        note: String = "",
        dueDate: Date? = nil,
        isCompleted: Bool = false,
        priority: TaskPriority = .medium,
        createdAt: Date = Date(),
        scheduledStart: Date? = nil,
        scheduledEnd: Date? = nil,
        course: Course? = nil,
        assignment: Assignment? = nil
    ) {
        self.id = id
        self.title = title
        self.note = note
        self.dueDate = dueDate
        self.isCompleted = isCompleted
        self.priority = priority
        self.createdAt = createdAt
        self.scheduledStart = scheduledStart
        self.scheduledEnd = scheduledEnd
        self.course = course
        self.assignment = assignment
    }

    var isScheduled: Bool {
        scheduledStart != nil && scheduledEnd != nil
    }

    var scheduledDurationHours: Double {
        guard let scheduledStart, let scheduledEnd else { return 0 }
        return max(scheduledEnd.timeIntervalSince(scheduledStart) / 3600, 0)
    }
}
