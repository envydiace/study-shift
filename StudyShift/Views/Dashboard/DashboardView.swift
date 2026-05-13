//
//  DashboardView.swift
//  StudyShift
//
//  Created by Đức Anh on 30/4/26.
//

import SwiftUI

struct DashboardView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = DashboardViewModel()
    
    @Binding var selectedTab: MainTab

    private let screenBackground = Color.tealMain

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 18) {
                headerSection

                shiftSummaryCard

                sectionHeader(
                    title: "Assessments In Progress",
                    count: viewModel.assessments.count
                )

                assessmentSection

                sectionHeader(
                    title: "Upcoming Classes",
                    count: viewModel.upcomingClasses.count
                )

                classesSection

                sectionHeader(
                    title: "Upcoming Deadlines",
                    count: viewModel.upcomingDeadlines.count
                )

                deadlinesSection
            }
            .padding(.horizontal, 16)
            .padding(.top, 14)
            .padding(.bottom, 24)
        }
        .background(screenBackground.ignoresSafeArea())
        .task {
            viewModel.configure(context: modelContext)
            viewModel.loadShiftSummary()
            viewModel.loadUpcomingClasses()
        }
    }
    
    var headerSection: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 2) {
                Text(viewModel.greetingTitle)
                    .font(.system(size: 26, weight: .bold))

                Text(viewModel.greetingSubtitle)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.black.opacity(0.75))
            }

//            Spacer()

//            Button {
//                print("Notification tapped")
//            } label: {
//                ZStack {
//                    Circle()
//                        .fill(Color.white.opacity(0.9))
//                        .frame(width: 34, height: 34)
//
//                    Image(systemName: "bell")
//                        .font(.system(size: 16, weight: .medium))
//                        .foregroundColor(.black.opacity(0.8))
//                }
//            }
        }
    }

    var shiftSummaryCard: some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 14) {
                HStack(spacing: 6) {
                    Image(systemName: "triangle.fill")
                        .font(.system(size: 12))
                        .foregroundColor(.yellow)

                    Text(viewModel.remainingHoursText)
                        .font(.system(size: 20, weight: .semibold))
                }

                Text(viewModel.remainingHoursSubtitle)
                    .font(.system(size: 15))
                    .foregroundColor(.black.opacity(0.65))

                Button {
                    selectedTab = .work
                } label: {
                    Text("View Shift Log")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.black)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 10)
                        .background(
                            Capsule()
                                .fill(Color(red: 0.16, green: 0.90, blue: 0.64))
                        )
                }
            }

//            Spacer(minLength: 5)

            CircularHoursProgressView(
                progress: viewModel.workedProgress,
                centerText: viewModel.workedHoursText
            )
            .padding(.trailing, 8)
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 26)
                .fill(Color.white)
        )
    }

    var assessmentSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 14) {
                ForEach(viewModel.assessments) { item in
                    AssessmentCard(item: item)
                }
            }
            .padding(.trailing, 8)
        }
    }

    var classesSection: some View {
        VStack(spacing: 12) {
            ForEach(viewModel.upcomingClasses) { item in
                ClassRowCard(item: item)
            }
        }
    }

    var deadlinesSection: some View {
        VStack(spacing: 12) {
            ForEach(viewModel.upcomingDeadlines) { item in
                DeadlineRowCard(item: item)
            }
        }
    }

    func sectionHeader(title: String, count: Int) -> some View {
        HStack(spacing: 6) {
            Text(title)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.black)

            Text("\(count)")
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(.purple)
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(
                    Capsule()
                        .fill(Color.white.opacity(0.8))
                )
        }
    }
    
}

#Preview {
    DashboardView(selectedTab: .constant(.home))
}
