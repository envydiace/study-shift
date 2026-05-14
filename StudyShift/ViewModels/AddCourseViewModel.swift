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
    
    private let courseToEdit: Course?
    
    init(courseToEdit: Course? = nil) {
        self.courseToEdit = courseToEdit

        if let courseToEdit {
            self.name = courseToEdit.name
            self.code = courseToEdit.code
            self.targetGrade = courseToEdit.targetGrade
            self.colorHex = courseToEdit.colorHex
        }
    }

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

        do {
            if let courseToEdit {
                courseToEdit.name = trimmedName
                courseToEdit.code = trimmedCode.uppercased()
                courseToEdit.targetGrade = targetGrade
                courseToEdit.colorHex = colorHex

                try repository.save()
            } else {
                let course = Course(
                    name: trimmedName,
                    code: trimmedCode.uppercased(),
                    colorHex: colorHex,
                    targetGrade: targetGrade
                )

                try repository.insert(course)
            }

            showValidationError = false
            validationMessage = ""
            return true

        } catch {
            validationMessage = "Failed to save course."
            showValidationError = true
            print("Save course error:", error)
            return false
        }
    }
}
