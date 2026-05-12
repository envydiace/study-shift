//
//  DashboardViewModel.swift
//  StudyShift
//
//  Created by Đức Anh on 13/5/26.
//

import Foundation
import Combine
import SwiftUI
import SwiftData

final class DashboardViewModel: ObservableObject {
    @Published var errorMessage: String?
    
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

    @Published var upcomingClasses: [DashboardClassItem] = []

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
    
    private var classSessionRepository: ClassSessionRepository?

    func configure(context: ModelContext) {
        self.classSessionRepository = ClassSessionRepository(context: context)
    }

    func loadUpcomingClasses() {
        guard let classSessionRepository else {
            errorMessage = "Class session repository is not configured."
            return
        }

        do {
            upcomingClasses = try classSessionRepository.fetchUpcomingClasses(
                from: Date(),
                limit: 2
            ).map { classSession in
                DashboardClassItem(
                    title: classSession.title,
                    startTime: DateFormatHelper.formatHourMinute(classSession.startTime),
                    endTime: DateFormatHelper.formatHourMinute(classSession.endTime),
                    dayText: DateFormatHelper.formatHourMinute(classSession.startTime),
                    location: classSession.location
                )
            }

            errorMessage = nil
        } catch {
            errorMessage = "Failed to load upcoming classes."
            print("Load upcoming classes error:", error)
        }
    }
    
}
