//
//  AddCourseView.swift
//  StudyShift
//
//  Created by Đức Anh on 26/4/26.
//
import SwiftUI
import SwiftData

struct AddCourseView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    let courseToEdit: Course?
    let onSaved: (() -> Void)?

    @StateObject private var viewModel: AddCourseViewModel

    init(
        courseToEdit: Course? = nil,
        onSaved: (() -> Void)? = nil
    ) {
        self.courseToEdit = courseToEdit
        self.onSaved = onSaved
        _viewModel = StateObject(
            wrappedValue: AddCourseViewModel(courseToEdit: courseToEdit)
        )
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.tealMain
                    .ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 22) {
                        headerSection
                        formCard
                        saveButton
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 24)
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle(courseToEdit == nil ? "Add Course" : "Edit Course")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundStyle(.tealDark)
                }
            }
            .task {
                viewModel.configure(context: context)
            }
        }
    }
    
    var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(courseToEdit == nil ? "Create Course" : "Edit Course")
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(.black)

            Text(courseToEdit == nil ? "Add course details, target grade, and a display color for your assignments." : "Edit course details")
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(.black.opacity(0.6))
        }
    }

    var formCard: some View {
        VStack(alignment: .leading, spacing: 18) {
            inputSection(title: "Course Name") {
                TextField("Course name", text: $viewModel.name)
                    .inputStyle()
            }

            inputSection(title: "Course Code") {
                TextField("Course code", text: $viewModel.code)
                    .textInputAutocapitalization(.characters)
                    .inputStyle()
            }

            inputSection(title: "Target Grade") {
                Picker("Target Grade", selection: $viewModel.targetGrade) {
                    ForEach(GradeTarget.allCases, id: \.self) { grade in
                        Text(grade.rawValue)
                            .tag(grade)
                    }
                }
                .pickerStyle(.segmented)
            }

            EventColorPickerSection(
                title: "Color",
                selectedColorHex: $viewModel.colorHex,
                isShowingDropdown: $viewModel.isShowingColorDropdown
            )

            if viewModel.showValidationError {
                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(.red)

                    Text(viewModel.validationMessage)
                        .font(.caption)
                        .foregroundStyle(.red)
                }
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.red.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }
        }
        .padding(20)
        .background(Color.surfaceCard)
        .clipShape(RoundedRectangle(cornerRadius: 28))
    }

    var saveButton: some View {
        Button {
            let success = viewModel.saveCourse()

            if success {
                onSaved?()
                dismiss()
            }
        } label: {
            Text("Save Course")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.tealDark)
                .clipShape(Capsule())
        }
    }

    func inputSection<Content: View>(
        title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundStyle(.black)

            content()
        }
    }
}

private extension View {
    func inputStyle() -> some View {
        self
            .padding()
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    AddCourseView()
}
