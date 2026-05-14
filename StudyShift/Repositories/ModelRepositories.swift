//
//  ModelRepositories.swift
//  StudyShift
//
//  Created by Codex on 30/4/26.
//

import Foundation
import SwiftData

struct CourseRepository: RepositoryProtocol {
    typealias Entity = Course

    let context: ModelContext

    func fetchAll() throws -> [Course] {
        let descriptor = FetchDescriptor<Course>(
            sortBy: [SortDescriptor(\.name)]
        )
        return try fetch(with: descriptor)
    }

    func fetchByCode(_ code: String) throws -> Course? {
        let descriptor = FetchDescriptor<Course>(
            predicate: #Predicate { course in
                course.code == code
            }
        )
        return try fetch(with: descriptor).first
    }
    
    func deleteCourseWithRelatedData(_ course: Course) throws {
        let assignments = Array(course.assignments)

        for assignment in assignments {
            let tasks = Array(assignment.tasks)

            for task in tasks {
                context.delete(task)
            }

            context.delete(assignment)
        }

        context.delete(course)

        try save()
    }
}

struct AssignmentRepository: RepositoryProtocol {
    typealias Entity = Assignment

    let context: ModelContext

    func fetchAll() throws -> [Assignment] {
        let descriptor = FetchDescriptor<Assignment>(
            sortBy: [SortDescriptor(\.dueDate)]
        )
        return try fetch(with: descriptor)
    }
    
    func fetchAssignmentsInProgress(
            from date: Date = Date(),
            limit: Int = 5
        ) throws -> [Assignment] {
            let descriptor = FetchDescriptor<Assignment>(
                predicate: #Predicate { assignment in
                    assignment.dueDate >= date
                },
                sortBy: [
                    SortDescriptor(\.dueDate, order: .forward)
                ]
            )

            let result = try fetch(with: descriptor)
            
            let filtered = result.filter { assignment in
                assignment.status != .submitted &&
                assignment.status != .marked
            }

            return Array(filtered.prefix(limit))
        }

        func fetchUpcomingDeadlines(
            from date: Date = Date(),
            limit: Int = 2
        ) throws -> [Assignment] {
            let descriptor = FetchDescriptor<Assignment>(
                predicate: #Predicate { assignment in
                    assignment.dueDate >= date
                },
                sortBy: [
                    SortDescriptor(\.dueDate, order: .forward)
                ]
            )

            let result = try fetch(with: descriptor)
            
            
            let filtered = result.filter { assignment in
                assignment.status != .submitted &&
                assignment.status != .marked
            }

            return Array(filtered.prefix(limit))
        }
}

struct TodoTaskRepository: RepositoryProtocol {
    typealias Entity = TodoTask

    let context: ModelContext

    func fetchAll() throws -> [TodoTask] {
        let descriptor = FetchDescriptor<TodoTask>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        return try fetch(with: descriptor)
    }
}

struct ClassSessionRepository: RepositoryProtocol {
    typealias Entity = ClassSession

    let context: ModelContext

    func fetchAll() throws -> [ClassSession] {
        let descriptor = FetchDescriptor<ClassSession>(
            sortBy: [
                SortDescriptor(\.title),
                SortDescriptor(\.startTime)
            ]
        )
        return try fetch(with: descriptor)
    }

    func fetchByImportIdentity(
        externalEventId: String,
        sourceURL: String
    ) throws -> ClassSession? {
        let descriptor = FetchDescriptor<ClassSession>(
            predicate: #Predicate { session in
                session.externalEventId == externalEventId &&
                session.sourceURL == sourceURL
            }
        )
        return try fetch(with: descriptor).first
    }
    
    func fetchUpcomingClasses(
            from date: Date = Date(),
            limit: Int = 2
        ) throws -> [ClassSession] {
        let descriptor = FetchDescriptor<ClassSession>(
            predicate: #Predicate { classSession in
                classSession.startTime > date
            },
            sortBy: [
                SortDescriptor(\.startTime, order: .forward)
            ]
        )

        let result = try fetch(with: descriptor)

        return Array(result.prefix(limit))
    }
}

struct WorkShiftRepository: RepositoryProtocol {
    typealias Entity = WorkShift

    let context: ModelContext

    func fetchAll() throws -> [WorkShift] {
        let descriptor = FetchDescriptor<WorkShift>(
            sortBy: [SortDescriptor(\.startTime)]
        )
        return try fetch(with: descriptor)
    }
    
    func fetchShifts(
            from startDate: Date,
            to endDate: Date
        ) throws -> [WorkShift] {
            let descriptor = FetchDescriptor<WorkShift>(
                predicate: #Predicate { shift in
                    shift.startTime >= startDate && shift.startTime < endDate
                },
                sortBy: [
                    SortDescriptor(\.startTime, order: .forward)
                ]
            )

            return try fetch(with: descriptor)
        }
}

struct PersonalEventRepository: RepositoryProtocol {
    typealias Entity = PersonalEvent

    let context: ModelContext

    func fetchAll() throws -> [PersonalEvent] {
        let descriptor = FetchDescriptor<PersonalEvent>(
            sortBy: [SortDescriptor(\.startDate)]
        )
        return try fetch(with: descriptor)
    }
}

struct StudentProfileRepository: RepositoryProtocol {
    typealias Entity = StudentProfile

    let context: ModelContext

    func fetchAll() throws -> [StudentProfile] {
        let descriptor = FetchDescriptor<StudentProfile>(
            sortBy: [SortDescriptor(\.name)]
        )
        return try fetch(with: descriptor)
    }

    func fetchFirst() throws -> StudentProfile? {
        try fetchAll().first
    }
}
