//
//  Assignment.swift
//  StudyShift
//
//  Created by Đức Anh on 26/4/26.
//

import Foundation
import SwiftData

@Model
final class Assignment: UUIDIdentifiableModel {
    var id: UUID
    var title: String
    var assignmentType: AssignmentType
    var dueDate: Date
    var weight: Double
    var maxScore: Double
    var achievedScore: Double?
    var status: AssignmentStatus
    var note: String

    var course: Course?

    @Relationship(deleteRule: .cascade, inverse: \TodoTask.assignment)
    var tasks: [TodoTask] = []

    init(
        id: UUID = UUID(),
        title: String,
        assignmentType: AssignmentType,
        dueDate: Date,
        weight: Double,
        maxScore: Double = 100,
        achievedScore: Double? = nil,
        status: AssignmentStatus = .notStarted,
        note: String = "",
        course: Course? = nil
    ) {
        self.id = id
        self.title = title
        self.assignmentType = assignmentType
        self.dueDate = dueDate
        self.weight = weight
        self.maxScore = maxScore
        self.achievedScore = achievedScore
        self.status = status
        self.note = note
        self.course = course
    }

    var weightedScore: Double {
        guard let achievedScore else { return 0 }
        return achievedScore / maxScore * weight
    }
}
