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

    @Published var remainingHoursText: String = "No shift data"
    @Published var remainingHoursSubtitle: String = "Plan Shifts Carefully"
    @Published var workedHoursText: String = "0 h"
    @Published var workedProgress: Double = 0

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
    private var workShiftRepository: WorkShiftRepository?

    // MARK: - Computed properties for visa card

    var isLowHours: Bool {
        let remainingHours = max(48 - (workedProgress * 48), 0)
        return remainingHours < 10
    }

    var workedHoursLabel: String {
        let totalWorkedMinutes = Int(workedProgress * 48 * 60)
        let hours = totalWorkedMinutes / 60
        return "\(hours)h"
    }

    var workedMinutesLabel: String? {
        let totalWorkedMinutes = Int(workedProgress * 48 * 60)
        let minutes = totalWorkedMinutes % 60
        return minutes == 0 ? nil : "\(minutes)m"
    }

    // MARK: - Configure

    func configure(context: ModelContext) {
        self.classSessionRepository = ClassSessionRepository(context: context)
        self.workShiftRepository = WorkShiftRepository(context: context)
    }

    // MARK: - Load shift summary

    func loadShiftSummary() {
        guard let workShiftRepository else {
            errorMessage = "Work shift repository is not configured."
            return
        }

        do {
            let period = currentFortnightPeriod()

            let shifts = try workShiftRepository.fetchShifts(
                from: period.start,
                to: period.end
            )

            let totalHours = calculateTotalHours(from: shifts)
            let remainingHours = max(48 - totalHours, 0)

            workedHoursText = formatHours(totalHours)
            workedProgress = min(totalHours / 48, 1)

            let remainingMins = Int(remainingHours * 60)
            let rHours = remainingMins / 60
            let rMinutes = remainingMins % 60
            remainingHoursText = rMinutes == 0
                ? "\(rHours)h remaining"
                : "\(rHours)h \(rMinutes)m remaining"

            remainingHoursSubtitle = "Plan Shifts Carefully"
            errorMessage = nil

        } catch {
            errorMessage = "Failed to load shift summary."
            print("Load shift summary error:", error)
        }
    }

    // MARK: - Load upcoming classes

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
                    dayText: DateFormatHelper.formatDay(classSession.startTime),
                    location: classSession.location
                )
            }

            errorMessage = nil
        } catch {
            errorMessage = "Failed to load upcoming classes."
            print("Load upcoming classes error:", error)
        }
    }

    // MARK: - Helpers

    private func calculateTotalHours(from shifts: [WorkShift]) -> Double {
        shifts.reduce(into: 0.0) { total, shift in
            let duration = shift.endTime.timeIntervalSince(shift.startTime)
            let hours = duration / 3600
            total += max(hours, 0.0)
        }
    }

    private func formatHours(_ hours: Double) -> String {
        if hours.truncatingRemainder(dividingBy: 1) == 0 {
            return "\(Int(hours)) h"
        }
        return String(format: "%.1f h", hours)
    }

    private func currentFortnightPeriod(from date: Date = Date()) -> (start: Date, end: Date) {
        var calendar = Calendar.current
        calendar.firstWeekday = 2

        let startOfToday = calendar.startOfDay(for: date)

        guard let startOfCurrentWeek = calendar.dateInterval(
            of: .weekOfYear,
            for: startOfToday
        )?.start else {
            return (startOfToday, startOfToday)
        }

        let startOfPreviousWeek = calendar.date(
            byAdding: .day,
            value: -7,
            to: startOfCurrentWeek
        ) ?? startOfCurrentWeek

        let startOfNextWeek = calendar.date(
            byAdding: .day,
            value: 7,
            to: startOfCurrentWeek
        ) ?? startOfCurrentWeek

        return (
            start: startOfPreviousWeek,
            end: startOfNextWeek
        )
    }
}
