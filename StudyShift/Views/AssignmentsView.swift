//
//  AssessmentsView.swift
//  StudyShift
//
//  Created by Đức Anh on 30/4/26.
//

import SwiftUI
import SwiftData

struct AssignmentsView: View {
    @Query(sort: \Assessment.dueDate)
    private var assignments: [Assessment]

    var body: some View {
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
                                AssignmentDetailView(assessment: assignment)
                            } label: {
                                AssignmentCardView(assessment: assignment)
                            }
                            .buttonStyle(.plain)
                        }
                    }

                    VStack(spacing: 14) {
                        NavigationLink {
                            AddAssignmentView()
                        } label: {
                            Text("+ Add Assignment")
                        }
                        .buttonStyle(PillButtonStyle())

                        NavigationLink {
                            CourseListView()
                        } label: {
                            Text("View Course List")
                        }
                        .buttonStyle(PillButtonStyle())
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 16)
                }
                .padding(.horizontal, 24)
                .padding(.top, 55)
                .padding(.bottom, 40)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("Assignments")
                    .font(.headline.bold())

                Text("Semester 3 | 2026")
                    .font(.caption)
            }

            Spacer()

            Image(systemName: "bell")
                .padding(6)
                .background(.white)
                .clipShape(Circle())
        }
        .foregroundStyle(.black)
        .padding(.bottom, 12)
    }

    private var emptyState: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("No assignments yet")
                .font(.headline)

            Text("Add an assignment to start tracking your assessments.")
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
}
