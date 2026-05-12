//
//  CourseListView.swift
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
                ForEach(viewModel.courses) { course in
                    Button {
                        viewModel.printCourse(course)
                    } label: {
                        HStack {
                            Circle()
                                .fill(Color(hex: course.colorHex))
                                .frame(width: 14, height: 14)

                            VStack(alignment: .leading) {
                                Text(course.name)
                                    .font(.headline)

                                Text(course.code)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()

                            Text(course.targetGrade.rawValue)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .buttonStyle(.plain)
                    .swipeActions {
                        Button(role: .destructive) {
                            viewModel.deleteCourse(course)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
            .navigationTitle("Courses")
            .overlay {
                if viewModel.courses.isEmpty {
                    ContentUnavailableView(
                        "No Courses Yet",
                        systemImage: "books.vertical",
                        description: Text("Add a course or import your timetable to get started.")
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
                        viewModel.showAddCourseForm = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $viewModel.showAddCourseForm) {
                AddCourseView {
                    viewModel.loadCourses()
                }
            }
            .sheet(isPresented: $viewModel.showImportTimetableView) {
                TimetableImportView {
                    viewModel.loadCourses()
                }
            }
            .task {
                viewModel.configure(context: context)
                viewModel.loadCourses()
            }
            .refreshable {
                viewModel.loadCourses()
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
        .modelContainer(courseListPreviewContainer)
}

private var courseListPreviewContainer: ModelContainer {
    let schema = Schema([
        Course.self,
        ClassSession.self,
        Assignment.self,
        TodoTask.self
    ])
    let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)

    do {
        return try ModelContainer(for: schema, configurations: [configuration])
    } catch {
        fatalError("Failed to create preview container: \(error)")
    }
}
