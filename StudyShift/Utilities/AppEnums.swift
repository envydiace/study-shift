//
//  AppEnums.swift
//  StudyShift
//
//  Created by Đức Anh on 26/4/26.
//

import Foundation

enum GradeTarget: String, Codable, CaseIterable {
    case pass = "P"
    case credit = "C"
    case distinction = "D"
    case highDistinction = "HD"
}

enum Weekday: String, Codable, CaseIterable {
    case monday = "Monday"
    case tuesday = "Tuesday"
    case wednesday = "Wednesday"
    case thursday = "Thursday"
    case friday = "Friday"
    case saturday = "Saturday"
    case sunday = "Sunday"
}

enum AssessmentType: String, Codable, CaseIterable {
    case assignment = "Assignment"
    case quiz = "Quiz"
    case exam = "Exam"
    case presentation = "Presentation"
    case project = "Project"
    case other = "Other"
}

enum AssessmentStatus: String, Codable, CaseIterable {
    case notStarted = "Not Started"
    case inProgress = "In Progress"
    case submitted = "Submitted"
    case marked = "Marked"
}

enum TaskPriority: String, Codable, CaseIterable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
}

enum EventType: String, CaseIterable, Hashable {
    case personal = "Personal"
    case classSession = "Class"
    case workShift = "Work Shift"
    case task = "Task"
    
    static var addEventTypes: [EventType] {
        [
            .personal,
            .classSession,
            .workShift
        ]
    }

    var iconName: String {
        switch self {
        case .personal:
            return "person.fill"
        case .classSession:
            return "book.fill"
        case .workShift:
            return "briefcase.fill"
        case .task:
            return "task.fill"
        }
    }
}

enum Constants {
    static let hourHeight: CGFloat = 60   // 1 hour = 60px
    static let dayWidth: CGFloat = 80     // each day column
}
