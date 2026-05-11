//
//  ModelContainerFactory.swift
//  StudyShift
//
//  Created by Đức Anh on 11/5/26.
//

import SwiftData

enum ModelContainerFactory {

    static let appSchema = Schema([
        StudentProfile.self,
        Subject.self,
        ClassSession.self,
        Assessment.self,
        TodoTask.self,
        WorkShift.self,
        PersonalEvent.self
    ])

    static func createAppContainer() -> ModelContainer {
        let configuration = ModelConfiguration(
            schema: appSchema,
            isStoredInMemoryOnly: false
        )

        do {
            return try ModelContainer(
                for: appSchema,
                configurations: [configuration]
            )
        } catch {
            fatalError("Could not create app ModelContainer: \(error)")
        }
    }

    static func createPreviewContainer() -> ModelContainer {
        let configuration = ModelConfiguration(
            schema: appSchema,
            isStoredInMemoryOnly: true
        )

        do {
            let container = try ModelContainer(
                for: appSchema,
                configurations: [configuration]
            )

            insertPreviewData(into: container)

            return container
        } catch {
            fatalError("Could not create preview ModelContainer: \(error)")
        }
    }

    private static func insertPreviewData(into container: ModelContainer) {
        let context = container.mainContext

        context.insert(
            Subject(
                name: "iOS Development",
                code: "IOS101"
            )
        )

        context.insert(
            Subject(
                name: "Cloud Computing",
                code: "CLOUD101"
            )
        )

        context.insert(
            Subject(
                name: "Cyber Security",
                code: "CYB101"
            )
        )

        do {
            try context.save()
        } catch {
            print("Failed to insert preview data: \(error)")
        }
    }
}
