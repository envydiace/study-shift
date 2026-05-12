//
//  CourseListViewModel.swift
//  StudyShift
//
//  Created by Đức Anh on 26/4/26.
//

import Foundation
import Combine
import SwiftData

final class SubjectListViewModel: ObservableObject {
    @Published var showAddCourseForm: Bool = false
    @Published var showImportTimetableView = false
    @Published var courses: [Course] = []
    @Published var errorMessage: String = ""

    private var repository: CourseRepository?

    func configure(context: ModelContext) {
        if repository == nil {
            repository = CourseRepository(context: context)
        }
    }

    func loadCourses() {
        guard let repository else {
            errorMessage = "Repository is not ready."
            return
        }

        do {
            courses = try repository.fetchAll()
            errorMessage = ""
        } catch {
            errorMessage = "Failed to load courses."
            print("Failed to load courses: \(error)")
        }
    }

    func deleteCourse(_ course: Course) {
        guard let repository else {
            errorMessage = "Repository is not ready."
            return
        }

        do {
            try repository.delete(course)
            courses.removeAll { $0.id == course.id }
            errorMessage = ""
            print("Course deleted successfully!")
        } catch {
            errorMessage = "Failed to delete course."
            print("Failed to delete course: \(error)")
        }
    }

    func printCourse(_ course: Course) {
        print("""
        ===== COURSE =====
        ID: \(course.id)
        Name: \(course.name)
        Code: \(course.code)
        Color: \(course.colorHex)
        Target Grade: \(course.targetGrade.rawValue)
        Class Sessions: \(course.classSessions.count)
        Assignments: \(course.assignments.count)
        Tasks: \(course.tasks.count)
        ===================
        """)
    }
}
