//
//  SubjectFormViewModel.swift
//  StudyShift
//
//  Created by Đức Anh on 26/4/26.
//

import Foundation
import SwiftData

@Observable
final class SubjectFormViewModel {
    var name: String = ""
    var code: String = ""
    var colorHex: String = "#4F46E5"
    var targetGrade: GradeTarget = .distinction

    var showValidationError: Bool = false
    var validationMessage: String = ""

    let colorOptions: [String] = [
        "#4F46E5",
        "#2563EB",
        "#16A34A",
        "#DC2626",
        "#EA580C",
        "#9333EA",
        "#0891B2",
        "#CA8A04"
    ]

    func saveSubject(context: ModelContext) -> Bool {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedCode = code.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedName.isEmpty else {
            showValidationError = true
            validationMessage = "Please enter subject name."
            return false
        }

        guard !trimmedCode.isEmpty else {
            showValidationError = true
            validationMessage = "Please enter subject code."
            return false
        }

        let subject = Subject(
            name: trimmedName,
            code: trimmedCode,
            colorHex: colorHex,
            targetGrade: targetGrade
        )

        context.insert(subject)

        do {
            try context.save()
            print("Subject saved successfully!")
            return true
        } catch {
            showValidationError = true
            validationMessage = "Failed to save subject."
            print("Failed to save subject: \(error)")
            return false
        }
    }
}
