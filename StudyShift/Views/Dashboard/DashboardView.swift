//
//  DashboardView.swift
//  StudyShift
//
//  Created by Đức Anh on 30/4/26.
//

import SwiftUI

struct DashboardView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: DashboardViewModel

    @Binding var selectedTab: MainTab

    private let screenBackground = Color.tealMain

    init(
        selectedTab: Binding<MainTab>
    ) {
        _selectedTab = selectedTab
        _viewModel = StateObject(wrappedValue: DashboardViewModel())
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 18) {
                headerSection
                shiftSummaryCard
                sectionHeader(title: "Assignments In Progress", count: viewModel.dashboardAssignments.count)
                assignmentSection
                sectionHeader(title: "Upcoming Classes", count: viewModel.upcomingClasses.count)
                classesSection
                sectionHeader(title: "Upcoming Deadlines", count: viewModel.upcomingDeadlines.count)
                deadlinesSection
            }
            .padding(.horizontal, 16)
            .padding(.top, 14)
            .padding(.bottom, 24)
        }
        .background(screenBackground.ignoresSafeArea())
        .task {
            viewModel.configure(context: modelContext)
            viewModel.loadDashboardData()
        }
    }

    // MARK: - Header

    var headerSection: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 2) {
                Text(viewModel.greetingTitle)
                    .font(.system(size: 26, weight: .bold))

                Text(viewModel.greetingSubtitle)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.black.opacity(0.75))
            }
        }
    }

    // MARK: - Shift Summary Card

    var shiftSummaryCard: some View {
        VStack(spacing: 8) {
            HStack(alignment: .center, spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 6) {
                        if viewModel.isLowHours {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundStyle(.yellow)
                        }
                        Text(viewModel.remainingHoursText)
                            .font(.subheadline.bold())
                            .foregroundStyle(.black)
                            .lineLimit(1)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    Text(viewModel.remainingHoursSubtitle)
                        .font(.caption)
                        .foregroundStyle(.black.opacity(0.6))

                    Button {
                        selectedTab = .work
                    } label: {
                        Text("View Shift Log")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.black)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Capsule().fill(Color.tealMain))
                    }
                }

                Spacer()

                ZStack {
                    Circle()
                        .stroke(Color.black.opacity(0.1), lineWidth: 8)
                        .frame(width: 64, height: 64)

                    Circle()
                        .trim(from: 0, to: CGFloat(min(viewModel.workedProgress, 1)))
                        .stroke(
                            viewModel.isLowHours ? Color.red : Color.tealDark,
                            style: StrokeStyle(lineWidth: 8, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))
                        .frame(width: 64, height: 64)

                    VStack(spacing: 0) {
                        Text(viewModel.workedHoursLabel)
                            .font(.caption.bold())
                            .foregroundStyle(.black)
                        if let minutesLabel = viewModel.workedMinutesLabel {
                            Text(minutesLabel)
                                .font(.system(size: 9, weight: .bold))
                                .foregroundStyle(.black)
                        }
                    }
                }

                Button {
                    // ellipsis menu placeholder
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundStyle(.black.opacity(0.5))
                }
            }
            .padding(16)
            .background(Color.surfaceCard)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }

    // MARK: - Assessments

    var assignmentSection: some View {
        VStack {
            if viewModel.dashboardAssignments.isEmpty {
                DashboardEmptyStateCard(
                   icon: "doc.text",
                   title: "No assignments yet",
                   message: "Add assignments to track your progress here."
               )
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 14) {
                        ForEach(viewModel.dashboardAssignments) { item in
                            AssignmentCard(item: item)
                        }
                    }
                    .padding(.trailing, 8)
                }
            }
        }
    }

    // MARK: - Classes

    var classesSection: some View {
        VStack {
            if viewModel.upcomingClasses.isEmpty {
                DashboardEmptyStateCard(
                    icon: "calendar",
                    title: "No upcoming classes",
                    message: "Your next classes will appear here after you add or import a timetable."
                )
            } else {
                VStack(spacing: 12) {
                    ForEach(viewModel.upcomingClasses) { item in
                        ClassRowCard(item: item)
                    }
                }
            }
        }
    }

    // MARK: - Deadlines

    var deadlinesSection: some View {
        VStack {
            if viewModel.upcomingDeadlines.isEmpty {
                DashboardEmptyStateCard(
                    icon: "clock.badge.exclamationmark",
                    title: "No upcoming deadlines",
                    message: "Assignment deadlines will appear here when they are added."
                )
            } else {
                VStack(spacing: 12) {
                    ForEach(viewModel.upcomingDeadlines) { item in
                        DeadlineRowCard(item: item)
                    }
                }
            }
        }
    }

    // MARK: - Section Header

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
                .background(Capsule().fill(Color.white.opacity(0.8)))
        }
    }
}

#Preview {
    DashboardView(selectedTab: .constant(.home))
}
