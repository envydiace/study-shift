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

    private let assessmentToEdit: Assessment?
    private let preselectedSubjectID: UUID?

    @State private var title = ""
    @State private var dueDate = Date()
    @State private var selectedCourseID: UUID?
    @State private var selectedAssignmentType: AssignmentType = .other
    @State private var selectedTargetGrade: GradeTarget = .highDistinction
    @State private var weightText = ""
    @State private var taskText = ""
    @State private var taskDrafts: [TaskDraft] = []
    @State private var didLoadInitialState = false

    @State private var showAlert = false
    @State private var alertMessage = ""

    init(
        assessmentToEdit: Assessment? = nil,
        preselectedSubjectID: UUID? = nil
    ) {
        self.assessmentToEdit = assessmentToEdit
        self.preselectedSubjectID = preselectedSubjectID
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
                            Text(assessmentToEdit == nil ? "+ Add Assignment" : "Save Changes")
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
            .navigationTitle("Add Assignment")
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
            .onChange(of: subjects.count) { _, _ in
                loadInitialStateIfNeeded()
            }
            .onChange(of: selectedCourseID) { _, newValue in
                guard let newValue,
                      let course = courses.first(where: { $0.id == newValue }) else { return }
                selectedTargetGrade = course.targetGrade
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
            }
            
            inputSection(title: "Deadline") {
                DatePicker("", selection: $dueDate, displayedComponents: .date)
                    .labelsHidden()
            }
            
            inputSection(title: "Course") {
                if courses.isEmpty {
                    Text("Add a subject first before creating an assignment.")
                        .foregroundStyle(.gray)
                        .font(.subheadline)
                } else {
                    Picker("Course", selection: $selectedCourseID) {
                        Text("Select a course").tag(Optional<UUID>.none)
                        ForEach(courses) { course in
                            Text(course.name).tag(Optional(course.id))
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
            
            inputSection(title: "Target Grade") {
                Picker("Target Grade", selection: $selectedTargetGrade) {
                    ForEach(GradeTarget.allCases, id: \.self) { grade in
                        Text(grade.rawValue).tag(grade)
                    }
                }
                .pickerStyle(.segmented)
            }
            
            inputSection(title: "Sub Tasks / To Do") {
                VStack(spacing: 10) {
                    HStack {
                        TextField("Task 1", text: $taskText)

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

        if let assessmentToEdit {
            didLoadInitialState = true
            title = assessmentToEdit.title
            dueDate = assessmentToEdit.dueDate
            selectedSubjectID = assessmentToEdit.subject?.id ?? preselectedSubjectID ?? subjects.first?.id
            selectedTargetGrade = assessmentToEdit.subject?.targetGrade ?? .highDistinction
            weightText = Self.wholeNumberFormatter.string(from: NSNumber(value: assessmentToEdit.weight)) ?? "\(Int(assessmentToEdit.weight))"
            wordLimitText = extractWordLimit(from: assessmentToEdit.note)
            taskDrafts = assessmentToEdit.tasks
                .sorted { $0.createdAt < $1.createdAt }
                .map { TaskDraft(id: $0.id, title: $0.title) }
            return
        }

        guard let matchedSubject = subjects.first(where: { $0.id == preselectedSubjectID }) ?? subjects.first else {
            return
        }

        didLoadInitialState = true
        selectedSubjectID = matchedSubject.id
        selectedTargetGrade = matchedSubject.targetGrade
    }

    private func saveAssignment() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedTitle.isEmpty {
            alertMessage = "Please enter an assignment title."
            showAlert = true
            return
        }
        
        guard let weight = Double(weightText), weight >= 0 else {
            alertMessage = "Please enter a valid weight."
            showAlert = true
            return
        }
        
        let selectedCourse = courses.first(where: { $0.id == selectedCourseID })
        
        let note = """
Target Grade: \(selectedTargetGrade.rawValue)
Assignment Type: \(selectedAssignmentType.rawValue)
"""
        
        let newAssignment = Assignment(
            title: trimmedTitle,
            assignmentType: selectedAssignmentType,
            dueDate: dueDate,
            weight: weight,
            status: .notStarted,
            note: note,
            course: selectedCourse
        )

        if assessmentToEdit == nil {
            modelContext.insert(assignment)
        }

        assignment.title = trimmedTitle
        assignment.dueDate = dueDate
        assignment.weight = weight
        assignment.note = note
        assignment.subject = selectedSubject

        syncTasks(for: assignment, selectedSubject: selectedSubject)

        do {
            try modelContext.save()
            dismiss()
        } catch {
            alertMessage = "Failed to save assignment changes."
            showAlert = true
        }
    }

    private func syncTasks(for assignment: Assessment, selectedSubject: Subject?) {
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
                task.subject = selectedSubject
                continue
            }

            let newTask = TodoTask(
                id: draft.id,
                title: draft.title,
                dueDate: dueDate,
                subject: selectedSubject,
                assessment: assignment
            )
            modelContext.insert(newTask)
            assignment.tasks.append(newTask)
        }
    }

    private func extractWordLimit(from note: String) -> String {
        note
            .split(separator: "\n")
            .compactMap { line -> String? in
                let parts = line.split(separator: ":", maxSplits: 1).map(String.init)
                guard parts.count == 2,
                      parts[0].trimmingCharacters(in: .whitespacesAndNewlines) == "Word Limit" else {
                    return nil
                }
                return parts[1].trimmingCharacters(in: .whitespacesAndNewlines)
            }
            .first?
            .replacingOccurrences(of: "-", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
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
}


#Preview {
    AddAssignmentView()
        .modelContainer(ModelContainerFactory.createPreviewContainer())
}
