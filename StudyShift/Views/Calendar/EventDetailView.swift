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

                Button(role: .destructive) {
                    withAnimation {
                        showDeleteConfirm = true
                    }
                } label: {
                    Text("Delete Event")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red.opacity(0.12))
                        .foregroundColor(.red)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
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
    
    private var deleteConfirmPopup: some View {
        VStack(spacing: 16) {
            Text("Are you sure you want to delete this event?")
                .font(.subheadline)
                .multilineTextAlignment(.center)

            Divider()

            Button(role: .destructive) {
                onDelete()
                dismiss()
            } label: {
                Text("Delete Event")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
            }

            Divider()

            Button {
                withAnimation {
                    showDeleteConfirm = false
                }
            } label: {
                Text("Cancel")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.vertical, 16)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(radius: 12)
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
            sourceId: UUID(),
            title: "iOS Development Class",
            start: Date(),
            end: Calendar.current.date(
                byAdding: .hour,
                value: 2,
                to: Date()
            ) ?? Date(),
            color: .blue,
            type: .classSession
        ),
        onDelete: {
            print("Preview delete tapped")
        }
    )
}
