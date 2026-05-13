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
    @State private var date: Date = Date()
    @State private var startTime: Date = Date()
    @State private var numberOfHours: String = ""
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

                    fieldSection("Date") {
                        DatePicker("", selection: $date, displayedComponents: .date)
                            .labelsHidden()
                    }

                    fieldSection("Time") {
                        DatePicker("", selection: $startTime, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                    }

                    fieldSection("Number of Hours") {
                        TextField("8 hrs", text: $numberOfHours)
                            .keyboardType(.decimalPad)
                    }

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

    private func saveShift() {
        let trimmedEmployer = employer.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedEmployer.isEmpty else {
            errorMessage = "Please enter an employer name."
            showError = true
            return
        }

        guard let hours = Double(numberOfHours), hours > 0 else {
            errorMessage = "Please enter a valid number of hours."
            showError = true
            return
        }

        // Combine date + time into startTime, calculate endTime from hours
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute], from: startTime)

        var combined = DateComponents()
        combined.year = dateComponents.year
        combined.month = dateComponents.month
        combined.day = dateComponents.day
        combined.hour = timeComponents.hour
        combined.minute = timeComponents.minute

        guard let finalStart = calendar.date(from: combined) else {
            errorMessage = "Invalid date/time."
            showError = true
            return
        }

        let finalEnd = finalStart.addingTimeInterval(hours * 3600)

        let shift = WorkShift(
            title: trimmedEmployer,
            workplace: trimmedEmployer,
            startTime: finalStart,
            endTime: finalEnd
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
