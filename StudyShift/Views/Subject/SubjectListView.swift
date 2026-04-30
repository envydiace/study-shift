//
//  SubjectListView.swift
//  StudyShift
//
//  Created by Đức Anh on 26/4/26.
//

import SwiftUI
import SwiftData

struct SubjectListView: View {
    @Environment(\.modelContext) private var context

    @StateObject private var viewModel: SubjectListViewModel
    
    init() {
        _viewModel = StateObject(wrappedValue: SubjectListViewModel())
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.subjects) { subject in
                    Button {
                        viewModel.printSubject(subject)
                    } label: {
                        HStack {
                            Circle()
                                .fill(Color(hex: subject.colorHex))
                                .frame(width: 14, height: 14)

                            VStack(alignment: .leading) {
                                Text(subject.name)
                                    .font(.headline)

                                Text(subject.code)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()

                            Text(subject.targetGrade.rawValue)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .buttonStyle(.plain)
                    .swipeActions {
                        Button(role: .destructive) {
                            viewModel.deleteSubject(subject)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
            .navigationTitle("Subjects")
            .overlay {
                if viewModel.subjects.isEmpty {
                    ContentUnavailableView(
                        "No Subjects Yet",
                        systemImage: "books.vertical",
                        description: Text("Add a subject or import your timetable to get started.")
                    )
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        viewModel.showImportTimetableView = true
                    } label: {
                        Image(systemName: "calendar.badge.plus")
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.showAddSubjectForm = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $viewModel.showAddSubjectForm) {
                SubjectFormView {
                    viewModel.loadSubjects()
                }
            }
            .sheet(isPresented: $viewModel.showImportTimetableView) {
                TimetableImportView {
                    viewModel.loadSubjects()
                }
            }
            .task {
                viewModel.configure(context: context)
                viewModel.loadSubjects()
            }
            .refreshable {
                viewModel.loadSubjects()
            }
            .alert("Error", isPresented: errorBinding) {
                Button("OK", role: .cancel) {
                    viewModel.errorMessage = ""
                }
            } message: {
                Text(viewModel.errorMessage)
            }
        }
    }

    private var errorBinding: Binding<Bool> {
        Binding(
            get: { !viewModel.errorMessage.isEmpty },
            set: { isPresented in
                if !isPresented {
                    viewModel.errorMessage = ""
                }
            }
        )
    }
}

#Preview {
    SubjectListView()
        .modelContainer(subjectListPreviewContainer)
}

private var subjectListPreviewContainer: ModelContainer {
    let schema = Schema([
        Subject.self,
        ClassSession.self,
        Assessment.self,
        TodoTask.self
    ])
    let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)

    do {
        return try ModelContainer(for: schema, configurations: [configuration])
    } catch {
        fatalError("Failed to create preview container: \(error)")
    }
}
