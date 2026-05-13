//
//  AddShiftView.swift
//  StudyShift
//
//  Created by M. A. Diganta on 13/5/2026.
//

import SwiftUI
import SwiftData

struct AddShiftView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    let onSaved: (() -> Void)?

    @State private var employer: String = ""
    @State private var startTime: Date = Date()
    @State private var endTime: Date = Calendar.current.date(byAdding: .hour, value: 1, to: Date()) ?? Date()
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""

    var body: some View {
        ZStack {
            Color.tealMain
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 18) {
                    header

                    fieldSection("Employer") {
                        TextField("ABC Store", text: $employer)
                    }

                    fieldSection("Start Time") {
                        DatePicker("", selection: $startTime, displayedComponents: [.date, .hourAndMinute])
                            .labelsHidden()
                            .onChange(of: startTime) { _, newStart in
                                if endTime <= newStart {
                                    endTime = Calendar.current.date(byAdding: .hour, value: 1, to: newStart) ?? newStart
                                }
                            }
                    }

                    fieldSection("End Time") {
                        DatePicker("", selection: $endTime, in: startTime..., displayedComponents: [.date, .hourAndMinute])
                            .labelsHidden()
                    }

                    durationPreview

                    Button {
                        saveShift()
                    } label: {
                        Text("Add Shift")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.tealDark)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .padding(.top, 16)
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
    }

    // MARK: - Duration preview

    private var durationPreview: some View {
        let totalMinutes = max(0, Int(endTime.timeIntervalSince(startTime) / 60))
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60
        let label: String = {
            if totalMinutes == 0 { return "0 h" }
            if minutes == 0 { return "\(hours) h" }
            return "\(hours) h \(minutes) m"
        }()

        return HStack {
            Image(systemName: "clock")
                .foregroundStyle(.black.opacity(0.5))
            Text("Duration: \(label)")
                .font(.subheadline)
                .foregroundStyle(.black.opacity(0.7))
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.35))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - Header

    private var header: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.headline)
                    .foregroundStyle(.black)
                    .padding(10)
                    .background(Color.white)
                    .clipShape(Circle())
            }

            Spacer()

            Text("Add Shift")
                .font(.title3.bold())
                .foregroundStyle(.black)
        }
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

    // MARK: - Save

    private func saveShift() {
        let trimmedEmployer = employer.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedEmployer.isEmpty else {
            errorMessage = "Please enter an employer name."
            showError = true
            return
        }

        guard endTime > startTime else {
            errorMessage = "End time must be after start time."
            showError = true
            return
        }

        let shift = WorkShift(
            title: trimmedEmployer,
            workplace: trimmedEmployer,
            startTime: startTime,
            endTime: endTime
        )

        context.insert(shift)

        do {
            try context.save()
            onSaved?()
            dismiss()
        } catch {
            errorMessage = "Failed to save shift."
            showError = true
        }
    }
}

#Preview {
    AddShiftView(onSaved: nil)
        .modelContainer(ModelContainerFactory.createPreviewContainer())
}
