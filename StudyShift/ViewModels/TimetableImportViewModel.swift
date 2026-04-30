//
//  TimetableImportViewModel.swift
//  StudyShift
//
//  Created by Đức Anh on 26/4/26.
//

import Foundation
import Combine
import SwiftData

final class TimetableImportViewModel: ObservableObject {
    @Published var urlText: String = ""
    @Published var errorMessage: String = ""
    @Published var successMessage: String = ""
    @Published var isImporting: Bool = false

    private let service = TimetableImportService()
    private var repository: ClassSessionRepository?
    private var subjectRepository: SubjectRepository?

    func configure(context: ModelContext) {
        if repository == nil {
            repository = ClassSessionRepository(context: context)
        }

        if subjectRepository == nil {
            subjectRepository = SubjectRepository(context: context)
        }
    }

    func importTimetable() async {
        isImporting = true
        errorMessage = ""
        successMessage = ""

        guard let repository, let subjectRepository else {
            errorMessage = "Repository is not ready."
            isImporting = false
            return
        }

        do {
            let trimmedURL = urlText.trimmingCharacters(in: .whitespacesAndNewlines)
            let events = try await service.importEvents(from: trimmedURL)
            var subjectsByCode: [String: Subject] = [:]
            var createdSubjectCount = 0

            for event in events {
                guard let code = subjectCode(from: event.description) else {
                    continue
                }

                if subjectsByCode[code] != nil {
                    continue
                }

                if let existingSubject = try subjectRepository.fetchByCode(code) {
                    subjectsByCode[code] = existingSubject
                    continue
                }

                let subject = Subject(
                    name: subjectName(from: event.title),
                    code: code
                )
                try subjectRepository.insert(subject)
                subjectsByCode[code] = subject
                createdSubjectCount += 1
            }

            let sessions = events.map { event in
                ClassSession(
                    title: event.title,
                    location: event.location,
                    startTime: event.startDate,
                    endTime: event.endDate,
                    externalEventId: event.uid,
                    sourceURL: trimmedURL,
                    subject: subjectCode(from: event.description).flatMap {
                        subjectsByCode[$0]
                    }
                )
            }

            try repository.insert(sessions)

            successMessage = "Imported \(events.count) class sessions and created \(createdSubjectCount) subjects successfully."
            print("Imported \(events.count) class sessions.")
        } catch {
            errorMessage = "Failed to import timetable. Please check the URL and try again."
            print("Import failed: \(error)")
        }

        isImporting = false
    }

    private func subjectCode(from description: String) -> String? {
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

    private func subjectName(from summary: String) -> String {
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
