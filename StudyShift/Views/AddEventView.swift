//
//  AddEventScreen.swift
//  StudyShift
//
//  Created by Đức Anh on 6/5/26.
//

import SwiftUI
import SwiftData

struct AddEventView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: AddEventViewModel
    private let onSave: (() -> Void)?

    init(
        eventType: EventType = .personal,
        onSave: (() -> Void)? = nil
    ) {
        self.onSave = onSave
        _viewModel = StateObject(wrappedValue: AddEventViewModel(eventType: eventType))
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    titleSection
                    
                    dateSection

                    eventTypeSection

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
            .background(.tealMain)
            .navigationTitle("Add Event")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .task {
                viewModel.configure(context: context)
                viewModel.loadSubjects()
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
        }
    }

    private var dateSection: some View {
        sectionCard {
            VStack(alignment: .leading, spacing: 16) {
                
                DatePicker(
                    "Start Date",
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
                .font(.headline)
                
                Divider()
                
                DatePicker(
                    "End Date",
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
                .font(.headline)
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
                    ForEach(EventType.addEventTypes, id: \.self) { type in
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

        case .workShift:
            workShiftFields
            
        case .task:
            Text("Tasks are created from the Tasks screen.")
                .font(.footnote)
                .foregroundColor(.secondary)
        }
    }

    private var personalFields: some View {
        sectionCard {
            VStack() {

                TextField("Location (optional)", text: $viewModel.location)
                    .padding(.horizontal, 1)
                    .padding(.vertical, 1)
                    .autocorrectionDisabled(true)
                    
                Divider()
                
                TextField("Notes (optional)", text: $viewModel.notes, axis: .vertical)
                    .lineLimit(3...6)
                    .padding(.horizontal, 1)
                    .padding(.vertical, 1)
                    .autocorrectionDisabled(true)
                    
            }
        }
    }

    private var classFields: some View {
        sectionCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Subjects")
                        .font(.headline)
                    
                    Spacer()
                    
                    Picker("Subject", selection: $viewModel.subjectCode) {
                        Text("No subject")
                            .tag("")

                        ForEach(viewModel.subjects) { subject in
                            Divider()
                            Text("\(subject.code) - \(subject.name)")
                                .tag(subject.code)
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                Divider()

                TextField("Location (optional)", text: $viewModel.location)
                    .padding(.horizontal, 1)
                    .padding(.vertical, 1)
                    .autocorrectionDisabled(true)
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

            if viewModel.didSaveSuccessfully {
                onSave?()
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
    AddEventView(eventType: .classSession)
        .modelContainer(ModelContainerFactory.createPreviewContainer())
}
