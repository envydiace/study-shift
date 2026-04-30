//
//  ModelRepositories.swift
//  StudyShift
//
//  Created by Codex on 30/4/26.
//

import Foundation
import SwiftData

struct SubjectRepository: RepositoryProtocol {
    typealias Entity = Subject

    let context: ModelContext

    func fetchAll() throws -> [Subject] {
        let descriptor = FetchDescriptor<Subject>(
            sortBy: [SortDescriptor(\.name)]
        )
        return try fetch(with: descriptor)
    }

    func fetchByCode(_ code: String) throws -> Subject? {
        let descriptor = FetchDescriptor<Subject>(
            predicate: #Predicate { subject in
                subject.code == code
            }
        )
        return try fetch(with: descriptor).first
    }
}

struct AssessmentRepository: RepositoryProtocol {
    typealias Entity = Assessment

    let context: ModelContext

    func fetchAll() throws -> [Assessment] {
        let descriptor = FetchDescriptor<Assessment>(
            sortBy: [SortDescriptor(\.dueDate)]
        )
        return try fetch(with: descriptor)
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
