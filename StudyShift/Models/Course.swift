//
//  Course.swift
//  StudyShift
//
//  Created by Đức Anh on 26/4/26.
//

import Foundation
import SwiftData

@Model
final class Course: UUIDIdentifiableModel {
    var id: UUID
    var name: String
    var code: String
    var colorHex: String
    var targetGrade: GradeTarget

    @Relationship(deleteRule: .cascade, inverse: \ClassSession.course)
    var classSessions: [ClassSession] = []

    @Relationship(deleteRule: .cascade, inverse: \Assignment.course)
    var assignments: [Assignment] = []

    @Relationship(deleteRule: .cascade, inverse: \TodoTask.course)
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
