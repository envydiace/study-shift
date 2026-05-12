//
//  MoreView.swift
//  StudyShift
//
//  Created by Đức Anh on 30/4/26.
//

import SwiftUI

struct MoreView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("Assignments") {
                    AssignmentsView()
                }

                NavigationLink("Grade Tracker") {
                    GradeTrackerView()
                }

                NavigationLink("Import Timetable") {
                    TimetableImportView()
                }
                
                NavigationLink("Course List") {
                    CourseListView()
                }
                
                NavigationLink("Debug Data View") {
                    DebugDataView()
                }

                NavigationLink("Profile / Settings") {
                    ProfileSettingsView()
                }
            }
            .navigationTitle("More")
        }
    }
}

#Preview {
    MoreView()
}
