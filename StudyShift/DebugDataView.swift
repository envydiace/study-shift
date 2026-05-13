//
//  DebugDataView.swift
//  StudyShift
//
//  Created by Đức Anh on 26/4/26.
//

import SwiftUI
import SwiftData

struct DebugDataView: View {
    @Environment(\.modelContext) private var context

    @State private var courses: [Course] = []
    @State private var assessments: [Assignment] = []
    @State private var tasks: [TodoTask] = []
    @State private var shifts: [WorkShift] = []
    @State private var sessions: [ClassSession] = []
    @State private var errorMessage: String = ""

    var body: some View {
        NavigationStack {
            List {
                Section("Courses") {
                    ForEach(courses) { course in
                        Button {
                            printCoursesCSV()
                        } label: {
                            VStack(alignment: .leading) {
                                Text(course.name)
                                    .font(.headline)

                                Text(course.code)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }

                Section("Assessments") {
                    ForEach(assessments) { assessment in
                        Button {
                            printAssessmentsCSV()
                        } label: {
                            VStack(alignment: .leading) {
                                Text(assessment.title)
                                    .font(.headline)

                                Text(assessment.status.rawValue)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }

                Section("Tasks") {
                    ForEach(tasks) { task in
                        Button {
                            printTasksCSV()
                        } label: {
                            VStack(alignment: .leading) {
                                Text(task.title)
                                    .font(.headline)

                                if let dueDate = task.dueDate {
                                    Text("Due: \(formatDate(dueDate))")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }

                Section("Work Shifts") {
                    ForEach(shifts) { shift in
                        Button {
                            printWorkShiftsCSV()
                        } label: {
                            VStack(alignment: .leading) {
                                Text(shift.workplace.isEmpty ? shift.title : shift.workplace)
                                    .font(.headline)

                                Text("\(formatDouble(shift.totalHours)) hours")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }

                Section("Class Sessions") {
                    ForEach(sessions) { session in
                        Button {
                            printClassSessionsCSV()
                        } label: {
                            VStack(alignment: .leading) {
                                Text(session.title)
                                    .font(.headline)

                                Text(formatDate(session.startTime))
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .navigationTitle("Debug Data")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Reload") {
                        loadData()
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("Print All CSV") {
                        printAllCSV()
                    }
                }
            }
            .task {
                loadData()
            }
            .refreshable {
                loadData()
            }
            .alert("Error", isPresented: errorBinding) {
                Button("OK", role: .cancel) {
                    errorMessage = ""
                }
            } message: {
                Text(errorMessage)
            }
        }
    }

    private var errorBinding: Binding<Bool> {
        Binding(
            get: { !errorMessage.isEmpty },
            set: { isPresented in
                if !isPresented {
                    errorMessage = ""
                }
            }
        )
    }

    private func loadData() {
        do {
            courses = try CourseRepository(context: context).fetchAll()
            assessments = try AssignmentRepository(context: context).fetchAll()
            tasks = try TodoTaskRepository(context: context).fetchAll()
            shifts = try WorkShiftRepository(context: context).fetchAll()
            sessions = try ClassSessionRepository(context: context).fetchAll()
            errorMessage = ""
        } catch {
            errorMessage = "Failed to load debug data."
            print("Failed to load debug data: \(error)")
        }
    }

    // MARK: - Print All

    private func printAllCSV() {
        printCoursesCSV()
        printClassSessionsCSV()
        printAssessmentsCSV()
        printTasksCSV()
        printWorkShiftsCSV()
    }

    // MARK: - CSV Print Functions

    private func printCoursesCSV() {
        printCSV(
            title: "COURSES",
            headers: [
                "id",
                "name",
                "code",
                "colorHex",
                "targetGrade",
                "classSessionCount",
                "assessmentCount",
                "taskCount"
            ],
            rows: courses.map { course in
                [
                    course.id.uuidString,
                    course.name,
                    course.code,
                    course.colorHex,
                    course.targetGrade.rawValue,
                    "\(course.classSessions.count)",
                    "\(course.assignments.count)",
                    "\(course.tasks.count)"
                ]
            }
        )
    }

    private func printAssessmentsCSV() {
        printCSV(
            title: "ASSESSMENTS",
            headers: [
                "id",
                "title",
                "assessmentType",
                "dueDate",
                "weight",
                "maxScore",
                "achievedScore",
                "weightedScore",
                "status",
                "note",
                "courseId",
                "courseName",
                "taskCount"
            ],
            rows: assessments.map { assessment in
                [
                    assessment.id.uuidString,
                    assessment.title,
                    assessment.assignmentType.rawValue,
                    formatDate(assessment.dueDate),
                    formatDouble(assessment.weight),
                    formatDouble(assessment.maxScore),
                    assessment.achievedScore == nil ? "" : formatDouble(assessment.achievedScore!),
                    formatDouble(assessment.weightedScore),
                    assessment.status.rawValue,
                    assessment.note,
                    assessment.course?.id.uuidString ?? "",
                    assessment.course?.name ?? "",
                    "\(assessment.tasks.count)"
                ]
            }
        )
    }

    private func printTasksCSV() {
        printCSV(
            title: "TODO_TASKS",
            headers: [
                "id",
                "title",
                "note",
                "dueDate",
                "isCompleted",
                "priority",
                "createdAt",
                "scheduledStart",
                "scheduledEnd",
                "scheduledDurationHours",
                "courseId",
                "courseName",
                "assessmentId",
                "assessmentTitle"
            ],
            rows: tasks.map { task in
                [
                    task.id.uuidString,
                    task.title,
                    task.note,
                    task.dueDate == nil ? "" : formatDate(task.dueDate!),
                    formatBool(task.isCompleted),
                    task.priority.rawValue,
                    formatDate(task.createdAt),
                    task.scheduledStart == nil ? "" : formatDate(task.scheduledStart!),
                    task.scheduledEnd == nil ? "" : formatDate(task.scheduledEnd!),
                    formatDouble(task.scheduledDurationHours),
                    task.course?.id.uuidString ?? "",
                    task.course?.name ?? "",
                    task.assignment?.id.uuidString ?? "",
                    task.assignment?.title ?? ""
                ]
            }
        )
    }

    private func printWorkShiftsCSV() {
        printCSV(
            title: "WORK_SHIFTS",
            headers: [
                "id",
                "title",
                "workplace",
                "startTime",
                "endTime",
                "colorHex",
                "totalHours",
                "note"
            ],
            rows: shifts.map { shift in
                [
                    shift.id.uuidString,
                    shift.title,
                    shift.workplace,
                    formatDate(shift.startTime),
                    formatDate(shift.endTime),
                    shift.colorHex,
                    formatDouble(shift.totalHours),
                    shift.note
                ]
            }
        )
    }

    private func printClassSessionsCSV() {
        printCSV(
            title: "CLASS_SESSIONS",
            headers: [
                "id",
                "title",
                "location",
                "startTime",
                "endTime",
                "colorHex",
                "courseId",
                "courseName"
            ],
            rows: sessions.map { session in
                [
                    session.id.uuidString,
                    session.title,
                    session.location ?? "",
                    formatDate(session.startTime),
                    formatDate(session.endTime),
                    session.colorHex,
                    session.course?.id.uuidString ?? "",
                    session.course?.name ?? ""
                ]
            }
        )
    }

    // MARK: - CSV Helper

    private func printCSV(
        title: String,
        headers: [String],
        rows: [[String]]
    ) {
        print("\n===== \(title) =====")
        print(headers.map(csvEscape).joined(separator: ","))

        for row in rows {
            print(row.map(csvEscape).joined(separator: ","))
        }

        print("===== END \(title) =====\n")
    }

    private func csvEscape(_ value: String) -> String {
        var escaped = value.replacingOccurrences(of: "\"", with: "\"\"")

        if escaped.contains(",") ||
            escaped.contains("\"") ||
            escaped.contains("\n") {
            escaped = "\"\(escaped)\""
        }

        return escaped
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.string(from: date)
    }

    private func formatBool(_ value: Bool) -> String {
        value ? "true" : "false"
    }

    private func formatDouble(_ value: Double) -> String {
        String(format: "%.2f", value)
    }
}

#Preview {
    DebugDataView()
        .modelContainer(debugDataPreviewContainer)
}

private var debugDataPreviewContainer: ModelContainer {
    let schema = Schema([
        Course.self,
        Assignment.self,
        TodoTask.self,
        WorkShift.self,
        ClassSession.self
    ])
    let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)

    do {
        return try ModelContainer(for: schema, configurations: [configuration])
    } catch {
        fatalError("Failed to create preview container: \(error)")
    }
}
