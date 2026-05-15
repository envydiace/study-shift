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
    
    @Published var selectedEvent: CalendarEvent?
    @Published var isShowingEventDetail: Bool = false

    private var classSessionRepository: ClassSessionRepository?
    private var workShiftRepository: WorkShiftRepository?
    private var todoTaskRepository: TodoTaskRepository?
    private var personalEventRepository: PersonalEventRepository?

    private var classSessions: [ClassSession] = []
    private var workShifts: [WorkShift] = []
    private var tasks: [TodoTask] = []
    private var personalEvents: [PersonalEvent] = []

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
        
        if personalEventRepository == nil {
            personalEventRepository = PersonalEventRepository(context: context)
        }
    }

    func loadEvents() {
        guard let classSessionRepository,
              let workShiftRepository,
              let todoTaskRepository,
              let personalEventRepository
        else {
            errorMessage = "Repository is not ready."
            return
        }

        do {
            classSessions = try classSessionRepository.fetchAll()
            workShifts = try workShiftRepository.fetchAll()
            tasks = try todoTaskRepository.fetchAll()
            personalEvents = try personalEventRepository.fetchAll()
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
    
    func showEventDetail(_ event: CalendarEvent) {
        selectedEvent = event
        isShowingEventDetail = true
    }

    func hideEventDetail() {
        selectedEvent = nil
        isShowingEventDetail = false
    }
    
    func deleteSelectedEvent() {
        guard let selectedEvent,
              let classSessionRepository,
              let workShiftRepository,
              let todoTaskRepository,
              let personalEventRepository
        else {
            errorMessage = "Repository is not ready."
            return
        }

        do {
            switch selectedEvent.type {
            case .personal:
                if let notificationId = try personalEventRepository.fetchById(selectedEvent.sourceId)?.notificationId {
                    NotificationService.shared.cancelNotification(id: notificationId)
                }

                try personalEventRepository.deleteById(selectedEvent.sourceId)

            case .classSession:
                try classSessionRepository.deleteById(selectedEvent.sourceId)

            case .workShift:
                try workShiftRepository.deleteById(selectedEvent.sourceId)

            case .task:
                try todoTaskRepository.deleteById(selectedEvent.sourceId)
            }
            errorMessage = ""
            loadEvents()
            self.selectedEvent = nil
            isShowingEventDetail = false
        } catch {
            errorMessage = error.localizedDescription
        }
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
                sourceId: $0.id,
                title: $0.title,
                start: $0.startTime,
                end: $0.endTime,
                color: Color(hex: $0.colorHex),
                type: .classSession,
                location: $0.location,
                notes: nil,
                courseCode: $0.course?.code,
                courseName: $0.course?.name
            )
        }

        updatedEvents += workShifts.map {
            CalendarEvent(
                sourceId: $0.id,
                title: $0.workplace.isEmpty ? $0.title : $0.workplace,
                start: $0.startTime,
                end: $0.endTime,
                color: Color(hex: $0.colorHex),
                type: .workShift,
                location: $0.workplace,
                notes: $0.note,
                courseCode: nil,
                courseName: nil
            )
        }

//        updatedEvents += tasks.compactMap { task in
//            guard let start = task.scheduledStart,
//                  let end = task.scheduledEnd else {
//                return nil
//            }
//
//            return CalendarEvent(
//                sourceId: task.id,
//                title: task.title,
//                start: start,
//                end: end,
//                color: .green,
//                type: .task
//            )
//        }
        
        updatedEvents += personalEvents.compactMap { personalEvent in
            guard let start = personalEvent.startDate,
                  let end = personalEvent.endDate else {
                return nil
            }
            return CalendarEvent(
                sourceId: personalEvent.id,
                title: personalEvent.title,
                start: start,
                end: end,
                color: Color(hex: personalEvent.colorHex),
                type: .personal,
                location: personalEvent.location,
                notes: personalEvent.notes,
                courseCode: nil,
                courseName: nil
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
