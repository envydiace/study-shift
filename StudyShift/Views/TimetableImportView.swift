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
            Form {
                Section("Timetable URL") {
                    TextField("Paste iCal URL here", text: $viewModel.urlText)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.URL)
                        .autocorrectionDisabled()

                    Text("Paste your university timetable subscription URL. The app will import class sessions into your local schedule.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Section {
                    Button {
                        Task {
                            await viewModel.importTimetable()
                            if !viewModel.successMessage.isEmpty {
                                onImported?()
                            }
                        }
                    } label: {
                        HStack {
                            Spacer()

                            if viewModel.isImporting {
                                ProgressView()
                                    .padding(.trailing, 6)

                                Text("Importing...")
                            } else {
                                Image(systemName: "square.and.arrow.down")
                                Text("Import Timetable")
                            }

                            Spacer()
                        }
                    }
                    .disabled(viewModel.isImporting || viewModel.urlText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }

                if !viewModel.errorMessage.isEmpty {
                    Section {
                        Text(viewModel.errorMessage)
                            .foregroundStyle(.red)
                    }
                }

                if !viewModel.successMessage.isEmpty {
                    Section {
                        Text(viewModel.successMessage)
                            .foregroundStyle(.green)
                    }

                    Section {
                        Button("Done") {
                            dismiss()
                        }
                    }
                }
            }
            .navigationTitle("Import Timetable")
            .task {
                viewModel.configure(context: context)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    TimetableImportView()
}
