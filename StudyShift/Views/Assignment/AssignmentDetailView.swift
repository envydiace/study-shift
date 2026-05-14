//
//  AssessmentDetailView.swift
//  StudyShift
//
//  Created by Chelvin Alexyus on 14/5/2026.
//

import SwiftUI
import SwiftData

struct AssignmentDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    let assessment: Assessment

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
                Text("Assessment Details")
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
        VStack(alignment: .leading, spacing: 20) {
            subjectSummaryCard
            todoCard
            briefPreviewCard
            actionRow

            Button {
                dismiss()
            } label: {
                Text("Assessment List")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(PillButtonStyle())
            .padding(.top, 10)
            .padding(.horizontal, 60)
        }
        .padding(22)
        .background(Color.surfaceCard)
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }

    private var subjectSummaryCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: "book.pages.fill")
                    .foregroundStyle(.black)
                    .padding(10)
                    .background(Color.tealMain)
                    .clipShape(RoundedRectangle(cornerRadius: 10))

                VStack(alignment: .leading, spacing: 2) {
                    Text(subjectTitle)
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(.black)

                    Text("Target: \(targetGrade)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }

            Text(assessment.title)
                .font(.title3.bold())
                .foregroundStyle(.black)

            HStack(alignment: .center) {
                ProgressView(value: progressValue)
                    .tint(.purpleMain)

                Spacer(minLength: 16)

                Text(statusText)
                    .font(.caption.bold())
                    .foregroundStyle(statusForegroundColor)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(statusBackgroundColor)
                    .clipShape(Capsule())
            }

            HStack {
                Text(progressMessage)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Spacer()

                Text(dueText)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var todoCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("To do List")
                .font(.title3.weight(.semibold))
                .foregroundStyle(.black)

            if assessment.tasks.isEmpty {
                Text("No tasks added yet")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } else {
                ForEach(sortedTasks) { task in
                    Button {
                        toggle(task)
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: task.isCompleted ? "checkmark.square.fill" : "square")
                                .font(.title3)
                                .foregroundStyle(task.isCompleted ? .blue : .secondary)

                            Text(task.title)
                                .font(.subheadline)
                                .foregroundStyle(.black.opacity(task.isCompleted ? 0.55 : 1))
                                .strikethrough(task.isCompleted)

                            Spacer()
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(red: 0.87, green: 0.96, blue: 0.84))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private var briefPreviewCard: some View {
        VStack(spacing: 0) {
            HStack(spacing: 10) {
                Circle()
                    .fill(Color.gray.opacity(0.35))
                    .frame(width: 8, height: 8)
                Circle()
                    .fill(Color.gray.opacity(0.35))
                    .frame(width: 8, height: 8)

                Spacer()

                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                    .font(.caption)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.black.opacity(0.12))

            VStack(spacing: 8) {
                Text(subjectTitle)
                    .font(.headline)

                Text(assessment.assessmentType.rawValue)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Divider()
                    .padding(.horizontal, 36)

                Text(briefPreviewText)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 28)

                Divider()
                    .padding(.horizontal, 36)

                Text("Weight: \(displayNumber(assessment.weight))%")
                    .font(.caption.bold())

                Text(dueDateLongText)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 26)
            .background(.white)
        }
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.black.opacity(0.12), lineWidth: 1)
        )
    }

    private var actionRow: some View {
        HStack(spacing: 16) {
            NavigationLink {
                AddAssignmentView(
                    assessmentToEdit: assessment,
                    preselectedSubjectID: assessment.subject?.id
                )
            } label: {
                Text("Edit")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(PillButtonStyle())

            Button {
                markAsDone()
            } label: {
                Text(doneButtonTitle)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(PillButtonStyle())
        }
    }

    private var subjectTitle: String {
        if let subject = assessment.subject {
            return "\(subject.code) \(subject.name)"
        }
        return "No Course Linked"
    }

    private var targetGrade: String {
        assessment.subject?.targetGrade.rawValue ?? "--"
    }

    private var progressValue: Double {
        guard !assessment.tasks.isEmpty else { return 0.2 }
        let completed = assessment.tasks.filter(\.isCompleted).count
        return Double(completed) / Double(assessment.tasks.count)
    }

    private var progressMessage: String {
        let percent = Int((1 - progressValue) * 100)
        return "Need \(max(percent, 0))% more"
    }

    private var dueText: String {
        let days = Calendar.current.dateComponents([.day], from: .now, to: assessment.dueDate).day ?? 0
        if days <= 0 { return "Due Today" }
        if days == 1 { return "Due Tomorrow" }
        return "Due in \(days) days"
    }

    private var dueDateLongText: String {
        assessment.dueDate.formatted(date: .long, time: .omitted)
    }

    private var statusText: String {
        if assessment.status == .submitted || assessment.status == .marked {
            return "Done"
        }

        let days = Calendar.current.dateComponents([.day], from: .now, to: assessment.dueDate).day ?? 0
        if days <= 1 { return "Urgent" }
        if days <= 3 { return "Soon" }
        return "On Track"
    }

    private var statusBackgroundColor: Color {
        switch statusText {
        case "Done":
            return .tealMain
        case "Urgent":
            return .redMain
        case "Soon":
            return .yellowMain
        default:
            return .tealMain.opacity(0.35)
        }
    }

    private var statusForegroundColor: Color {
        switch statusText {
        case "Done":
            return .tealDark
        case "Urgent":
            return .red
        default:
            return .black
        }
    }

    private var sortedTasks: [TodoTask] {
        assessment.tasks.sorted { $0.createdAt < $1.createdAt }
    }

    private var briefPreviewText: String {
        let trimmed = assessment.note.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            return "Add assignment notes or a brief to keep the reference material for this assessment in one place."
        }
        return trimmed
    }

    private var doneButtonTitle: String {
        assessment.status == .submitted || assessment.status == .marked ? "Completed" : "Mark As Done"
    }

    private func toggle(_ task: TodoTask) {
        task.isCompleted.toggle()
        updateAssessmentStatusAfterTaskChange()
        saveChanges()
    }

    private func markAsDone() {
        for task in assessment.tasks {
            task.isCompleted = true
        }
        assessment.status = .submitted
        saveChanges()
    }

    private func updateAssessmentStatusAfterTaskChange() {
        guard !assessment.tasks.isEmpty else { return }

        let completedCount = assessment.tasks.filter(\.isCompleted).count
        if completedCount == assessment.tasks.count {
            assessment.status = .submitted
        } else if completedCount > 0 {
            assessment.status = .inProgress
        } else {
            assessment.status = .notStarted
        }
    }

    private func saveChanges() {
        do {
            try modelContext.save()
        } catch {
            assertionFailure("Failed to save assessment detail changes: \(error)")
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
        AssignmentDetailView(
            assessment: Assessment(
                title: "Assignment 2",
                assessmentType: .assignment,
                dueDate: .now.addingTimeInterval(86_400),
                weight: 30
            )
        )
    }
}
