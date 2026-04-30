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

    func configure(context: ModelContext) {
        if repository == nil {
            repository = ClassSessionRepository(context: context)
        }
    }

    func importTimetable() async {
        isImporting = true
        errorMessage = ""
        successMessage = ""

        guard let repository else {
            errorMessage = "Repository is not ready."
            isImporting = false
            return
        }

        do {
            let trimmedURL = urlText.trimmingCharacters(in: .whitespacesAndNewlines)
            let events = try await service.importEvents(from: trimmedURL)

            let sessions = events.map { event in
                ClassSession(
                    title: event.title,
                    sessionType: detectSessionType(from: event.title),
                    location: event.location,
                    startTime: event.startDate,
                    endTime: event.endDate,
                    externalEventId: event.uid,
                    sourceURL: trimmedURL
                )
            }

            try repository.insert(sessions)

            successMessage = "Imported \(events.count) class sessions successfully."
            print("Imported \(events.count) class sessions.")
        } catch {
            errorMessage = "Failed to import timetable. Please check the URL and try again."
            print("Import failed: \(error)")
        }

        isImporting = false
    }

    private func detectSessionType(from title: String) -> ClassSessionType {
        let lowercased = title.lowercased()

        if lowercased.contains("lec") {
            return .lecture
        } else if lowercased.contains("lab") {
            return .lab
        } else if lowercased.contains("cmp") {
            return .tutorial
        } else if lowercased.contains("workshop") {
            return .workshop
        } else if lowercased.contains("online") {
            return .online
        } else {
            return .other
        }
    }
}
