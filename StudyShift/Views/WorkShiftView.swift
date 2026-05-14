//
//  WorkShiftView.swift
//  StudyShift
//
//  Created by Đức Anh on 30/4/26.
//

import SwiftUI
import SwiftData

typealias WorkplaceGroup = (workplace: String, shifts: [WorkShift], totalHours: Double, durationLabel: String)

struct WorkShiftView: View {
    @Environment(\.modelContext) private var context
    @StateObject private var viewModel = WorkShiftViewModel()
    @State private var showAddShift = false

    private let visaLimit: Double = 48

    var body: some View {
        ZStack {
            Color.tealMain
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    headerBar
                    visaCard
                    upcomingSection
                    previousSection
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 55)
                .padding(.bottom, 40)
            }

            VStack {
                Spacer()
                Button {
                    showAddShift = true
                } label: {
                    Text("+ Log Shift")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.tealDark)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .fullScreenCover(isPresented: $showAddShift) {
            AddShiftView(viewModel: viewModel) {
                viewModel.loadShifts()
            }
        }
        .task {
            viewModel.configure(context: context)
        }
    }

    // MARK: - Remaining label

    private var remainingLabel: String {
        let totalWorkedMinutes = viewModel.shiftsThisFortnight.reduce(0) { total, shift in
            total + Int(shift.endTime.timeIntervalSince(shift.startTime) / 60)
        }
        let visaMinutes = Int(visaLimit * 60)
        let remainingMinutes = max(0, visaMinutes - totalWorkedMinutes)
        let hours = remainingMinutes / 60
        let minutes = remainingMinutes % 60
        if minutes == 0 {
            return "\(hours)h remaining"
        }
        return "\(hours)h \(minutes)m remaining"
    }

    private var isLowHours: Bool {
        let totalWorkedMinutes = viewModel.shiftsThisFortnight.reduce(0) { total, shift in
            total + Int(shift.endTime.timeIntervalSince(shift.startTime) / 60)
        }
        let visaMinutes = Int(visaLimit * 60)
        let remainingMinutes = max(0, visaMinutes - totalWorkedMinutes)
        return remainingMinutes < 600
    }

    // MARK: - Header

    private var headerBar: some View {
        HStack {
                    Text("Work Shifts")
                        .font(.title2.bold())
                        .foregroundStyle(.black)
                    Spacer()
                }
    }

    // MARK: - Visa Card

    private var visaCard: some View {
        VStack(spacing: 8) {
            HStack(alignment: .center, spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        if isLowHours {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundStyle(.yellow)
                        }
                        Text(remainingLabel)
                            .font(.subheadline.bold())
                            .foregroundStyle(.black)
                            .lineLimit(1)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    Text("Plan Shifts Carefully")
                        .font(.caption)
                        .foregroundStyle(.black.opacity(0.6))
                }

                Spacer()

                ZStack {
                    Circle()
                        .stroke(Color.black.opacity(0.1), lineWidth: 8)
                        .frame(width: 64, height: 64)

                    Circle()
                        .trim(from: 0, to: CGFloat(min(viewModel.totalHoursThisFortnight / visaLimit, 1)))
                        .stroke(
                            isLowHours ? Color.red : Color.tealDark,
                            style: StrokeStyle(lineWidth: 8, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))
                        .frame(width: 64, height: 64)

                    VStack(spacing: 0) {
                        Text(circleHoursLabel)
                            .font(.caption.bold())
                            .foregroundStyle(.black)
                        if circleMinutesLabel != nil {
                            Text(circleMinutesLabel!)
                                .font(.system(size: 9, weight: .bold))
                                .foregroundStyle(.black)
                        }
                    }
                }

                Button { } label: {
                    Image(systemName: "ellipsis")
                        .foregroundStyle(.black.opacity(0.5))
                }
            }
            .padding(16)
            .background(Color.surfaceCard)
            .clipShape(RoundedRectangle(cornerRadius: 16))

            HStack {
                Text("Visa Restriction Of \(Int(visaLimit)) Hrs")
                    .font(.caption)
                    .foregroundStyle(.black.opacity(0.7))
                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .padding(.top, 4)
            .background(Color.white.opacity(0.4))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }

    private var circleHoursLabel: String {
        let hours = Int(viewModel.totalHoursThisFortnight)
        return "\(hours)h"
    }

    private var circleMinutesLabel: String? {
        let totalMinutes = viewModel.shiftsThisFortnight.reduce(0) { total, shift in
            total + Int(shift.endTime.timeIntervalSince(shift.startTime) / 60)
        }
        let minutes = totalMinutes % 60
        return minutes == 0 ? nil : "\(minutes)m"
    }

    // MARK: - Upcoming Shifts

    private var upcomingSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Upcoming Shifts")
                .font(.headline)
                .foregroundStyle(.black)

            if viewModel.upcomingShifts.isEmpty {
                Text("No upcoming shifts.")
                    .font(.subheadline)
                    .foregroundStyle(.black.opacity(0.5))
                    .padding(.top, 4)
            } else {
                ForEach(viewModel.upcomingShifts) { shift in
                    shiftRow(shift: shift)
                }
            }
        }
    }

    // MARK: - Previous Shifts

    private var previousSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Previous Shifts")
                .font(.headline)
                .foregroundStyle(.black)

            if viewModel.previousShifts.isEmpty {
                Text("No previous shifts.")
                    .font(.subheadline)
                    .foregroundStyle(.black.opacity(0.5))
                    .padding(.top, 4)
            } else {
                ForEach(viewModel.previousShifts) { shift in
                    shiftRow(shift: shift)
                }
            }
        }
    }

    // MARK: - Shift Row Card

    private func shiftRow(shift: WorkShift) -> some View {
        let timeFormatter: DateFormatter = {
            let f = DateFormatter()
            f.dateFormat = "h:mm a"
            return f
        }()

        let dateFormatter: DateFormatter = {
            let f = DateFormatter()
            f.dateFormat = "EEE d MMM"
            return f
        }()

        return HStack(alignment: .center, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(shift.workplace)
                    .font(.subheadline.bold())
                    .foregroundStyle(.black)

                Text(dateFormatter.string(from: shift.startTime))
                    .font(.caption)
                    .foregroundStyle(.black.opacity(0.55))

                Text("\(timeFormatter.string(from: shift.startTime)) – \(timeFormatter.string(from: shift.endTime))")
                    .font(.caption)
                    .foregroundStyle(.black.opacity(0.55))
            }

            Spacer()

            Text(shift.durationLabel)
                .font(.headline.bold())
                .foregroundStyle(.black)
        }
        .padding(16)
        .background(Color.surfaceCard)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

#Preview {
    WorkShiftView()
        .modelContainer(ModelContainerFactory.createPreviewContainer())
}
