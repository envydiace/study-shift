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
    @State private var selectedAssignmentType: AssignmentType = .other
    @State private var selectedTargetGrade: GradeTarget = .highDistinction
    @State private var weightText = ""
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
                        
                        form
                        
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
            
            inputSection(title: "Target Grade") {
                Picker("Target Grade", selection: $selectedTargetGrade) {
                    ForEach(GradeTarget.allCases, id: \.self) { grade in
                        Text(grade.rawValue).tag(grade)
                    }
                }
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
                        TextField("Add a task", text: $taskText)
                        
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
        
        modelContext.insert(newAssignment)
        
        for item in taskList {
            let task = TodoTask(
                title: item,
                dueDate: dueDate,
                course: selectedCourse,
                assignment: newAssignment
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
