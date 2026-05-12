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
    @Query(sort: \Subject.name) private var subjects: [Subject]

    @State private var title = ""
    @State private var dueDate = Date()
    @State private var selectedSubjectID: UUID?
    @State private var selectedTargetGrade: GradeTarget = .highDistinction
    @State private var weightText = ""
    @State private var wordLimitText = ""
    @State private var taskDraft = ""
    @State private var taskTitles: [String] = []
    @State private var showError = false
    @State private var errorMessage = ""

    var body: some View {
        ZStack {
            Color.tealMain
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 18) {
                    header

                    fieldSection("Assignment Title") {
                        TextField("Assignment 1", text: $title)
                    }

                    fieldSection("Deadline") {
                        DatePicker("", selection: $dueDate, displayedComponents: .date)
                            .labelsHidden()
                    }

                    fieldSection("Course") {
                        if subjects.isEmpty {
                            Text("Add a subject first to link this assignment to a course.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        } else {
                            Picker("Course", selection: $selectedSubjectID) {
                                Text("Select a course").tag(Optional<UUID>.none)
                                ForEach(subjects) { subject in
                                    Text(subject.name).tag(Optional(subject.id))
                                }
                            }
                            .pickerStyle(.menu)
                        }
                    }

                    fieldSection("Target Grade") {
                        Picker("Target Grade", selection: $selectedTargetGrade) {
                            ForEach(GradeTarget.allCases, id: \.self) { grade in
                                Text(grade.rawValue).tag(grade)
                            }
                        }
                        .pickerStyle(.segmented)
                    }

                    fieldSection("Weight (%)") {
                        TextField("40", text: $weightText)
                            .keyboardType(.decimalPad)
                    }

                    fieldSection("Word Limit") {
                        TextField("1000", text: $wordLimitText)
                            .keyboardType(.numberPad)
                    }

                    fieldSection("Sub Tasks / To Do") {
                        VStack(spacing: 10) {
                            HStack {
                                TextField("Add a task", text: $taskDraft)

                                Button {
                                    addTask()
                                } label: {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.title3)
                                        .foregroundStyle(.tealDark)
                                }
                            }

                            if !taskTitles.isEmpty {
                                VStack(alignment: .leading, spacing: 8) {
                                    ForEach(taskTitles, id: \.self) { task in
                                        HStack {
                                            Image(systemName: "checkmark.square")
                                                .foregroundStyle(.tealDark)
                                            Text(task)
                                                .font(.subheadline)
                                        }
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }

                    Button {
                        saveAssignment()
                    } label: {
                        Text("+ Add Assignment")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.plain)
                    .padding(.top, 8)
                }
                .padding(.horizontal, 24)
                .padding(.top, 55)
                .padding(.bottom, 40)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .alert("Could not save", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
        .onAppear {
            if let firstSubject = subjects.first {
                selectedSubjectID = firstSubject.id
                selectedTargetGrade = firstSubject.targetGrade
            }
        }
        .onChange(of: selectedSubjectID) { _, newValue in
            guard let newValue,
                  let subject = subjects.first(where: { $0.id == newValue }) else { return }
            selectedTargetGrade = subject.targetGrade
        }
    }

    private var selectedSubject: Subject? {
        guard let selectedSubjectID else { return nil }
        return subjects.first(where: { $0.id == selectedSubjectID })
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Add Assignment")
                    .font(.title3.bold())

                Text("Semester 3 | 2026")
                    .font(.caption)
            }

            Spacer()

            Image(systemName: "bell")
                .foregroundStyle(.black)
                .padding(8)
                .background(Color.white)
                .clipShape(Circle())
        }
        .foregroundStyle(.black)
    }

    private func fieldSection<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption.bold())
                .foregroundStyle(.black)

            content()
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.surfaceCard)
                .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }

    private func addTask() {
        let trimmed = taskDraft.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        taskTitles.append(trimmed)
        taskDraft = ""
    }

    private func saveAssignment() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else {
            presentError("Please enter an assignment title.")
            return
        }

        guard let weight = Double(weightText), weight >= 0 else {
            presentError("Please enter a valid weight.")
            return
        }

        let note = """
        Target Grade: \(selectedTargetGrade.rawValue)
        Word Limit: \(wordLimitText.isEmpty ? "-" : wordLimitText)
        """

        let assignment = Assessment(
            title: trimmedTitle,
            assessmentType: .assignment,
            dueDate: dueDate,
            weight: weight,
            status: .notStarted,
            note: note,
            subject: selectedSubject
        )

        modelContext.insert(assignment)

        for taskTitle in taskTitles {
            let task = TodoTask(
                title: taskTitle,
                dueDate: dueDate,
                subject: selectedSubject,
                assessment: assignment
            )
            modelContext.insert(task)
            assignment.tasks.append(task)
        }

        do {
            try modelContext.save()
            dismiss()
        } catch {
            presentError("Failed to save assignment.")
        }
    }

    private func presentError(_ message: String) {
        errorMessage = message
        showError = true
    }
}

#Preview {
    AddAssignmentView()
}

