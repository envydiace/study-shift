//
//  CalendarEventView.swift
//  StudyShift
//
//  Created by Đức Anh on 28/4/26.
//

import SwiftUI

struct CalendarEventView: View {
    let event: CalendarEvent
    let weekStartDate: Date
    let hourHeight: CGFloat
    let dayWidth: CGFloat
    let onTap: () -> Void

    var body: some View {
        Text(event.title)
            .font(.caption2)
            .foregroundColor(.white)
            .lineLimit(4)
            .minimumScaleFactor(0.85)
            .padding(.horizontal, 4)
            .padding(.vertical, 3)
            .frame(
                width: dayWidth - 8,
                height: eventHeight,
                alignment: .topLeading
            )
            .background(event.color)
            .cornerRadius(6)
            .offset(
                x: xOffset,
                y: yOffset
            )
            .onTapGesture {
                onTap()
            }
    }

    private var xOffset: CGFloat {
        CGFloat(dayIndex) * dayWidth + 50
    }

    private var yOffset: CGFloat {
        let components = Calendar.current.dateComponents(
            [.hour, .minute],
            from: event.start
        )

        let hour = CGFloat(components.hour ?? 0)
        let minute = CGFloat(components.minute ?? 0)

        let timeOffset = hour * hourHeight + (minute / 60) * hourHeight

        return timeOffset + hourHeight / 2
    }

    private var eventHeight: CGFloat {
        let duration = event.end.timeIntervalSince(event.start)
        let hours = duration / 3600

        return max(CGFloat(hours) * hourHeight, 30)
    }

    private var dayIndex: Int {
        let startOfEventDay = Calendar.current.startOfDay(for: event.start)
        let startOfWeekDay = Calendar.current.startOfDay(for: weekStartDate)

        let difference = Calendar.current.dateComponents(
            [.day],
            from: startOfWeekDay,
            to: startOfEventDay
        )

        return difference.day ?? 0
    }
}

//#Preview {
//    CalendarEventView()
//}
