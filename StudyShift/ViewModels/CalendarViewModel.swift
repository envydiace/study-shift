//
//  CalendarViewModel.swift
//  StudyShift
//
//  Created by Đức Anh on 30/4/26.
//

import Foundation
import SwiftUI
import Combine
import SwiftData

final class CalendarViewModel: ObservableObject {
    @Published var selectedDate: Date
    @Published var weekStartDate: Date
    @Published var events: [CalendarEvent]
    @Published var isShowingMonthPicker: Bool = false
    @Published var isShowingAddEventScreen: Bool = false
    @Published var errorMessage: String = ""

    private var classSessionRepository: ClassSessionRepository?
    private var workShiftRepository: WorkShiftRepository?
    private var todoTaskRepository: TodoTaskRepository?

    private var classSessions: [ClassSession] = []
    private var workShifts: [WorkShift] = []
    private var tasks: [TodoTask] = []

    init(
        selectedDate: Date = Date(),
        events: [CalendarEvent] = []
    ) {
        self.selectedDate = selectedDate
        self.weekStartDate = CalendarViewModel.startOfWeek(for: selectedDate)
        self.events = events
    }

    func configure(context: ModelContext) {
        if classSessionRepository == nil {
            classSessionRepository = ClassSessionRepository(context: context)
        }

        if workShiftRepository == nil {
            workShiftRepository = WorkShiftRepository(context: context)
        }

        if todoTaskRepository == nil {
            todoTaskRepository = TodoTaskRepository(context: context)
        }
    }

    func loadEvents() {
        guard let classSessionRepository,
              let workShiftRepository,
              let todoTaskRepository else {
            errorMessage = "Repository is not ready."
            return
        }

        do {
            classSessions = try classSessionRepository.fetchAll()
            workShifts = try workShiftRepository.fetchAll()
            tasks = try todoTaskRepository.fetchAll()
            errorMessage = ""
            rebuildEvents()
        } catch {
            errorMessage = "Failed to load calendar events."
            print("Failed to load calendar events: \(error)")
        }
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
    
    func showAddEventScreen() {
        isShowingAddEventScreen = true
    }

    func hideAddEventScreen() {
        isShowingAddEventScreen = false
    }

    func selectDate(_ date: Date) {
        selectedDate = date
        weekStartDate = CalendarViewModel.startOfWeek(for: date)
        rebuildEvents()
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
        rebuildEvents()
    }

    func goToNextWeek() {
        guard let newDate = CalendarViewModel.calendar.date(
            byAdding: .day,
            value: 7,
            to: weekStartDate
        ) else { return }

        selectedDate = newDate
        weekStartDate = CalendarViewModel.startOfWeek(for: newDate)
        rebuildEvents()
    }

    func goToToday() {
        selectDate(Date())
    }

    private static var calendar: Calendar {
        var calendar = Calendar.current
        calendar.firstWeekday = 2
        return calendar
    }

    private func rebuildEvents() {
        var updatedEvents: [CalendarEvent] = []

        updatedEvents += classSessions.map {
            CalendarEvent(
                title: $0.title,
                start: $0.startTime,
                end: $0.endTime,
                color: .blue
            )
        }

        updatedEvents += workShifts.map {
            CalendarEvent(
                title: $0.workplace.isEmpty ? $0.title : $0.workplace,
                start: $0.startTime,
                end: $0.endTime,
                color: .orange
            )
        }

        updatedEvents += tasks.compactMap { task in
            guard let start = task.scheduledStart,
                  let end = task.scheduledEnd else {
                return nil
            }

            return CalendarEvent(
                title: task.title,
                start: start,
                end: end,
                color: .green
            )
        }

        events = updatedEvents.sorted { $0.start < $1.start }
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
