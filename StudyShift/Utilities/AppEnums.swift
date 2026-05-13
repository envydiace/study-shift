//
//  AppEnums.swift
//  StudyShift
//
//  Created by Đức Anh on 26/4/26.
//

import Foundation

enum MainTab {
    case home
    case calendar
    case assignment
    case work
    case profile
}

enum GradeTarget: String, Codable, CaseIterable {
    case pass = "P"
    case credit = "C"
    case distinction = "D"
    case highDistinction = "HD"
}

enum AssignmentType: String, Codable, CaseIterable {
    case essay = "Essay"
    case quiz = "Quiz/test"
    case presentation = "Presentation"
    case project = "Project"
    case report = "Report"
    case exam = "Examination"
    case lab = "Laboratory/practical"
    case other = "Other"
}

enum AssignmentStatus: String, Codable, CaseIterable {
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
