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

enum ClassSessionType: String, Codable, CaseIterable {
    case lecture = "Lecture"
    case tutorial = "Tutorial"
    case lab = "Lab"
    case workshop = "Workshop"
    case online = "Online"
    case other = "Other"
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
