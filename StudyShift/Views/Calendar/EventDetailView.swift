//
//  SwiftUIView.swift
//  StudyShift
//
//  Created by Đức Anh on 11/5/26.
//
import SwiftUI

struct EventDetailView: View {
    @Environment(\.dismiss) private var dismiss

    let event: CalendarEvent
    let onDelete: () -> Void

    @State private var showDeleteConfirm = false

    var body: some View {
        ZStack {
            mainContent
                .blur(radius: showDeleteConfirm ? 3 : 0)

            if showDeleteConfirm {
                Color.black.opacity(0.25)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            showDeleteConfirm = false
                        }
                    }

                VStack {
                    Spacer()

                    deleteConfirmPopup
                        .padding(.horizontal)
                        .padding(.bottom, 90)
                }
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: showDeleteConfirm)
    }

    private var mainContent: some View {
        ZStack {
            Color.tealMain
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 22) {
                    header
                    contentCard
                }
                .padding(.horizontal, 24)
                .padding(.top, 30)
                .padding(.bottom, 40)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

private extension EventDetailView {
    var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Event Detail")
                    .font(.title2.bold())
                    .foregroundStyle(.black)

                Text(event.type.rawValue)
                    .font(.subheadline)
                    .foregroundStyle(.black.opacity(0.65))
            }

            Spacer()

            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.black)
                    .frame(width: 36, height: 36)
                    .background(Color.white.opacity(0.9))
                    .clipShape(Circle())
            }
        }
    }

    var contentCard: some View {
        VStack(alignment: .leading, spacing: 22) {
            eventTitleSection

            VStack(spacing: 12) {
                detailRow(
                    icon: "tag.fill",
                    title: "Event Type",
                    value: event.type.rawValue
                )

                detailRow(
                    icon: "calendar",
                    title: "Date",
                    value: dateText
                )

                detailRow(
                    icon: "clock",
                    title: "Time",
                    value: timeRangeText
                )

                detailRow(
                    icon: "hourglass",
                    title: "Duration",
                    value: durationText
                )

                if let location = event.location,
                   !location.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    detailRow(
                        icon: "mappin.and.ellipse",
                        title: "Location",
                        value: location
                    )
                }

                if event.type == .classSession,
                   let courseText = courseText {
                    detailRow(
                        icon: "book.closed.fill",
                        title: "Course",
                        value: courseText
                    )
                }

                if event.type == .personal,
                   let notes = event.notes,
                   !notes.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    detailRow(
                        icon: "note.text",
                        title: "Notes",
                        value: notes
                    )
                }
            }

            Button(role: .destructive) {
                withAnimation {
                    showDeleteConfirm = true
                }
            } label: {
                HStack {
                    Image(systemName: "trash")
                    Text("Delete Event")
                }
                .font(.headline.bold())
                .foregroundStyle(.red)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Color.red.opacity(0.12))
                .clipShape(Capsule())
            }
            .padding(.top, 8)
        }
        .padding(22)
        .background(Color.surfaceCard)
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }

    var eventTitleSection: some View {
        HStack(alignment: .top, spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(event.color.opacity(0.18))
                    .frame(width: 52, height: 52)

                Image(systemName: eventIcon)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(event.color)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(event.title)
                    .font(.title3.bold())
                    .foregroundStyle(.black)
                    .fixedSize(horizontal: false, vertical: true)

                Text(timeRangeText)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.black.opacity(0.6))
            }

            Spacer()
        }
    }

    func detailRow(
        icon: String,
        title: String,
        value: String
    ) -> some View {
        HStack(alignment: .center, spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.tealDark)
                .frame(width: 36, height: 36)
                .background(Color.tealMain.opacity(0.35))
                .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.caption.bold())
                    .foregroundStyle(.secondary)

                Text(value)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.black)
            }

            Spacer()
        }
        .padding(14)
        .background(Color.white.opacity(0.92))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}

private extension EventDetailView {
    var dateText: String {
        event.start.formatted(date: .abbreviated, time: .omitted)
    }

    var timeRangeText: String {
        "\(formatHourMinute(event.start)) - \(formatHourMinute(event.end))"
    }

    func formatHourMinute(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }

    var durationText: String {
        let duration = event.end.timeIntervalSince(event.start)
        let hours = Int(duration / 3600)
        let minutes = Int((duration.truncatingRemainder(dividingBy: 3600)) / 60)

        if hours == 0 {
            return "\(minutes)m"
        }

        if minutes == 0 {
            return "\(hours)h"
        }

        return "\(hours)h \(minutes)m"
    }

    var eventIcon: String {
        switch event.type {
        case .personal:
            return "person.fill"
        case .classSession:
            return "book.fill"
        case .workShift:
            return "briefcase.fill"
        case .task:
            return "checklist"
        }
    }
    
    var courseText: String? {
        let code = event.courseCode?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let name = event.courseName?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        if code.isEmpty && name.isEmpty {
            return nil
        }

        if code.isEmpty {
            return name
        }

        if name.isEmpty {
            return code
        }

        return "\(code) - \(name)"
    }
}

private extension EventDetailView {
    var deleteConfirmPopup: some View {
        VStack(spacing: 16) {
            Text("Delete Event?")
                .font(.title3.bold())
                .multilineTextAlignment(.center)

            Text("Are you sure you want to delete this event?")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 12)

            Divider()

            Button(role: .destructive) {
                onDelete()
                dismiss()
            } label: {
                Text("Delete Event")
                    .font(.title3.weight(.semibold))
                    .frame(maxWidth: .infinity)
            }

            Divider()

            Button {
                withAnimation {
                    showDeleteConfirm = false
                }
            } label: {
                Text("Cancel")
                    .font(.title3.weight(.semibold))
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 12)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(radius: 12)
    }
}

#Preview {
    EventDetailView(
        event: CalendarEvent(
            sourceId: UUID(),
            title: "iOS Development Class",
            start: Date(),
            end: Calendar.current.date(
                byAdding: .hour,
                value: 2,
                to: Date()
            ) ?? Date(),
            color: .blue,
            type: .classSession,
            location: "CB11.02.101",
            notes: nil,
            courseCode: "41889",
            courseName: "iOS Application Development"
        ),
        onDelete: {
            print("Preview delete tapped")
        }
    )
}
