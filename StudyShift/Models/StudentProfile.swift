//
//  StudentProfile.swift
//  StudyShift
//
//  Created by Đức Anh on 26/4/26.
//

import Foundation
import SwiftData

@Model
final class StudentProfile {
    var id = UUID()
    var name: String
    var visaType: String
    var workHourLimitPerFortnight: Double
    var defaultTargetGrade: String

    init(
        id: UUID = UUID(),
        name: String,
        visaType: String = "Student Visa 500",
        workHourLimitPerFortnight: Double = 48,
        defaultTargetGrade: String = "HD"
    ) {
        self.id = id
        self.name = name
        self.visaType = visaType
        self.workHourLimitPerFortnight = workHourLimitPerFortnight
        self.defaultTargetGrade = defaultTargetGrade
    }
}
