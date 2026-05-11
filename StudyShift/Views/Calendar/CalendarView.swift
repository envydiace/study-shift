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
                },
                onAddEvent: {
                    viewModel.showAddEventScreen()
                }
            )

            WeekHeaderView(
                weekDates: viewModel.weekDates
            )

            WeekCalendarView(
                events: $viewModel.events,
                weekStartDate: viewModel.weekStartDate,
                onEventTap: { event in
                    viewModel.showEventDetail(event)
                }
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
        .sheet(isPresented: $viewModel.isShowingAddEventScreen) {
            AddEventView {
                viewModel.loadEvents()
            }
        }
        .sheet(isPresented: $viewModel.isShowingEventDetail) {
            if let event = viewModel.selectedEvent {
                EventDetailView(
                    event: event,
                    onDelete: {
                        viewModel.deleteSelectedEvent()
                    }
                )
            }
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
    CalendarView()
        .modelContainer(ModelContainerFactory.createPreviewContainer())
}
