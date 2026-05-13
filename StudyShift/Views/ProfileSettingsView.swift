//
//  ProfileSettingsView.swift
//  StudyShift
//
//  Created by Đức Anh on 30/4/26.
//

import SwiftUI
import SwiftData

struct ProfileSettingsView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var profile: StudentProfile? = nil
    @State private var showEditSheet: Bool = false

    // Editable fields
    @State private var editName: String = ""
    @State private var editDegree: String = ""
    @State private var editUniversity: String = ""
    @State private var editVisaType: String = "Sub Class 500"
    @State private var editWorkLimit: Double = 48
    @State private var editSemester: String = "3rd"

    private let visaOptions = ["Sub Class 500", "Sub Class 485", "Sub Class 600"]
    private let semesterOptions = ["1st", "2nd", "3rd", "Summer"]

    var body: some View {
        ZStack {
            Color.tealMain
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    headerBar
                    profileCard
                    infoSection
                    settingsSection
                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 20)
                .padding(.top, 55)
                .padding(.bottom, 40)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .sheet(isPresented: $showEditSheet) {
            editSheet
        }
        .task {
            loadProfile()
        }
    }

    // MARK: - Header

    private var headerBar: some View {
        HStack {
            Text("Profile")
                .font(.title2.bold())
                .foregroundStyle(.black)

            Spacer()

            Image(systemName: "bell")
                .foregroundStyle(.black)
                .padding(8)
                .background(Color.white)
                .clipShape(Circle())
        }
    }

    // MARK: - Profile Card

    private var profileCard: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(Color.black.opacity(0.08))
                    .frame(width: 56, height: 56)

                Image(systemName: "person.circle.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(Color.black.opacity(0.4))
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(editName.isEmpty ? "Your Name" : editName)
                    .font(.subheadline.bold())
                    .foregroundStyle(.black)

                let degreeText = [editDegree, editUniversity]
                    .filter { !$0.isEmpty }
                    .joined(separator: " - ")

                Text(degreeText.isEmpty ? "Degree - University" : degreeText)
                    .font(.caption)
                    .foregroundStyle(.black.opacity(0.6))
            }

            Spacer()
        }
        .padding(16)
        .background(Color.surfaceCard)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    // MARK: - Info Section

    private var infoSection: some View {
        VStack(spacing: 1) {
            infoRow(label: "VISA Type") {
                Text(editVisaType)
                    .font(.caption.bold())
                    .foregroundStyle(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 5)
                    .background(Color.tealDark)
                    .clipShape(Capsule())
            }

            Divider()
                .padding(.horizontal, 16)

            infoRow(label: "Work Limit") {
                Text("\(Int(editWorkLimit)) h")
                    .font(.subheadline.bold())
                    .foregroundStyle(.black)
            }

            Divider()
                .padding(.horizontal, 16)

            infoRow(label: "Current Semester") {
                Text(editSemester)
                    .font(.subheadline.bold())
                    .foregroundStyle(.black)
            }
        }
        .background(Color.surfaceCard)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func infoRow<Content: View>(label: String, @ViewBuilder trailing: () -> Content) -> some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.black)
            Spacer()
            trailing()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }

    // MARK: - Settings Section

    private var settingsSection: some View {
        VStack(spacing: 1) {
            settingsRow(icon: "bell", label: "Notifications")
            Divider().padding(.horizontal, 16)
            settingsRow(icon: "questionmark.circle", label: "Help & Support")
            Divider().padding(.horizontal, 16)

            Button {
                showEditSheet = true
            } label: {
                HStack {
                    Image(systemName: "pencil")
                        .frame(width: 24)
                        .foregroundStyle(Color.tealDark)
                    Text("Edit Profile")
                        .font(.subheadline)
                        .foregroundStyle(.black)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundStyle(.black.opacity(0.3))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
            }
        }
        .background(Color.surfaceCard)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func settingsRow(icon: String, label: String) -> some View {
        HStack {
            Image(systemName: icon)
                .frame(width: 24)
                .foregroundStyle(Color.tealDark)
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.black)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.black.opacity(0.3))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }

    // MARK: - Edit Sheet

    private var editSheet: some View {
        NavigationStack {
            Form {
                Section("Personal Info") {
                    TextField("Full Name", text: $editName)
                    TextField("Degree (e.g. Master of IT)", text: $editDegree)
                    TextField("University (e.g. UTS)", text: $editUniversity)
                }

                Section("Visa & Work") {
                    Picker("VISA Type", selection: $editVisaType) {
                        ForEach(visaOptions, id: \.self) { option in
                            Text(option).tag(option)
                        }
                    }

                    HStack {
                        Text("Work Limit")
                        Spacer()
                        Text("\(Int(editWorkLimit)) h")
                            .foregroundStyle(.secondary)
                    }
                    Slider(value: $editWorkLimit, in: 20...48, step: 1)
                }

                Section("Academic") {
                    Picker("Current Semester", selection: $editSemester) {
                        ForEach(semesterOptions, id: \.self) { option in
                            Text(option).tag(option)
                        }
                    }
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        showEditSheet = false
                        loadProfile()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        saveProfile()
                        showEditSheet = false
                    }
                    .bold()
                }
            }
        }
    }

    // MARK: - Data

    private func loadProfile() {
        let repo = StudentProfileRepository(context: context)
        if let existing = try? repo.fetchFirst() {
            profile = existing
            editName = existing.name
            editVisaType = existing.visaType
            editWorkLimit = existing.workHourLimitPerFortnight
        }
    }

    private func saveProfile() {
        let repo = StudentProfileRepository(context: context)

        if let existing = profile {
            existing.name = editName
            existing.visaType = editVisaType
            existing.workHourLimitPerFortnight = editWorkLimit
        } else {
            let newProfile = StudentProfile(
                name: editName,
                visaType: editVisaType,
                workHourLimitPerFortnight: editWorkLimit
            )
            context.insert(newProfile)
            profile = newProfile
        }

        try? context.save()
    }
}

#Preview {
    ProfileSettingsView()
        .modelContainer(ModelContainerFactory.createPreviewContainer())
}
