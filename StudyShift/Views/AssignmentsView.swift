//
//  AssessmentsView.swift
//  StudyShift
//
//  Created by Đức Anh on 30/4/26.
//

import SwiftUI
import SwiftData

struct AssignmentsView: View {
    @Query(sort: \Assessment.dueDate) private var assessments: [Assessment]

    var body: some View {
        ZStack {
            Color.tealMain
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    header

                    if assessments.isEmpty {
                        Text("No assignments yet")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.surfaceCard)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    } else {
                        ForEach(assessments) { assessment in
                            assignmentCard(for: assessment)
                        }
                    }

                    NavigationLink {
                        AddAssignmentView()
                    } label: {
                        Text("+ Add Assignment")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(PillButtonStyle())

                    NavigationLink {
                        CourseListView()
                    } label: {
                        Text("View Course List")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(PillButtonStyle())
                }
                .padding(.horizontal, 24)
                .padding(.top, 24)
                .padding(.bottom, 40)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Assignments")
                    .font(.title3.bold())

                Text("Semester 3 | 2026")
                    .font(.caption)
            }

            Spacer()

            Image(systemName: "bell")
                .padding(8)
                .background(.white)
                .clipShape(Circle())
        }
        .foregroundStyle(.black)
    }

    private func assignmentCard(for assessment: Assessment) -> some View {
        let daysLeft = Calendar.current.dateComponents([.day], from: .now, to: assessment.dueDate).day ?? 0
        let statusText = daysLeft <= 1 ? "Urgent" : (daysLeft <= 3 ? "Soon" : "On Track")
        let statusColor: Color = daysLeft <= 1 ? .redMain : (daysLeft <= 3 ? .yellowMain : .tealMain.opacity(0.35))
        let dueText = daysLeft <= 0 ? "Due Today" : (daysLeft == 1 ? "Due Tomorrow" : "Due in \(daysLeft) days")

        let progressValue: Double = assessment.tasks.isEmpty
            ? 0.15
            : Double(assessment.tasks.filter(\.isCompleted).count) / Double(assessment.tasks.count)

        return VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "book.closed.fill")
                    .padding(8)
                    .background(.tealMain)
                    .clipShape(RoundedRectangle(cornerRadius: 8))

                VStack(alignment: .leading, spacing: 2) {
                    Text(assessment.subject?.name ?? "No Course")
                        .font(.caption.bold())

                    Text("Target: \(assessment.subject?.targetGrade.rawValue ?? "--")")
                        .font(.caption2)
                        .foregroundStyle(.gray)
                }

                Spacer()

                Text(assessment.subject?.targetGrade.rawValue ?? "--")
                    .font(.caption.bold())
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(.tealMain)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }

            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(assessment.title)
                        .font(.subheadline.bold())

                    ProgressView(value: progressValue)
                        .tint(.purpleMain)

                    Text("Need \(Int((1 - progressValue) * 100))% more")
                        .font(.caption2)
                        .foregroundStyle(.gray)
                }

                Spacer()

                VStack(spacing: 4) {
                    Text(statusText)
                        .font(.caption2.bold())
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(statusColor)
                        .clipShape(Capsule())

                    Text(dueText)
                        .font(.caption2)
                        .foregroundStyle(.gray)
                }
            }
        }
        .padding(14)
        .background(Color.surfaceCard)
        .clipShape(RoundedRectangle(cornerRadius: 16))
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
