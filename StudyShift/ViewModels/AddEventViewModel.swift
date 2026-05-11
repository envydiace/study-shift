//
//  AddEventViewModel.swift
//  StudyShift
//
//  Created by Đức Anh on 6/5/26.
//

import Foundation
import Combine
import SwiftData

final class AddEventViewModel: ObservableObject {
    @Published var eventType: EventType
    
    @Published var title: String = ""

    @Published var startDate: Date? = Date()
    @Published var endDate: Date? = Calendar.current.date(byAdding: .hour, value: 1, to: Date())

    @Published var location: String = ""
    @Published var notes: String = ""

    // Class fields
    @Published var subjects: [Subject] = []
    @Published var subjectCode: String = ""

    // Work shift fields
    @Published var workplace: String = ""

    @Published var didSaveSuccessfully: Bool = false
    @Published var errorMessage: String?
    
    @Published var notificationEnabled: Bool = false
    @Published var reminderMinutesBefore: Int = 30
    private var notificationId: String? = nil

    let reminderOptions = [5, 10, 15, 30, 60, 120]
    
    private var subjectRepository: SubjectRepository?
    private var classSessionReposiitory: ClassSessionRepository?
    private var personalEventRepository: PersonalEventRepository?
    private var workShiftRepository: WorkShiftRepository?
    private var todoTaskRepository: TodoTaskRepository?

    init (eventType: EventType) {
        self.eventType = eventType
    }

    func configure(context: ModelContext) {
        if subjectRepository == nil {
            subjectRepository = SubjectRepository(context: context)
        }
        if classSessionReposiitory == nil {
            classSessionReposiitory = ClassSessionRepository(context: context)
        }
        if personalEventRepository == nil {
            personalEventRepository = PersonalEventRepository(context: context)
        }
        if workShiftRepository == nil {
            workShiftRepository = WorkShiftRepository(context: context)
        }
        if todoTaskRepository == nil {
            todoTaskRepository = TodoTaskRepository(context: context)
        }
    }

    var saveButtonTitle: String {
        switch eventType {
        case .personal:
            return "Add Personal Event"
        case .classSession:
            return "Add Class"
        case .workShift:
            return "Add Work Shift"
        case .task:
            return "Add Task"
        }
    }
    
    func loadSubjects() {
        guard let subjectRepository
        else {
            errorMessage = "Repository is not ready."
            return
        }

        do {
            subjects = try subjectRepository.fetchAll()
            errorMessage = ""
        } catch {
            errorMessage = "Failed to load calendar events."
            print("Failed to load calendar events: \(error)")
        }
    }

    func eventTypeChanged() {
        if startDate == nil {
            startDate = Date()
        }

        if endDate == nil {
            endDate = Calendar.current.date(
                byAdding: .hour,
                value: 1,
                to: startDate ?? Date()
            )
        }

        errorMessage = nil
    }

    func updateEndDateIfNeeded() {
        guard let startDate else { return }

        if let endDate {
            if endDate < startDate {
                self.endDate = Calendar.current.date(
                    byAdding: .hour,
                    value: 1,
                    to: startDate
                )
            }
        }
    }

    var isValid: Bool {
        validationMessage == nil
    }

    var validationMessage: String? {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedTitle.isEmpty else {
            return "Title is required."
        }

        guard startDate != nil else {
            return "Start date is required for \(eventType.rawValue)."
        }

        guard endDate != nil else {
            return "End date is required for \(eventType.rawValue)."
        }

        if let startDate, let endDate, endDate < startDate {
            return "End date must be after start date."
        }

        return nil
    }

    func validate() -> Bool {
        if let message = validationMessage {
            errorMessage = message
            return false
        }

        errorMessage = nil
        return true
    }

    func save() {
        guard validate() else { return }
        
        notificationId = notificationEnabled ? UUID().uuidString : nil
        do {
            switch eventType {
            case .personal:
                try savePersonalEvent()
                schedulePersonalEventNotification()
                
            case .classSession:
                try saveClassSession()
                
            case .workShift:
                try saveWorkShift()
                
            case .task:
                errorMessage = "Tasks are created from the Tasks screen."
                didSaveSuccessfully = false
                return
            }
            errorMessage = nil
            didSaveSuccessfully = true

        } catch {
            errorMessage = "Failed to save event. Please try again."
            didSaveSuccessfully = false
            print("Save event error:", error)
        }
    }
    
    private func savePersonalEvent() throws {
        let event = PersonalEvent(
            title: trimmedTitle,
            startDate: startDate,
            endDate: endDate,
            location: emptyToNil(location),
            notes: emptyToNil(notes),
            notificationEnabled: notificationEnabled,
            reminderMinutesBefore: notificationEnabled ? reminderMinutesBefore : nil,
            notificationId: notificationId
        )

        try personalEventRepository?.insert(event)
    }
    
    private func saveClassSession() throws {
        guard let startDate, let endDate else { return }

        let subject = try subjectRepository?.fetchByCode(subjectCode)
        let classSession = ClassSession(
            title: trimmedTitle,
            location: emptyToNil(location),
            startTime: startDate,
            endTime: endDate,
            subject: subject
        )

        try classSessionReposiitory?.insert(classSession)
    }
    
    private func saveWorkShift() throws{
        guard let startDate, let endDate else { return }

        let workShift = WorkShift(
            title: trimmedTitle,
            workplace: emptyToNil(workplace) ?? "",
            startTime: startDate,
            endTime: endDate,
            note: emptyToNil(notes) ?? ""
        )

        try workShiftRepository?.insert(workShift)
    }
    
    private func schedulePersonalEventNotification() {
        if notificationEnabled,
           let notificationId,
           let startDate,
           let endDate
        {
            
            let body = "\(DateFormatHelper.formatHourMinute(startDate)) - \(DateFormatHelper.formatHourMinute(endDate))"
            scheduleEventNotification(notificationId: notificationId, title: trimmedTitle, body: body, eventStartDate: startDate, minutesBefore: reminderMinutesBefore)
        }
    }
    
    private func scheduleEventNotification(notificationId: String, title: String, body: String, eventStartDate: Date, minutesBefore: Int) {
        Task {
            do {
                try await NotificationService.shared.scheduleEventNotification(
                    id: notificationId,
                    title: title,
                    body: body,
                    eventStartDate: eventStartDate,
                    minutesBefore: minutesBefore
                )
            } catch {
                print("Failed to schedule notification:", error)
            }
        }
    }
    
    private var trimmedTitle: String {
        title.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private func emptyToNil(_ value: String) -> String? {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }
    
}
