//
//  AddEventScreen.swift
//  StudyShift
//
//  Created by Đức Anh on 6/5/26.
//

import SwiftUI

struct AddEventScreen: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: AddEventViewModel

    init() {
        _viewModel = StateObject(wrappedValue: AddEventViewModel())
    }
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    titleSection

                    dateSection
//
                    eventTypeSection
//
                    dynamicFieldsSection

                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .font(.footnote)
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    saveButton
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Add Event")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }

    private var titleSection: some View {
        sectionCard {
            TextField("Add title", text: $viewModel.title)
                .font(.title3)
                .padding(.horizontal, 1)
                .padding(.vertical, 1)
                .autocorrectionDisabled(true)
                .background(Color(.systemBackground))
                
        }
    }

    private var dateSection: some View {
        sectionCard {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Date & Time")
                        .font(.headline)

                    Spacer()

                    if viewModel.requiresStartAndEndDate {
                        Text("Required")
                            .font(.caption)
                            .foregroundColor(.red)
                    } else {
                        Text("Optional")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }

                Toggle(
                    "Add start date",
                    isOn: Binding(
                        get: {
                            viewModel.startDate != nil
                        },
                        set: { isOn in
                            viewModel.startDate = isOn ? Date() : nil
                            viewModel.updateEndDateIfNeeded()
                        }
                    )
                )
                .disabled(viewModel.requiresStartAndEndDate)

                if viewModel.startDate != nil {
                    DatePicker(
                        "Start",
                        selection: Binding(
                            get: {
                                viewModel.startDate ?? Date()
                            },
                            set: { newValue in
                                viewModel.startDate = newValue
                                viewModel.updateEndDateIfNeeded()
                            }
                        ),
                        displayedComponents: [.date, .hourAndMinute]
                    )
                }

                Divider()

                Toggle(
                    "Add end date",
                    isOn: Binding(
                        get: {
                            viewModel.endDate != nil
                        },
                        set: { isOn in
                            viewModel.endDate = isOn
                                ? Calendar.current.date(
                                    byAdding: .hour,
                                    value: 1,
                                    to: viewModel.startDate ?? Date()
                                )
                                : nil
                        }
                    )
                )
                .disabled(viewModel.requiresStartAndEndDate)

                if viewModel.endDate != nil {
                    DatePicker(
                        "End",
                        selection: Binding(
                            get: {
                                viewModel.endDate ?? Date()
                            },
                            set: { newValue in
                                viewModel.endDate = newValue
                            }
                        ),
                        displayedComponents: [.date, .hourAndMinute]
                    )
                }
            }
        }
    }

    private var eventTypeSection: some View {
        sectionCard {
            HStack(spacing: 12) {
                Text("Event Type")
                    .font(.headline)
                Spacer()
                Picker("Event Type", selection: $viewModel.eventType) {
                    ForEach(EventType.allCases, id: \.self) { type in
                        Label(type.rawValue, systemImage: type.iconName)
                            .tag(type)
                    }
                }
                .pickerStyle(.menu)
                .onChange(of: viewModel.eventType) { _, _ in
                    viewModel.eventTypeChanged()
                }
            }
        }
    }

    @ViewBuilder
    private var dynamicFieldsSection: some View {
        switch viewModel.eventType {
        case .personal:
            personalFields

        case .classSession:
            classFields

        case .assessment:
            assessmentFields

        case .studyTask:
            studyTaskFields

        case .workShift:
            workShiftFields
        }
    }

    private var personalFields: some View {
        sectionCard {
            VStack(alignment: .leading, spacing: 12) {
                Text("Personal Details")
                    .font(.headline)

                TextField("Location optional", text: $viewModel.location)
                    .inputStyle()

                TextField("Notes optional", text: $viewModel.notes, axis: .vertical)
                    .lineLimit(3...6)
                    .inputStyle()
            }
        }
    }

    private var classFields: some View {
        sectionCard {
            VStack(alignment: .leading, spacing: 12) {
                Text("Class Details")
                    .font(.headline)

                TextField("Subject name optional", text: $viewModel.subjectName)
                    .inputStyle()

                TextField("Location optional", text: $viewModel.location)
                    .inputStyle()

                Toggle("Repeat weekly", isOn: $viewModel.repeatWeekly)

                TextField("Notes optional", text: $viewModel.notes, axis: .vertical)
                    .lineLimit(3...6)
                    .inputStyle()
            }
        }
    }

    private var assessmentFields: some View {
        sectionCard {
            VStack(alignment: .leading, spacing: 12) {
                Text("Assessment Details")
                    .font(.headline)

                Picker("Assessment Type", selection: $viewModel.assessmentType) {
                    ForEach(viewModel.assessmentTypes, id: \.self) { type in
                        Text(type).tag(type)
                    }
                }

                TextField("Subject optional", text: $viewModel.subjectName)
                    .inputStyle()

                TextField("Weight (%) optional", text: $viewModel.weight)
                    .keyboardType(.decimalPad)
                    .inputStyle()

                TextField("Total mark optional", text: $viewModel.totalMark)
                    .keyboardType(.decimalPad)
                    .inputStyle()

                TextField("Notes optional", text: $viewModel.notes, axis: .vertical)
                    .lineLimit(3...6)
                    .inputStyle()
            }
        }
    }

    private var studyTaskFields: some View {
        sectionCard {
            VStack(alignment: .leading, spacing: 12) {
                Text("Study Task Details")
                    .font(.headline)

                TextField("Linked assessment optional", text: $viewModel.linkedAssessment)
                    .inputStyle()

                TextField("Subject optional", text: $viewModel.subjectName)
                    .inputStyle()

                Toggle("Completed", isOn: $viewModel.isCompleted)

                TextField("Notes optional", text: $viewModel.notes, axis: .vertical)
                    .lineLimit(3...6)
                    .inputStyle()
            }
        }
    }

    private var workShiftFields: some View {
        sectionCard {
            VStack(alignment: .leading, spacing: 12) {
                Text("Work Shift Details")
                    .font(.headline)

                TextField("Workplace optional", text: $viewModel.workplace)
                    .inputStyle()

                TextField("Location optional", text: $viewModel.location)
                    .inputStyle()

                if let durationText {
                    Text("Duration: \(durationText)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                TextField("Notes optional", text: $viewModel.notes, axis: .vertical)
                    .lineLimit(3...6)
                    .inputStyle()
            }
        }
    }

    private var saveButton: some View {
        Button {
            viewModel.save()

            if viewModel.errorMessage == nil {
                dismiss()
            }
        } label: {
            Text(viewModel.saveButtonTitle)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(viewModel.isValid ? Color.blue : Color.gray)
                .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .disabled(!viewModel.isValid)
    }

    private var durationText: String? {
        guard let startDate = viewModel.startDate,
              let endDate = viewModel.endDate,
              endDate >= startDate
        else {
            return nil
        }

        let duration = endDate.timeIntervalSince(startDate)
        let hours = Int(duration / 3600)
        let minutes = Int((duration.truncatingRemainder(dividingBy: 3600)) / 60)

        if hours == 0 {
            return "\(minutes)m"
        }

        if minutes == 0 {
            return "\(hours)h"
        }

        return "\(hours)h \(minutes)m"
    }

    private func requiredLabel(_ text: String) -> some View {
        HStack(spacing: 4) {
            Text(text)
                .font(.caption)
                .foregroundColor(.secondary)

            Text("*")
                .font(.caption)
                .foregroundColor(.red)
        }
    }

    private func sectionCard<Content: View>(
        @ViewBuilder content: () -> Content
    ) -> some View {
        content()
            .padding()
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 18))
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
    AddEventScreen()
}
