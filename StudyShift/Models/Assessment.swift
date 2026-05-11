//
//  Assessment.swift
//  StudyShift
//
//  Created by Đức Anh on 26/4/26.
//

import Foundation
import SwiftData

@Model
final class Assessment: UUIDIdentifiableModel {
    var id: UUID
    var title: String
    var assessmentType: AssessmentType
    var dueDate: Date
    var weight: Double
    var maxScore: Double
    var achievedScore: Double?
    var status: AssessmentStatus
    var note: String

    var subject: Subject?

    @Relationship(deleteRule: .cascade, inverse: \TodoTask.assessment)
    var tasks: [TodoTask] = []

    init(
        id: UUID = UUID(),
        title: String,
        assessmentType: AssessmentType,
        dueDate: Date,
        weight: Double,
        maxScore: Double = 100,
        achievedScore: Double? = nil,
        status: AssessmentStatus = .notStarted,
        note: String = "",
        subject: Subject? = nil
    ) {
        self.id = id
        self.title = title
        self.assessmentType = assessmentType
        self.dueDate = dueDate
        self.weight = weight
        self.maxScore = maxScore
        self.achievedScore = achievedScore
        self.status = status
        self.note = note
        self.subject = subject
    }

    var weightedScore: Double {
        guard let achievedScore else { return 0 }
        return achievedScore / maxScore * weight
    }
}
