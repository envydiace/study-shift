//
//  MainTabView.swift
//  StudyShift
//
//  Created by Đức Anh on 30/4/26.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }

            CalendarView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Calendar")
                }

            StudyTasksView()
                .tabItem {
                    Image(systemName: "checklist")
                    Text("Tasks")
                }

            WorkShiftView()
                .tabItem {
                    Image(systemName: "briefcase.fill")
                    Text("Work")
                }

            MoreView()
                .tabItem {
                    Image(systemName: "ellipsis.circle.fill")
                    Text("More")
                }
        }
    }
}

#Preview {
    MainTabView()
}
