//
//  SubjectListViewModel.swift
//  StudyShift
//
//  Created by Đức Anh on 26/4/26.
//

import Foundation
import Combine
import SwiftData

final class SubjectListViewModel: ObservableObject {
    @Published var showAddSubjectForm: Bool = false
    @Published var showImportTimetableView = false
    @Published var subjects: [Subject] = []
    @Published var errorMessage: String = ""

    private var repository: SubjectRepository?

    func configure(context: ModelContext) {
        if repository == nil {
            repository = SubjectRepository(context: context)
        }
    }

    func loadSubjects() {
        guard let repository else {
            errorMessage = "Repository is not ready."
            return
        }

        do {
            subjects = try repository.fetchAll()
            errorMessage = ""
        } catch {
            errorMessage = "Failed to load subjects."
            print("Failed to load subjects: \(error)")
        }
    }

    func deleteSubject(_ subject: Subject) {
        guard let repository else {
            errorMessage = "Repository is not ready."
            return
        }

        do {
            try repository.delete(subject)
            subjects.removeAll { $0.id == subject.id }
            errorMessage = ""
            print("Subject deleted successfully!")
        } catch {
            errorMessage = "Failed to delete subject."
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
