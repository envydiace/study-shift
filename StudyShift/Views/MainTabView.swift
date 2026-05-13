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

            StudyTasksView()
                .tabItem {
                    Image(systemName: "checklist")
                    Text("Tasks")
                }
                .tag(MainTab.tasks)

            WorkShiftView()
                .tabItem {
                    Image(systemName: "briefcase.fill")
                    Text("Work")
                }
                .tag(MainTab.work)

            MoreView()
                .tabItem {
                    Image(systemName: "ellipsis.circle.fill")
                    Text("More")
                }
                .tag(MainTab.more)
        }
    }
}
#Preview {
    MainTabView()
        .modelContainer(ModelContainerFactory.createPreviewContainer())
}
