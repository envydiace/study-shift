//
//  AssignmentsView.swift
//  StudyShift
//
//  Created by Đức Anh on 30/4/26.
//

import SwiftUI
import SwiftData

struct AssignmentsView: View {
    @Query(sort: \Assignment.dueDate)
    private var assignments: [Assignment]

    @State var isShowAddAssignment: Bool = false
    
    var body: some View {

        NavigationStack {
            ZStack {
                Color.tealMain
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        header
                        
                        if assignments.isEmpty {
                            emptyState
                        } else {
                            ForEach(assignments) { assignment in
                                NavigationLink {
                                    AssignmentDetailView(assignment: assignment)
                                } label: {
                                    AssignmentCardView(assignment: assignment)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        
                        
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 55)
                    .padding(.bottom, 40)
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            .sheet(isPresented: $isShowAddAssignment) {
                AddAssignmentView()
            }
        }
    }

    private var header1: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("Assignments")
                    .font(.title2.bold())
                    .foregroundStyle(.black)

//                Text("Semester 3 | 2026")
//                    .font(.caption)
            }

            Spacer()

//            Image(systemName: "bell")
//                .padding(6)
//                .background(.white)
//                .clipShape(Circle())
        }
        .foregroundStyle(.black)
        .padding(.bottom, 12)
    }
    
    private var header: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 2) {
                Text("Assignments")
                    .font(.title2.bold())
                    .foregroundStyle(.black)
                
//                Text("Semester 3 | 2026")
//                    .font(.caption)
            }

            Spacer()
            
//            Image(systemName: "bell")
//                .padding(6)
//                .background(.white)
//                .clipShape(Circle())

            HStack(spacing: 10) {
                NavigationLink {
                    CourseListView()
                } label: {
                    Image(systemName: "books.vertical.fill")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.tealDark)
                        .frame(width: 36, height: 36)
                        .background(Color.white.opacity(0.9))
                        .clipShape(Circle())
                }

                Button {
                    showAddAssignment()
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.tealDark)
                        .frame(width: 36, height: 36)
                        .background(Color.white.opacity(0.9))
                        .clipShape(Circle())
                }
            }
        }
        .foregroundStyle(.black)
        .padding(.bottom, 12)
    }
    
    private func showAddAssignment() {
        isShowAddAssignment = true;
    }
    
    private func hideAddAssignment() {
        isShowAddAssignment = false;
    }

    private var emptyState: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("No assignments yet")
                .font(.headline)

            Text("Add an assignment to start tracking your assignments.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.surfaceCard)
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}
struct PillButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline.bold())
            .foregroundStyle(.tealMain)
            .padding(.horizontal, 24)
            .padding(.vertical, 14)
            .background(.tealDark)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
    }
}


#Preview {
    AssignmentsView()
        .modelContainer(ModelContainerFactory.createPreviewContainer())
}
