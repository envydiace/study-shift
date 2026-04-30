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
    @Published var isShowingMonthPicker: Bool = false

    init(
        selectedDate: Date = Date(),
        events: [CalendarEvent] = []
    ) {
        self.selectedDate = selectedDate
        self.weekStartDate = CalendarViewModel.startOfWeek(for: selectedDate)
        self.events = events
    }

    var monthTitle: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: selectedDate)
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

    func showMonthPicker() {
        isShowingMonthPicker = true
    }

    func hideMonthPicker() {
        isShowingMonthPicker = false
    }

    func selectDate(_ date: Date) {
        selectedDate = date
        weekStartDate = CalendarViewModel.startOfWeek(for: date)
    }

    func selectMonth(_ date: Date) {
        selectDate(date)
        hideMonthPicker()
    }

    func goToPreviousWeek() {
        guard let newDate = CalendarViewModel.calendar.date(
            byAdding: .day,
            value: -7,
            to: weekStartDate
        ) else { return }

        selectedDate = newDate
        weekStartDate = CalendarViewModel.startOfWeek(for: newDate)
    }

    func goToNextWeek() {
        guard let newDate = CalendarViewModel.calendar.date(
            byAdding: .day,
            value: 7,
            to: weekStartDate
        ) else { return }

        selectedDate = newDate
        weekStartDate = CalendarViewModel.startOfWeek(for: newDate)
    }

    func goToToday() {
        selectDate(Date())
    }

    private static var calendar: Calendar {
        var calendar = Calendar.current
        calendar.firstWeekday = 2
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
