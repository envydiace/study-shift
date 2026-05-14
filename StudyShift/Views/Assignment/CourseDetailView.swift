//
//  CourseDetailView.swift
//  StudyShift
//
//  Created by Chelvin Alexyus on 14/5/2026.
//

import SwiftUI

struct CourseDetailView: View {
    let course: Course

    var body: some View {
        ZStack {
            Color.tealMain
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 22) {
                    header
                    contentCard
                }
                .padding(.horizontal, 24)
                .padding(.top, 30)
                .padding(.bottom, 40)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    private var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Course Detail")
                    .font(.title2.bold())

                Text("Semester 3 | 2026")
                    .font(.subheadline)
            }

            Spacer()

            Image(systemName: "bell")
                .foregroundStyle(.black)
                .padding(8)
                .background(.white.opacity(0.85))
                .clipShape(Circle())
        }
        .foregroundStyle(.black)
    }

    private var contentCard: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("\(course.code) \(course.name)")
                .font(.title.bold())
                .foregroundStyle(.black)

            overallGradeCard

            VStack(alignment: .leading, spacing: 14) {
                Text("Graded Assessments")
                    .font(.title3.bold())
                    .foregroundStyle(.black)

                if gradedAssessments.isEmpty {
                    sectionEmptyState("No graded assessments yet")
                } else {
                    ForEach(gradedAssessments) { assessment in
                        NavigationLink {
                            AssignmentDetailView(assignment: assessment)
                        } label: {
                            scoreRow(
                                title: assessment.title,
                                trailingText: scoreText(for: assessment),
                                trailingColor: .tealMain
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }

            NavigationLink {
                AddAssignmentView(preselectedCourseID: course.id)
            } label: {
                Text("+ Add")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(PillButtonStyle())
            .padding(.horizontal, 36)

            VStack(alignment: .leading, spacing: 14) {
                Text("Pending Assessments")
                    .font(.title3.bold())
                    .foregroundStyle(.black)

                if pendingAssessments.isEmpty {
                    sectionEmptyState("No pending assessments")
                } else {
                    ForEach(pendingAssessments) { assessment in
                        NavigationLink {
                            AssignmentDetailView(assignment: assessment)
                        } label: {
                            pendingRow(for: assessment)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .padding(22)
        .background(Color.surfaceCard)
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }

    private var overallGradeCard: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack {
                Text("Current Overall Grade")
                    .font(.title3.weight(.semibold))

                Spacer()

                Text(overallBadgeText)
                    .font(.headline.bold())
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(overallBadgeColor)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .stroke(Color.redMain.opacity(0.25), lineWidth: 10)

                    Circle()
                        .trim(from: 0, to: min(overallGrade / 100, 1))
                        .stroke(
                            Color.redMain,
                            style: StrokeStyle(lineWidth: 10, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))

                    Text(displayNumber(overallGrade))
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                }
                .frame(width: 92, height: 92)

                Text("/100")
                    .font(.title2.bold())
                    .foregroundStyle(.black.opacity(0.85))

                Spacer()
            }
        }
        .padding(16)
        .background(Color(red: 0.87, green: 0.96, blue: 0.84))
        .clipShape(RoundedRectangle(cornerRadius: 22))
    }

    private func scoreRow(title: String, trailingText: String, trailingColor: Color) -> some View {
        HStack {
            Text(title)
                .font(.headline)
                .foregroundStyle(.black)

            Spacer()

            Text(trailingText)
                .font(.headline.bold())
                .foregroundStyle(.black)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(trailingColor)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    private func pendingRow(for assessment: Assignment) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(assessment.title)
                        .font(.headline)
                        .foregroundStyle(.black)

                    Text(weightText(for: assessment))
                        .font(.headline.bold())
                        .foregroundStyle(.black)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(Color.tealMain)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 8) {
                    Text(statusText(for: assessment))
                        .font(.caption.bold())
                        .foregroundStyle(statusForegroundColor(for: assessment))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(statusBackgroundColor(for: assessment))
                        .clipShape(Capsule())

                    Text(dueText(for: assessment))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            ProgressView(value: progressValue(for: assessment))
                .tint(.purpleMain)

            Text(progressMessage(for: assessment))
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(16)
        .background(.white.opacity(0.96))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    private func sectionEmptyState(_ text: String) -> some View {
        Text(text)
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
            .background(.white.opacity(0.8))
            .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    private var gradedAssessments: [Assignment] {
        course.assignments
            .filter { $0.achievedScore != nil }
            .sorted { $0.dueDate < $1.dueDate }
    }

    private var pendingAssessments: [Assignment] {
        course.assignments
            .filter { $0.achievedScore == nil }
            .sorted { $0.dueDate < $1.dueDate }
    }

    private var overallGrade: Double {
        gradedAssessments.reduce(0) { $0 + $1.weightedScore }
    }

    private var overallBadgeText: String {
        if gradedAssessments.isEmpty {
            return "Pending"
        }
        return overallGrade >= 50 ? "Pass" : "At Risk"
    }

    private var overallBadgeColor: Color {
        if gradedAssessments.isEmpty {
            return .yellowMain
        }

        if overallGrade >= 50 {
            return .tealMain
        } else {
            return .yellowMain
        }
    }

    private func scoreText(for assessment: Assignment) -> String {
        "\(displayNumber(assessment.achievedScore ?? 0))/\(displayNumber(assessment.maxScore))"
    }

    private func weightText(for assessment: Assignment) -> String {
        "\(displayNumber(assessment.weight)) Pts"
    }

    private func progressValue(for assessment: Assignment) -> Double {
        guard !assessment.tasks.isEmpty else { return 0.2 }
        let completed = assessment.tasks.filter(\.isCompleted).count
        return Double(completed) / Double(assessment.tasks.count)
    }

    private func progressMessage(for assessment: Assignment) -> String {
        let percent = Int((1 - progressValue(for: assessment)) * 100)
        return "Need \(max(percent, 0))% more"
    }

    private func dueText(for assessment: Assignment) -> String {
        let days = Calendar.current.dateComponents([.day], from: .now, to: assessment.dueDate).day ?? 0
        if days <= 0 { return "Due Today" }
        if days == 1 { return "Due Tomorrow" }
        return "Due in \(days) days"
    }

    private func statusText(for assessment: Assignment) -> String {
        let days = Calendar.current.dateComponents([.day], from: .now, to: assessment.dueDate).day ?? 0
        if days <= 1 { return "Urgent" }
        if days <= 3 { return "Soon" }
        return "On Track"
    }

    private func statusBackgroundColor(for assessment: Assignment) -> Color {
        let status = statusText(for: assessment)
        switch status {
        case "Urgent":
            return .redMain
        case "Soon":
            return .yellowMain
        default:
            return .tealMain.opacity(0.35)
        }
    }

    private func statusForegroundColor(for assessment: Assignment) -> Color {
        let status = statusText(for: assessment)
        switch status {
        case "Urgent":
            return .red
        default:
            return .black
        }
    }

    private func displayNumber(_ value: Double) -> String {
        if value.rounded(.towardZero) == value {
            return String(Int(value))
        }
        return String(format: "%.1f", value)
    }
}

#Preview {
    NavigationStack {
        CourseDetailView(course: Course(name: "Cloud Computing", code: "42904"))
    }
}
