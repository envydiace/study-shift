//
//  CalendarViewModel.swift
//  StudyShift
//
//  Created by Đức Anh on 30/4/26.
//

import Foundation
import SwiftUI
import Combine

final class CalendarViewModel: ObservableObject {
    @Published var selectedDate: Date
    @Published var weekStartDate: Date
    @Published var events: [CalendarEvent]

    init(
        selectedDate: Date = Date(),
        events: [CalendarEvent] = []
    ) {
        self.selectedDate = selectedDate
        self.weekStartDate = CalendarViewModel.startOfWeek(for: selectedDate)
        self.events = events
    }

    var weekDates: [Date] {
        (0..<7).compactMap { offset in
            CalendarViewModel.calendar.date(
                byAdding: .day,
                value: offset,
                to: weekStartDate
            )
        }
    }

    var monthTitle: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: selectedDate)
    }

    func goToPreviousWeek() {
        guard let newDate = CalendarViewModel.calendar.date(
            byAdding: .day,
            value: -7,
            to: weekStartDate
        ) else { return }

        weekStartDate = CalendarViewModel.startOfWeek(for: newDate)
        selectedDate = newDate
    }

    func goToNextWeek() {
        guard let newDate = CalendarViewModel.calendar.date(
            byAdding: .day,
            value: 7,
            to: weekStartDate
        ) else { return }

        weekStartDate = CalendarViewModel.startOfWeek(for: newDate)
        selectedDate = newDate
    }

    func goToToday() {
        let today = Date()
        selectedDate = today
        weekStartDate = CalendarViewModel.startOfWeek(for: today)
    }

    private static var calendar: Calendar {
        var calendar = Calendar.current
        calendar.firstWeekday = 2 // Monday
        return calendar
    }

    private static func startOfWeek(for date: Date) -> Date {
        let calendar = CalendarViewModel.calendar

        guard let interval = calendar.dateInterval(
            of: .weekOfYear,
            for: date
        ) else {
            return date
        }

        return interval.start
    }
}
