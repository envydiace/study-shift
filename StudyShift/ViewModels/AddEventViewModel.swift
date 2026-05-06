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
    @Published var subjectName: String = ""
    @Published var repeatWeekly: Bool = false

    // Assessment fields
    @Published var assessmentType: String = "Assignment"
    @Published var weight: String = ""
    @Published var totalMark: String = ""

    // Work shift fields
    @Published var workplace: String = ""

    @Published var errorMessage: String?
    
    private var subjectRepository: SubjectRepository?

    init (eventType: EventType) {
        self.eventType = eventType
    }

    func configure(context: ModelContext) {
        if subjectRepository == nil {
            subjectRepository = SubjectRepository(context: context)
        }
    }
    
    let assessmentTypes = [
        "Assignment",
        "Quiz",
        "Exam",
        "Presentation",
        "Project"
    ]

    var saveButtonTitle: String {
        switch eventType {
        case .personal:
            return "Add Personal Event"
        case .classSession:
            return "Add Class"
        case .assessment:
            return "Add Assessment"
        case .workShift:
            return "Add Work Shift"
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

        // Later, replace this with SwiftData insert logic.
        switch eventType {
        case .personal:
            print("Save Personal Event")
        case .classSession:
            print("Save Class Session")
        case .assessment:
            print("Save Assessment")
        case .workShift:
            print("Save Work Shift")
        }
    }
}
