//
//  Untitled.swift
//  StudyShift
//
//  Created by Chelvin Alexyus on 12/5/2026.
//
import SwiftUI
import SwiftData

struct CourseListView: View {
    @Query(sort: \Subject.name) private var subjects: [Subject]

    var body: some View {
        ZStack {
            Color.tealMain
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 18) {
                    header

                    if subjects.isEmpty {
                        emptyState
                    } else {
                        ForEach(subjects) { subject in
                            CourseCardView(subject: subject)
                        }
                    }
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
            VStack(alignment: .leading, spacing: 4) {
                Text("Course List")
                    .font(.title3.bold())

                Text("Semester 3 | 2026")
                    .font(.caption)
            }

            Spacer()

            Image(systemName: "bell")
                .foregroundStyle(.black)
                .padding(8)
                .background(Color.white)
                .clipShape(Circle())
        }
        .foregroundStyle(.black)
    }

    private var emptyState: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("No courses yet")
                .font(.headline)

            Text("Import your timetable or add a subject to populate this list.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.surfaceCard)
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}

private struct CourseCardView: View {
    let subject: Subject

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("\(subject.code) \(subject.name)")
                .font(.headline)

            HStack {
                Text("Target: \(subject.targetGrade.rawValue)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Spacer()

                Circle()
                    .fill(Color(hex: subject.colorHex))
                    .frame(width: 14, height: 14)
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.surfaceCard)
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color(hex: subject.colorHex).opacity(0.45), lineWidth: 2)
        )
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}

#Preview {
    CourseListView()
}

