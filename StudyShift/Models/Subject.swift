//
//  Subject.swift
//  StudyShift
//
//  Created by Đức Anh on 26/4/26.
//

import Foundation
import SwiftData

@Model
final class Subject {
    var id: UUID
    var name: String
    var code: String
    var colorHex: String
    var targetGrade: GradeTarget

    @Relationship(deleteRule: .cascade, inverse: \ClassSession.subject)
    var classSessions: [ClassSession] = []

    @Relationship(deleteRule: .cascade, inverse: \Assessment.subject)
    var assessments: [Assessment] = []

    @Relationship(deleteRule: .cascade, inverse: \TodoTask.subject)
    var tasks: [TodoTask] = []

    init(
        id: UUID = UUID(),
        name: String,
        code: String,
        colorHex: String = "#4F46E5",
        targetGrade: GradeTarget = .distinction
    ) {
        self.id = id
        self.name = name
        self.code = code
        self.colorHex = colorHex
        self.targetGrade = targetGrade
    }
}
