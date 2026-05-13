//
//  TimetableImportView.swift
//  StudyShift
//
//  Created by Đức Anh on 26/4/26.
//
import SwiftUI
import SwiftData

struct TimetableImportView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    let onImported: (() -> Void)?

    @StateObject private var viewModel: TimetableImportViewModel

    init(onImported: (() -> Void)? = nil) {
        self.onImported = onImported
        _viewModel = StateObject(wrappedValue: TimetableImportViewModel())
    }

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 22) {
                    headerSection

                    importCard

                    messageSection

                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .padding(.bottom, 40)
            }
            .background(Color.tealMain.ignoresSafeArea())
            .navigationTitle("Import Timetable")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                viewModel.configure(context: context)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.tealDark)
                }
            }
        }
    }
}

// MARK: - Sections

private extension TimetableImportView {
    var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Import Schedule")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.primary)

            Text("Paste your university timetable subscription URL. The app will import class sessions into your local schedule.")
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.black.opacity(0.60))
        }
    }

    var importCard: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("Timetable URL")
                .font(.headline)
                .foregroundColor(.primary)

            TextField("Paste iCal URL here", text: $viewModel.urlText)
                .font(.system(size: 16))
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .textInputAutocapitalization(.never)
                .keyboardType(.URL)
                .autocorrectionDisabled()

            Text("The selected color will be used as the default color for imported classes.")
                .font(.caption)
                .foregroundStyle(.secondary)

            EventColorPickerSection(
                title: "Default class color",
                selectedColorHex: $viewModel.selectedColorHex,
                isShowingDropdown: $viewModel.isShowingColorDropdown
            )

            importButton
        }
        .padding(20)
        .background(Color.white.opacity(0.95))
        .clipShape(RoundedRectangle(cornerRadius: 28))
    }

    var importButton: some View {
        Button {
            Task {
                await viewModel.importTimetable()

                if !viewModel.successMessage.isEmpty {
                    onImported?()
                }
            }
        } label: {
            HStack(spacing: 10) {
                if viewModel.isImporting {
                    ProgressView()
                        .tint(.white)

                    Text("Importing...")
                } else {
                    Image(systemName: "square.and.arrow.down")
                    Text("Import Schedule")
                }
            }
            .font(.system(size: 18, weight: .bold))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                Capsule()
                    .fill(viewModel.canImport ? Color.tealDark : Color.gray.opacity(0.55))
            )
        }
        .disabled(!viewModel.canImport || viewModel.isImporting)
    }

    @ViewBuilder
    var messageSection: some View {
        if !viewModel.errorMessage.isEmpty {
            statusCard(
                icon: "exclamationmark.triangle.fill",
                message: viewModel.errorMessage,
                color: .red,
                background: Color.red.opacity(0.12)
            )
        }

        if !viewModel.successMessage.isEmpty {
            VStack(spacing: 14) {
                statusCard(
                    icon: "checkmark.circle.fill",
                    message: viewModel.successMessage,
                    color: .green,
                    background: Color.green.opacity(0.14)
                )

                Button {
                    dismiss()
                } label: {
                    Text("Done")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            Capsule()
                                .fill(Color.tealDark)
                        )
                }
            }
        }
    }

    func statusCard(
        icon: String,
        message: String,
        color: Color,
        background: Color
    ) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.system(size: 18, weight: .semibold))

            Text(message)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)

            Spacer()
        }
        .padding(16)
        .background(Color.white.opacity(0.95))
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .fill(background)
        )
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}

// MARK: - Preview

#Preview {
    TimetableImportView()
        .modelContainer(ModelContainerFactory.createPreviewContainer())
}
