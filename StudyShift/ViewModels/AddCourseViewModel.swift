//
//  AddCourseViewModel.swift
//  StudyShift
//
//  Created by Đức Anh on 26/4/26.
//

import Foundation
import Combine
import SwiftData

final class AddCourseViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var code: String = ""
    @Published var colorHex: String = "#4F46E5"
    @Published var targetGrade: GradeTarget = .distinction

    @Published var showValidationError: Bool = false
    @Published var validationMessage: String = ""
    
    @Published var isShowingColorDropdown: Bool = false

    private var repository: CourseRepository?

    func configure(context: ModelContext) {
        if repository == nil {
            repository = CourseRepository(context: context)
        }
    }

    func saveCourse() -> Bool {
        guard let repository else {
            showValidationError = true
            validationMessage = "Repository is not ready."
            return false
        }

        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedCode = code.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedName.isEmpty else {
            showValidationError = true
            validationMessage = "Please enter course name."
            return false
        }

        guard !trimmedCode.isEmpty else {
            showValidationError = true
            validationMessage = "Please enter course code."
            return false
        }

        let course = Course(
            name: trimmedName,
            code: trimmedCode,
            colorHex: colorHex,
            targetGrade: targetGrade
        )

        do {
            try repository.insert(course)
            print("Course saved successfully!")
            return true
        } catch {
            showValidationError = true
            validationMessage = "Failed to save course."
            print("Failed to save course: \(error)")
            return false
        }
    }
}
