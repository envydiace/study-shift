//
//  MainTabView.swift
//  StudyShift
//
//  Created by Đức Anh on 30/4/26.
//

import SwiftUI
import SwiftData

struct MainTabView: View {
    @State private var selectedTab: MainTab = .home

    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView(selectedTab: $selectedTab)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(MainTab.home)

            CalendarView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Calendar")
                }
                .tag(MainTab.calendar)

            AssignmentsView()
                .tabItem {
                    Image(systemName: "doc.text.fill")
                    Text("Assignment")
                }
                .tag(MainTab.assignment)

            WorkShiftView()
                .tabItem {
                    Image(systemName: "briefcase.fill")
                    Text("Work")
                }
                .tag(MainTab.work)

            ProfileSettingsView()
                .tabItem {
                    Image(systemName: "person.crop.circle.fill")
                    Text("Profile")
                }
                .tag(MainTab.profile)
        }
    }
}
#Preview {
    MainTabView()
        .modelContainer(ModelContainerFactory.createPreviewContainer())
}
