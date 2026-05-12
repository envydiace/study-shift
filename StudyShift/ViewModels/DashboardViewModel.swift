//
//  DashboardViewModel.swift
//  StudyShift
//
//  Created by Đức Anh on 13/5/26.
//

import Foundation
import Combine
import SwiftUI

final class DashboardViewModel: ObservableObject {
    @Published var greetingTitle: String = "Hi, Welcome Back"
    @Published var greetingSubtitle: String = "Good Morning"

    @Published var remainingHoursText: String = "Only 12 hrs remaining"
    @Published var remainingHoursSubtitle: String = "Plan Shifts Carefully"
    @Published var workedHoursText: String = "36 h"
    @Published var workedProgress: Double = 0.75

    @Published var assessments: [DashboardAssessmentItem] = [
        DashboardAssessmentItem(
            subjectCode: "32541",
            subjectName: "Project Management",
            title: "Assessment 2",
            progress: 0.70
        ),
        DashboardAssessmentItem(
            subjectCode: "42904",
            subjectName: "Cloud Computing",
            title: "Assessment 1",
            progress: 0.52
        )
    ]

    @Published var upcomingClasses: [DashboardClassItem] = [
        DashboardClassItem(
            subjectCode: "42904",
            subjectName: "Cloud Computing",
            startTime: "10:00",
            endTime: "12:00",
            dayText: "Monday"
        ),
        DashboardClassItem(
            subjectCode: "32541",
            subjectName: "Project Management",
            startTime: "13:00",
            endTime: "15:00",
            dayText: "Monday"
        )
    ]

    @Published var upcomingDeadlines: [DashboardDeadlineItem] = [
        DashboardDeadlineItem(
            title: "NLP Assessment 2",
            dueText: "Due in 2 days",
            statusText: "Urgent",
            statusColor: .red,
            statusBackground: Color.red.opacity(0.18)
        ),
        DashboardDeadlineItem(
            title: "Cloud Computing Report",
            dueText: "Due in 6 days",
            statusText: "Soon",
            statusColor: Color(red: 0.55, green: 0.50, blue: 0.00),
            statusBackground: Color.yellow.opacity(0.28)
        )
    ]
}
