//
//  SubjectFormView.swift
//  StudyShift
//
//  Created by Đức Anh on 26/4/26.
//
import SwiftUI
import SwiftData

struct SubjectFormView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @StateObject private var viewModel: SubjectFormViewModel

    init() {
        _viewModel = StateObject(wrappedValue: SubjectFormViewModel())
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Subject Information") {
                    TextField("Subject name", text: $viewModel.name)

                    TextField("Subject code", text: $viewModel.code)
                        .textInputAutocapitalization(.characters)
                }

                Section("Target Grade") {
                    Picker("Target Grade", selection: $viewModel.targetGrade) {
                        ForEach(GradeTarget.allCases, id: \.self) { grade in
                            Text(grade.rawValue)
                                .tag(grade)
                        }
                    }
                }

                Section("Color") {
                    Picker("Subject Color", selection: $viewModel.colorHex) {
                        ForEach(viewModel.colorOptions, id: \.self) { color in
                            HStack {
                                Circle()
                                    .fill(Color(hex: color))
                                    .frame(width: 20, height: 20)

                                Text(color)
                            }
                            .tag(color)
                        }
                    }
                }

                if viewModel.showValidationError {
                    Section {
                        Text(viewModel.validationMessage)
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle("Add Subject")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        let success = viewModel.saveSubject(context: context)

                        if success {
                            dismiss()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    SubjectFormView()
}
