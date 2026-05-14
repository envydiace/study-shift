//
//  NewAssignmentView.swift
//  StudyShift
//
//  Created by Chelvin Alexyus on 12/5/2026.
//

import SwiftUI
import SwiftData

struct AddAssignmentView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Course.name) private var courses: [Course]

    private let assignmentToEdit: Assignment?
    private let preselectedCourseID: UUID?

    @State private var title = ""
    @State private var dueDate = Date()
    @State private var selectedCourseID: UUID?
    @State private var selectedAssignmentType: AssignmentType = .other
    @State private var weightText = ""
    @State private var maxScoreText = ""
    @State private var taskText = ""
    @State private var taskDrafts: [TaskDraft] = []
    @State private var didLoadInitialState = false

    @State private var showAlert = false
    @State private var alertMessage = ""

    init(
        assignmentToEdit: Assignment? = nil,
        preselectedCourseID: UUID? = nil
    ) {
        self.assignmentToEdit = assignmentToEdit
        self.preselectedCourseID = preselectedCourseID
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.tealMain
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 18) {
                        
                        form
                        
                        Button {
                        saveAssignment()
                        } label: {
                            Text(assignmentToEdit == nil ? "+ Add Assignment" : "Save Changes")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(PillButtonStyle())
                        .padding(.top, 8)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                }
            }
            .background(Color.tealMain)
            .navigationTitle(assignmentToEdit == nil ? "Add Assignment" :"Edit Assignment")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .alert("Add Assignment", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
            .onAppear {
                loadInitialStateIfNeeded()
            }
            .onChange(of: courses.count) { _, _ in
                loadInitialStateIfNeeded()
            }
        }
    }
                
    private var selectedCourse: Course? {
        guard let selectedCourseID else { return nil }
        return courses.first(where: { $0.id == selectedCourseID })
    }
    
    private var form: some View {
        VStack(alignment: .leading, spacing: 18) {
            inputSection(title: "Assignment Title") {
                TextField("Assignment 1", text: $title)
                    .autocorrectionDisabled(true)
            }
            
            inputSection(title: "Deadline") {
                DatePicker("", selection: $dueDate, displayedComponents: [.date, .hourAndMinute])
                    .labelsHidden()
            }
            
            inputSection(title: "Course") {
                if courses.isEmpty {
                    Text("Add a course first before creating an assignment.")
                        .foregroundStyle(.gray)
                        .font(.subheadline)
                } else {
                    Picker("Course", selection: $selectedCourseID) {
                        Text("Select a course").tag(Optional<UUID>.none)
                        ForEach(courses) { course in
                            Text("\(course.code) - \(course.name)").tag(Optional(course.id))
                        }
                    }
                    .pickerStyle(.menu)
                }
            }
            
            inputSection(title: "Assignment Type") {
                Picker("Course", selection: $selectedAssignmentType) {
                    ForEach(AssignmentType.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .pickerStyle(.menu)
            }
            
            inputSection(title: "Weight (%)") {
                TextField("40", text: $weightText)
                    .keyboardType(.decimalPad)
            }
            
            inputSection(title: "Maximum Mark") {
                TextField("Optional, 1 - 100", text: $maxScoreText)
                    .keyboardType(.decimalPad)
            }
            
            inputSection(title: "Sub Tasks / To Do") {
                VStack(spacing: 10) {
                    HStack {
                        TextField("Task 1", text: $taskText)
                            .autocorrectionDisabled(true)

                        Button {
                            addTask()
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.title3)
                                .foregroundStyle(.tealDark)
                        }
                    }

                    if !taskDrafts.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(taskDrafts) { task in
                                HStack {
                                    Text(task.title)
                                        .font(.subheadline)

                                    Spacer()

                                    Button {
                                        removeTask(task)
                                    } label: {
                                        Image(systemName: "minus.circle.fill")
                                            .foregroundStyle(.redMain)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
        }
    }

    private func inputSection<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption.bold())
            
            content()
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.surfaceCard)
                .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }
        
    private func addTask() {
        let trimmed = taskText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        taskDrafts.append(TaskDraft(title: trimmed))
        taskText = ""
    }

    private func removeTask(_ task: TaskDraft) {
        taskDrafts.removeAll { $0.id == task.id }
    }

    private func loadInitialStateIfNeeded() {
        guard !didLoadInitialState else { return }

        if let assignmentToEdit {
            didLoadInitialState = true
            title = assignmentToEdit.title
            dueDate = assignmentToEdit.dueDate
            selectedCourseID = assignmentToEdit.course?.id ?? preselectedCourseID ?? courses.first?.id
            selectedAssignmentType = assignmentToEdit.assignmentType
            weightText = Self.wholeNumberFormatter.string(from: NSNumber(value: assignmentToEdit.weight)) ?? "\(Int(assignmentToEdit.weight))"
            if let maxScore = assignmentToEdit.maxScore {
                maxScoreText = Self.numberFormatter.string(from: NSNumber(value: maxScore)) ?? "\(maxScore)"
            } else {
                maxScoreText = ""
            }
            taskDrafts = assignmentToEdit.tasks
                .sorted { $0.createdAt < $1.createdAt }
                .map { TaskDraft(id: $0.id, title: $0.title) }
            return
        }

        guard let matchedCourse = courses.first(where: { $0.id == preselectedCourseID }) ?? courses.first else {
            return
        }

        didLoadInitialState = true
        selectedCourseID = matchedCourse.id
    }

    private func saveAssignment() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedTitle.isEmpty {
            alertMessage = "Please enter an assignment title."
            showAlert = true
            return
        }
        
        guard let weight = Double(weightText.trimmingCharacters(in: .whitespacesAndNewlines)),
                  weight > 0,
                  weight <= 100
            else {
                alertMessage = "Weight must be a number more than 0 and less than or equal to 100."
                showAlert = true
                return
            }
        
        let maxScore: Double?

        let trimmedMaxScore = maxScoreText.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmedMaxScore.isEmpty {
            maxScore = nil
        } else if let value = Double(trimmedMaxScore), value > 0, value <= 100 {
            maxScore = value
        } else {
            alertMessage = "Maximum mark must be a number more than 0 and less than or equal to 100."
            showAlert = true
            return
        }
        
        let selectedCourse = courses.first(where: { $0.id == selectedCourseID })
        
        let note = """
Assignment Type: \(selectedAssignmentType.rawValue)
"""

        let assignment: Assignment
        if let assignmentToEdit {
            assignment = assignmentToEdit
        } else {
            assignment = Assignment(
                title: trimmedTitle,
                assignmentType: selectedAssignmentType,
                dueDate: dueDate,
                weight: weight,
                maxScore: maxScore,
                status: .notStarted,
                note: note,
                course: selectedCourse
            )
            modelContext.insert(assignment)
        }

        assignment.title = trimmedTitle
        assignment.assignmentType = selectedAssignmentType
        assignment.dueDate = dueDate
        assignment.weight = weight
        assignment.maxScore = maxScore
        assignment.note = note
        assignment.course = selectedCourse

        syncTasks(for: assignment, selectedCourse: selectedCourse)

        do {
            try modelContext.save()
            dismiss()
        } catch {
            alertMessage = "Failed to save assignment changes."
            showAlert = true
        }
    }

    private func syncTasks(for assignment: Assignment, selectedCourse: Course?) {
        let trimmed = taskText.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty {
            taskDrafts.append(TaskDraft(title: trimmed))
        }
        
        let existingTasksByID = Dictionary(uniqueKeysWithValues: assignment.tasks.map { ($0.id, $0) })
        let retainedIDs = Set(taskDrafts.map(\.id))

        for task in assignment.tasks where !retainedIDs.contains(task.id) {
            modelContext.delete(task)
        }

        assignment.tasks.removeAll { !retainedIDs.contains($0.id) }

        for draft in taskDrafts {
            if let task = existingTasksByID[draft.id] {
                task.title = draft.title
                task.dueDate = dueDate
                task.course = selectedCourse
                continue
            }

            let newTask = TodoTask(
                id: draft.id,
                title: draft.title,
                dueDate: dueDate,
                course: selectedCourse,
                assignment: assignment
            )
            modelContext.insert(newTask)
            assignment.tasks.append(newTask)
        }
    }

    private struct TaskDraft: Identifiable {
        let id: UUID
        var title: String

        init(id: UUID = UUID(), title: String) {
            self.id = id
            self.title = title
        }
    }

    private static let wholeNumberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 0
        formatter.minimumFractionDigits = 0
        return formatter
    }()
    
    private static let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        return formatter
    }()
}


#Preview {
    AddAssignmentView()
        .modelContainer(ModelContainerFactory.createPreviewContainer())
}
