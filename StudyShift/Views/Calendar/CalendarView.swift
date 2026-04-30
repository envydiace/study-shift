//
//  WeekCalendarScreen.swift
//  StudyShift
//
//  Created by Đức Anh on 29/4/26.
//

import SwiftUI
import SwiftData

struct CalendarView: View {
    @Environment(\.modelContext) private var context
    @StateObject private var viewModel: CalendarViewModel

    init(
        selectedDate: Date = Date(),
        events: [CalendarEvent] = []
    ) {
        _viewModel = StateObject(
            wrappedValue: CalendarViewModel(
                selectedDate: selectedDate,
                events: events
            )
        )
    }

    var body: some View {
        VStack(spacing: 0) {
            CalendarTopBar(
                title: viewModel.monthTitle,
                onPreviousWeek: {
                    withAnimation {
                        viewModel.goToPreviousWeek()
                    }
                },
                onNextWeek: {
                    withAnimation {
                        viewModel.goToNextWeek()
                    }
                },
                onToday: {
                    withAnimation {
                        viewModel.goToToday()
                    }
                },
                onTitleTap: {
                    viewModel.showMonthPicker()
                }
            )

            WeekHeaderView(
                weekDates: viewModel.weekDates
            )

            WeekCalendarView(
                events: $viewModel.events,
                weekStartDate: viewModel.weekStartDate
            )
            .gesture(
                DragGesture()
                    .onEnded { value in
                        let horizontalAmount = value.translation.width
                        let verticalAmount = value.translation.height

                        guard abs(horizontalAmount) > abs(verticalAmount) else {
                            return
                        }

                        guard abs(horizontalAmount) > 50 else {
                            return
                        }

                        withAnimation {
                            if horizontalAmount < 0 {
                                viewModel.goToNextWeek()
                            } else {
                                viewModel.goToPreviousWeek()
                            }
                        }
                    }
            )
        }
        .sheet(isPresented: $viewModel.isShowingMonthPicker) {
            MonthPickerView(
                selectedDate: viewModel.selectedDate
            ) { newDate in
                withAnimation {
                    viewModel.selectMonth(newDate)
                }
            }
            .presentationDetents([.medium])
        }
        .task {
            viewModel.configure(context: context)
            viewModel.loadEvents()
        }
        .alert("Error", isPresented: errorBinding) {
            Button("OK", role: .cancel) {
                viewModel.errorMessage = ""
            }
        } message: {
            Text(viewModel.errorMessage)
        }
    }

    private var errorBinding: Binding<Bool> {
        Binding(
            get: { !viewModel.errorMessage.isEmpty },
            set: { isPresented in
                if !isPresented {
                    viewModel.errorMessage = ""
                }
            }
        )
    }
}

#Preview {
    let events: [CalendarEvent] = [
        CalendarEvent(
            title: "Study SwiftUI 26",
            start: previewDate(year: 2026, month: 4, day: 26, hour: 0, minute: 0),
            end: previewDate(year: 2026, month: 4, day: 26, hour: 12, minute: 0),
            color: Color.red
        ),
        CalendarEvent(
            title: "Study SwiftUI 27",
            start: previewDate(year: 2026, month: 4, day: 27, hour: 0, minute: 0),
            end: previewDate(year: 2026, month: 4, day: 27, hour: 12, minute: 0),
            color: Color.red
        ),
        CalendarEvent(
            title: "Study SwiftUI 28",
            start: previewDate(year: 2026, month: 4, day: 28, hour: 10, minute: 0),
            end: previewDate(year: 2026, month: 4, day: 28, hour: 12, minute: 0),
            color: Color.blue
        ),
        CalendarEvent(
            title: "Study SwiftUI 29",
            start: previewDate(year: 2026, month: 4, day: 29, hour: 10, minute: 0),
            end: previewDate(year: 2026, month: 4, day: 29, hour: 12, minute: 0),
            color: Color.blue
        ),
        CalendarEvent(
            title: "Study SwiftUI 30",
            start: previewDate(year: 2026, month: 4, day: 30, hour: 8, minute: 0),
            end: previewDate(year: 2026, month: 4, day: 30, hour: 9, minute: 0),
            color: Color.green
        ),
        CalendarEvent(
            title: "Study SwiftUI 01",
            start: previewDate(year: 2026, month: 5, day: 1, hour: 10, minute: 0),
            end: previewDate(year: 2026, month: 5, day: 1, hour: 11, minute: 0),
            color: Color.green
        ),
        CalendarEvent(
            title: "Study SwiftUI 2",
            start: previewDate(year: 2026, month: 5, day: 2, hour: 8, minute: 0),
            end: previewDate(year: 2026, month: 5, day: 2, hour: 9, minute: 0),
            color: Color.green
        ),
        CalendarEvent(
            title: "Study SwiftUI 3",
            start: previewDate(year: 2026, month: 5, day: 3, hour: 8, minute: 0),
            end: previewDate(year: 2026, month: 5, day: 3, hour: 9, minute: 0),
            color: Color.green
        )
    ]

    CalendarView(
        selectedDate: previewDate(year: 2026, month: 4, day: 30, hour: 0, minute: 0),
        events: events
    )
}

private func previewDate(
    year: Int,
    month: Int,
    day: Int,
    hour: Int,
    minute: Int
) -> Date {
    var components = DateComponents()
    components.year = year
    components.month = month
    components.day = day
    components.hour = hour
    components.minute = minute

    return Calendar.current.date(from: components)!
}
