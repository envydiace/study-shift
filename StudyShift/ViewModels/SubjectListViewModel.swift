//
//  SubjectListViewModel.swift
//  StudyShift
//
//  Created by Đức Anh on 26/4/26.
//

import Foundation
import SwiftData

@Observable
final class SubjectListViewModel {
    var showAddSubjectForm: Bool = false

    func deleteSubject(
        _ subject: Subject,
        context: ModelContext
    ) {
        context.delete(subject)

        do {
            try context.save()
            print("Subject deleted successfully!")
        } catch {
            print("Failed to delete subject: \(error)")
        }
    }

    func printSubject(_ subject: Subject) {
        print("""
        ===== SUBJECT =====
        ID: \(subject.id)
        Name: \(subject.name)
        Code: \(subject.code)
        Color: \(subject.colorHex)
        Target Grade: \(subject.targetGrade.rawValue)
        Class Sessions: \(subject.classSessions.count)
        Assessments: \(subject.assessments.count)
        Tasks: \(subject.tasks.count)
        ===================
        """)
    }
}
