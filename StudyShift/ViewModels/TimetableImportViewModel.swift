//
//  TimetableImportViewModel.swift
//  StudyShift
//
//  Created by Đức Anh on 26/4/26.
//

import Foundation
import SwiftData
import Combine

final class TimetableImportViewModel: ObservableObject {
    @Published var urlText: String = ""
    @Published var errorMessage: String = ""
    @Published var successMessage: String = ""
    @Published var isImporting: Bool = false

    private let service = TimetableImportService()

    func importTimetable(context: ModelContext) async {
        isImporting = true
        errorMessage = ""
        successMessage = ""

        do {
            let trimmedURL = urlText.trimmingCharacters(in: .whitespacesAndNewlines)
            let events = try await service.importEvents(from: trimmedURL)

            for event in events {
                let session = ClassSession(
                    title: event.title,
                    sessionType: detectSessionType(from: event.title),
                    location: event.location,
                    dayOfWeek: getWeekday(from: event.startDate),
                    startTime: event.startDate,
                    endTime: event.endDate,
                    isRepeatingWeekly: false,
                    externalEventId: event.uid,
                    sourceURL: trimmedURL
                )

                context.insert(session)
            }

            try context.save()

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

    private func getWeekday(from date: Date) -> Weekday {
        let weekdayNumber = Calendar.current.component(.weekday, from: date)

        switch weekdayNumber {
        case 1: return .sunday
        case 2: return .monday
        case 3: return .tuesday
        case 4: return .wednesday
        case 5: return .thursday
        case 6: return .friday
        case 7: return .saturday
        default: return .monday
        }
    }
}
