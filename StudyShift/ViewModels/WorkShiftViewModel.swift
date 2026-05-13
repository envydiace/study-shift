//
//  WorkShiftViewModel.swift
//  StudyShift
//
//  Created by M. A. Diganta on 13/5/2026.
//

import Foundation
import SwiftData
import SwiftUI
import Combine

@MainActor
final class WorkShiftViewModel: ObservableObject {
    @Published var shifts: [WorkShift] = []

    private var repository: WorkShiftRepository?

    func configure(context: ModelContext) {
        if repository == nil {
            repository = WorkShiftRepository(context: context)
        }
        loadShifts()
    }

    func loadShifts() {
        guard let repository else { return }
        do {
            shifts = try repository.fetchAll()
        } catch {
            print("Failed to load shifts: \(error)")
        }
    }

    func deleteShift(_ shift: WorkShift) {
        guard let repository else { return }
        do {
            try repository.delete(shift)
            loadShifts()
        } catch {
            print("Failed to delete shift: \(error)")
        }
    }

    // MARK: - Fortnight totals

    var totalHoursThisFortnight: Double {
        shiftsThisFortnight.reduce(0) { $0 + $1.totalHours }
    }

    var fortnightDurationLabel: String {
        let totalMinutes = shiftsThisFortnight.reduce(0) { total, shift in
            total + Int(shift.endTime.timeIntervalSince(shift.startTime) / 60)
        }
        return durationLabel(from: totalMinutes)
    }

    var shiftsThisFortnight: [WorkShift] {
        let range = currentFortnightRange()
        return shifts.filter { $0.startTime >= range.start && $0.startTime <= range.end }
    }

    var shiftsByWorkplace: [(workplace: String, shifts: [WorkShift], totalHours: Double, durationLabel: String)] {
        let grouped = Dictionary(grouping: shiftsThisFortnight, by: { $0.workplace })
        return grouped.map { key, value in
            let totalMinutes = value.reduce(0) { total, shift in
                total + Int(shift.endTime.timeIntervalSince(shift.startTime) / 60)
            }
            return (
                workplace: key,
                shifts: value,
                totalHours: value.reduce(0) { $0 + $1.totalHours },
                durationLabel: durationLabel(from: totalMinutes)
            )
        }.sorted { $0.workplace < $1.workplace }
    }

    func dateRangeLabel(for shifts: [WorkShift]) -> String {
        let sorted = shifts.sorted { $0.startTime < $1.startTime }
        guard let first = sorted.first, let last = sorted.last else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE d MMM"
        if Calendar.current.isDate(first.startTime, inSameDayAs: last.startTime) {
            return formatter.string(from: first.startTime)
        }
        return "\(formatter.string(from: first.startTime)), \(formatter.string(from: last.startTime))"
    }

    // MARK: - Helpers

    private func durationLabel(from totalMinutes: Int) -> String {
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60
        if minutes == 0 {
            return "\(hours) h"
        }
        return "\(hours) h \(minutes) m"
    }

    private func currentFortnightRange() -> (start: Date, end: Date) {
        let calendar = Calendar.current
        let now = Date()
        let startOfToday = calendar.startOfDay(for: now)
        let weekday = calendar.component(.weekday, from: startOfToday)
        let daysFromMonday = (weekday + 5) % 7
        let thisMonday = calendar.date(byAdding: .day, value: -daysFromMonday, to: startOfToday)!
        let weeksSinceRef = calendar.component(.weekOfYear, from: thisMonday)
        let fortnightStart = weeksSinceRef % 2 == 0 ? thisMonday : calendar.date(byAdding: .day, value: -7, to: thisMonday)!
        let fortnightEnd = calendar.date(byAdding: .day, value: 13, to: fortnightStart)!
        let endOfFortnight = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: fortnightEnd)!
        return (start: fortnightStart, end: endOfFortnight)
    }
}
