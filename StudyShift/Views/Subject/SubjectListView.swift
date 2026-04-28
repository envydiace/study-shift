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

    @Query(sort: \Subject.name) private var subjects: [Subject]

    @StateObject private var viewModel: SubjectListViewModel
    
    init() {
        _viewModel = StateObject(wrappedValue: SubjectListViewModel())
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(subjects) { subject in
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
                            viewModel.deleteSubject(subject, context: context)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
            .navigationTitle("Subjects")
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
                SubjectFormView()
            }
            .sheet(isPresented: $viewModel.showImportTimetableView) {
                TimetableImportView()
            }
        }
    }
}

#Preview {
    SubjectListView()
        .modelContainer(for: Subject.self, inMemory: true)
}
