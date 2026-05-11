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

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                HStack(spacing: 12) {
                    Circle()
                        .fill(event.color)
                        .frame(width: 14, height: 14)

                    Text(event.title)
                        .font(.title2)
                        .fontWeight(.semibold)
                }

                VStack(alignment: .leading, spacing: 12) {
                    detailRow(
                        icon: "calendar",
                        title: "Date",
                        value: event.start.formatted(date: .abbreviated, time: .omitted)
                    )

                    detailRow(
                        icon: "clock",
                        title: "Start",
                        value: event.start.formatted(date: .omitted, time: .shortened)
                    )

                    detailRow(
                        icon: "clock.fill",
                        title: "End",
                        value: event.end.formatted(date: .omitted, time: .shortened)
                    )

                    detailRow(
                        icon: "hourglass",
                        title: "Duration",
                        value: durationText
                    )
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Event Detail")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }

    private func detailRow(
        icon: String,
        title: String,
        value: String
    ) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text(value)
                    .font(.body)
            }

            Spacer()
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private var durationText: String {
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
}

#Preview {
    EventDetailView(
        event: CalendarEvent(
            title: "iOS Development Class",
            start: Date(),
            end: Calendar.current.date(byAdding: .hour, value: 2, to: Date()) ?? Date(),
            color: .blue
        )
    )
}
