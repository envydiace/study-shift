//
//  WeekCalendarView.swift
//  StudyShift
//
//  Created by Đức Anh on 28/4/26.
//

import SwiftUI

struct WeekCalendarView: View {
    @Binding var events: [CalendarEvent]
    let weekStartDate: Date
    let onEventTap: (CalendarEvent) -> Void

    private let hourHeight: CGFloat = 40

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let dayWidth = (width - 50) / 7

            ScrollView(.vertical) {
                ZStack(alignment: .topLeading) {
                    TimeGridView(hourHeight: hourHeight)

                    ForEach(eventsForCurrentWeek) { event in
                        CalendarEventView(
                            event: event,
                            weekStartDate: weekStartDate,
                            hourHeight: hourHeight,
                            dayWidth: dayWidth
                        ) {
                            onEventTap(event)
                        }
                    }
                }
                .frame(width: width, height: hourHeight * 24)
            }
        }
    }

    private var eventsForCurrentWeek: [CalendarEvent] {
        guard let weekEndDate = Calendar.current.date(
            byAdding: .day,
            value: 7,
            to: weekStartDate
        ) else {
            return []
        }

        return events.filter { event in
            event.start >= weekStartDate && event.start < weekEndDate
        }
    }
}

//#Preview {
//    
//
//    WeekCalendarView(events: events)
//}
