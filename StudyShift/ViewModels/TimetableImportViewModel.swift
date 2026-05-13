//
//  TimetableImportViewModel.swift
//  StudyShift
//
//  Created by Đức Anh on 26/4/26.
//

import Foundation
import Combine
import SwiftData
import SwiftUI

final class TimetableImportViewModel: ObservableObject {
    @Published var urlText: String = ""
    @Published var errorMessage: String = ""
    @Published var successMessage: String = ""
    @Published var isImporting: Bool = false
    
    @Published var isShowingColorDropdown: Bool = false
    @Published var selectedColorHex: String = EventColorOption.defaultColor.hex
    var selectedColorOption: EventColorOption {
        EventColorOption.options.first { $0.hex == selectedColorHex }
        ?? EventColorOption.defaultColor
    }
    
    var canImport: Bool {
        !urlText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private let service = TimetableImportService()
    private var classSessionRepository: ClassSessionRepository?
    private var courseRepository: CourseRepository?

    func configure(context: ModelContext) {
        if classSessionRepository == nil {
            classSessionRepository = ClassSessionRepository(context: context)
        }

        if courseRepository == nil {
            courseRepository = CourseRepository(context: context)
        }
    }

    func importTimetable() async {
        isImporting = true
        errorMessage = ""
        successMessage = ""

        guard let classSessionRepository, let courseRepository else {
            errorMessage = "Repository is not ready."
            isImporting = false
            return
        }

        do {
            let trimmedURL = urlText.trimmingCharacters(in: .whitespacesAndNewlines)
            let events = try await service.importEvents(from: trimmedURL)
            var coursesByCode: [String: Course] = [:]
            var createdCourseCount = 0
            var createdSessionCount = 0
            var updatedSessionCount = 0

            for event in events {
                guard let code = courseCode(from: event.description) else {
                    continue
                }

                if coursesByCode[code] != nil {
                    continue
                }

                if let existingCourse = try courseRepository.fetchByCode(code) {
                    coursesByCode[code] = existingCourse
                    continue
                }

                let course = Course(
                    name: courseName(from: event.title),
                    code: code
                )
                try courseRepository.insert(course)
                coursesByCode[code] = course
                createdCourseCount += 1
            }

            var newSessions: [ClassSession] = []

            for event in events {
                let course = courseCode(from: event.description).flatMap {
                    coursesByCode[$0]
                }

                if let existingSession = try classSessionRepository.fetchByImportIdentity(
                    externalEventId: event.uid,
                    sourceURL: trimmedURL
                ) {
                    existingSession.title = event.title
                    existingSession.location = event.location
                    existingSession.startTime = event.startDate
                    existingSession.endTime = event.endDate
                    existingSession.course = course
                    updatedSessionCount += 1
                    continue
                }

                let session = ClassSession(
                    title: event.title,
                    location: event.location,
                    startTime: event.startDate,
                    endTime: event.endDate,
                    colorHex: selectedColorHex,
                    externalEventId: event.uid,
                    sourceURL: trimmedURL,
                    course: course
                )

                newSessions.append(session)
                createdSessionCount += 1
            }

            if !newSessions.isEmpty {
                try classSessionRepository.insert(newSessions)
            }

            if updatedSessionCount > 0 {
                try classSessionRepository.save()
            }

            successMessage = "Imported \(createdSessionCount) new sessions, updated \(updatedSessionCount) existing sessions, and created \(createdCourseCount) courses successfully."
            print("Imported \(events.count) class sessions.")
        } catch {
            errorMessage = "Failed to import timetable. Please check the URL and try again."
            print("Import failed: \(error)")
        }

        isImporting = false
    }

    private func courseCode(from description: String) -> String? {
        guard let firstLine = description
            .components(separatedBy: .newlines)
            .first?
            .trimmingCharacters(in: .whitespacesAndNewlines),
              let rawCode = firstLine.components(separatedBy: "_").first?
            .trimmingCharacters(in: .whitespacesAndNewlines),
              !rawCode.isEmpty
        else {
            return nil
        }

        return rawCode
    }

    private func courseName(from summary: String) -> String {
        let name = summary
            .components(separatedBy: ",")
            .first?
            .trimmingCharacters(in: .whitespacesAndNewlines)

        if let name, !name.isEmpty {
            return name
        }

        return summary
    }
}
