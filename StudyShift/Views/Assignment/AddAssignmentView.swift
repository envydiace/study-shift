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

    @State private var title = ""
    @State private var dueDate = Date()
    @State private var selectedCourseID: UUID?
    @State private var selectedTargetGrade: GradeTarget = .highDistinction
    @State private var weightText = ""
    @State private var wordLimitText = ""
    @State private var taskText = ""
    @State private var taskList: [String] = []

    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationStack {
            ZStack {
                Color.tealMain
                    .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    header

                    inputSection(title: "Assignment Title") {
                        TextField("Assignment 1", text: $title)
                    }

                    inputSection(title: "Deadline") {
                        DatePicker("", selection: $dueDate, displayedComponents: .date)
                            .labelsHidden()
                    }

                    inputSection(title: "Course") {
                        if subjects.isEmpty {
                            Text("Add a subject first before creating an assignment.")
                                .foregroundStyle(.gray)
                                .font(.subheadline)
                        } else {
                            Picker("Course", selection: $selectedSubjectID) {
                                Text("Select a course").tag(Optional<UUID>.none)
                                ForEach(subjects) { subject in
                                    Text(subject.name).tag(Optional(subject.id))
                                }
                            }
                            .pickerStyle(.menu)
                        }

                    inputSection(title: "Target Grade") {
                        Picker("Target Grade", selection: $selectedTargetGrade) {
                            ForEach(GradeTarget.allCases, id: \.self) { grade in
                                Text(grade.rawValue).tag(grade)
                            }
                        }

                    inputSection(title: "Weight (%)") {
                        TextField("40", text: $weightText)
                            .keyboardType(.decimalPad)
                    }

                    inputSection(title: "Word Limit") {
                        TextField("1000", text: $wordLimitText)
                            .keyboardType(.numberPad)
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

                            if !taskList.isEmpty {
                                VStack(alignment: .leading, spacing: 8) {
                                    ForEach(taskList, id: \.self) { task in
                                        Text("• \(task)")
                                            .font(.subheadline)
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
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle("Add Assignment")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .buttonStyle(PillButtonStyle())
                    .padding(.top, 8)
                }
                .padding(.horizontal, 24)
                .padding(.top, 24)
                .padding(.bottom, 40)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .alert("Add Assignment", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
        .onAppear {
            if let firstCourse = courses.first {
                selectedCourseID = firstCourse.id
                selectedTargetGrade = firstCourse.targetGrade
            }
        }
        .onChange(of: selectedCourseID) { _, newValue in
            guard let newValue,
                  let course = courses.first(where: { $0.id == newValue }) else { return }
            selectedTargetGrade = course.targetGrade
        }
    }

    private var selectedCourse: Course? {
        guard let selectedCourseID else { return nil }
        return courses.first(where: { $0.id == selectedCourseID })
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
                .padding(8)
                .background(.white)
                .clipShape(Circle())
        }
        .foregroundStyle(.black)
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
        taskList.append(trimmed)
        taskText = ""
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

        let selectedSubject = subjects.first(where: { $0.id == selectedSubjectID })

        let note = """
        Target Grade: \(selectedTargetGrade.rawValue)
        Word Limit: \(wordLimitText.isEmpty ? "-" : wordLimitText)
        """

        let assignment = Assignment(
            title: trimmedTitle,
            assignmentType: .assignment,
            dueDate: dueDate,
            weight: weight,
            status: .notStarted,
            note: note,
            course: selectedCourse
        )

        modelContext.insert(newAssignment)

        for item in taskList {
            let task = TodoTask(
                title: item,
                dueDate: dueDate,
                course: selectedCourse,
                assignment: assignment
            )
            modelContext.insert(task)
            newAssignment.tasks.append(task)
        }

        do {
            print("Starting Save")
            try modelContext.save()
            print("Saving...")
            dismiss()
        } catch {
            alertMessage = "Failed to save assignment."
            showAlert = true
        }
    }
}


#Preview {
    AddAssignmentView()
        .modelContainer(ModelContainerFactory.createPreviewContainer())
}
