//
//  AssignmentCard.swift
//  StudyShift
//
//  Created by Chelvin Alexyus on 12/5/2026.
//

import SwiftUI

struct AssignmentCardView: View {
    let assignment: Assignment

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            topRow
            progressRow
        }
        .padding(14)
        .background(Color.surfaceCard)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var topRow: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "book.closed.fill")
                .foregroundStyle(.black)
                .padding(8)
                .background(Color.tealMain)
                .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 2) {
                Text(courseTitle)
                    .font(.caption.bold())

                Text("Target: \(targetGrade)")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text(targetGrade)
                .font(.caption.bold())
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(Color.tealMain)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }

    private var progressRow: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 6) {
                Text(assignment.title)
                    .font(.subheadline.bold())

                ProgressView(value: progressValue)
                    .tint(.purpleMain)

                Text(progressMessage)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            VStack(spacing: 6) {
                Text(statusText)
                    .font(.caption2.bold())
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(statusColor)
                    .clipShape(Capsule())

                Text(dueText)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var courseTitle: String {
        if let course = assignment.course {
            return "\(course.code) \(course.name)"
        }
        return "No Course Linked"
    }

    private var targetGrade: String {
        assignment.course?.targetGrade.rawValue ?? "--"
    }

    private var progressValue: Double {
        guard !assignment.tasks.isEmpty else { return 0.2 }
        let completed = assignment.tasks.filter(\.isCompleted).count
        return Double(completed) / Double(assignment.tasks.count)
    }

    private var progressMessage: String {
        let percent = Int((1 - progressValue) * 100)
        return "Need \(max(percent, 0))% more"
    }

    private var dueText: String {
        let days = Calendar.current.dateComponents([.day], from: .now, to: assignment.dueDate).day ?? 0
        if days <= 0 { return "Due Today" }
        if days == 1 { return "Due Tomorrow" }
        return "Due in \(days) days"
    }

    private var statusText: String {
        let days = Calendar.current.dateComponents([.day], from: .now, to: assignment.dueDate).day ?? 0
        if days <= 1 { return "Urgent" }
        if days <= 3 { return "Soon" }
        return "On Track"
    }

    private var statusColor: Color {
        let days = Calendar.current.dateComponents([.day], from: .now, to: assignment.dueDate).day ?? 0
        if days <= 1 { return .redMain }
        if days <= 3 { return .yellowMain }
        return .tealMain.opacity(0.35)
    }
}

