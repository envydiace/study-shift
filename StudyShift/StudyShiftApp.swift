//
//  StudyShiftApp.swift
//  StudyShift
//
//  Created by Đức Anh on 24/4/26.
//

import SwiftUI
import SwiftData

@main
struct StudyShiftApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            StudentProfile.self,
            Subject.self,
            ClassSession.self,
            Assessment.self,
            TodoTask.self,
            WorkShift.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            SubjectListView()
        }
        .modelContainer(sharedModelContainer)
    }
}
