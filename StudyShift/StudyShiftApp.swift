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
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    
    private let sharedModelContainer = ModelContainerFactory.createAppContainer()

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .task {
                    _ = await NotificationService.shared.requestPermission()
                }
        }
        .modelContainer(sharedModelContainer)
    }
}
