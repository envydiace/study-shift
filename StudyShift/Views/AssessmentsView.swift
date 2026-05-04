//
//  AssessmentsView.swift
//  StudyShift
//
//  Created by Đức Anh on 30/4/26.
//

import SwiftUI

struct AssessmentsView: View {
    var body: some View {
        /// TODO: implement Assessments Screen
        /// edited the target device for debugging.
        
        ZStack {
            Color.tealMain
                        .ignoresSafeArea()

                    VStack(spacing: 0) {
                        mainContent
                            .padding(.vertical, 4)
                        bottomTabBar
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.tealMain)
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                    
                    
                }
    }
}

var mainContent: some View {
    VStack(alignment: .leading, spacing: 20) {
        header

        assessmentCard(
            course: "42904 Cloud Computing",
            target: "HD",
            title: "Assessment 2",
            progress: 0.65,
            status: "Urgent",
            statusColor: .redMain,
            due: "Due Tomorrow"
        )

        assessmentCard(
            course: "32541 Project Management",
            target: "D",
            title: "Assessment 1",
            progress: 0.42,
            status: "Soon",
            statusColor: .yellowMain,
            due: "Due in 3 days"
        )

        Spacer()

        VStack(spacing: 14) {
            Button("+ Add Assessment") {}
                .buttonStyle(PillButtonStyle())

            Button("View Course List") {}
                .buttonStyle(PillButtonStyle())
        }
        .frame(maxWidth: .infinity)

        Spacer()
    }
    .padding(.horizontal, 24)
    .padding(.top, 55)
}

var header: some View {
    HStack {
        VStack(alignment: .leading, spacing: 2) {
            Text("Assessments")
                .navigationTitle("Assessments")
                .font(.headline.bold())

            //can change to what semester student's at
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

func assessmentCard(
    course: String,
    target: String,
    title: String,
    progress: Double,
    status: String,
    statusColor: Color,
    due: String
) -> some View {
    VStack(alignment: .leading, spacing: 12) {
        HStack {
            Image(systemName: "book.closed.fill")
                .padding(8)
                .background(.tealMain)
                .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 2) {
                Text(course)
                    .font(.caption.bold())

                Text("Target: \(target)")
                    .font(.caption2)
                    .foregroundStyle(.gray)
            }

            Spacer()

            Text(target)
                .font(.caption.bold())
                .padding(.horizontal, 18)
                .padding(.vertical, 8)
                .background(.tealMain)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }

        HStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption.bold())

                ProgressView(value: progress)
                    .tint(.purpleMain)

                Text("Need 70% more")
                    .font(.caption2)
                    .foregroundStyle(.gray)
            }

            Spacer()

            VStack(spacing: 4) {
                Text(status)
                    .font(.caption2.bold())
                    .padding(.horizontal, 14)
                    .padding(.vertical, 6)
                    .background(statusColor)
                    .clipShape(Capsule())

                Text(due)
                    .font(.caption2)
                    .foregroundStyle(.gray)
            }
        }
    }
    .padding(12)
    .background(Color(red: 0.88, green: 0.94, blue: 0.98))
    .clipShape(RoundedRectangle(cornerRadius: 14))
}

var bottomTabBar: some View {
    HStack(spacing: 40) {
        Image(systemName: "house")
        Image(systemName: "calendar")
        Image(systemName: "doc.text.fill")
            .padding(14)
            .background(.tealMain)
            .clipShape(Circle())
        Image(systemName: "briefcase.fill")
        Image(systemName: "person")
    }
    .font(.title3)
    .padding(.top, 16)
    .padding(.bottom, 24)
    .frame(maxWidth: .infinity)
    .background(Color(red: 0.86, green: 0.98, blue: 0.88))
    .clipShape(
        UnevenRoundedRectangle(
            topLeadingRadius: 32,
            topTrailingRadius: 32
        )
    )
}


struct PillButtonStyle: ButtonStyle {
func makeBody(configuration: Configuration) -> some View {
    configuration.label
        .font(.headline.bold())
        .foregroundStyle(.tealMain)
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
        .background(.tealDark)
        .clipShape(Capsule())
        .scaleEffect(configuration.isPressed ? 0.96 : 1)
}
}

#Preview {
    AssessmentsView()
}
