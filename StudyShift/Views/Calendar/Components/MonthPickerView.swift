//
//  MonthPickerView.swift
//  StudyShift
//
//  Created by Đức Anh on 30/4/26.
//

import Foundation
import SwiftUI

struct MonthPickerView: View {
    let selectedDate: Date
    let onSelect: (Date) -> Void

    @State private var selectedMonth: Int
    @State private var selectedYear: Int

    private let months = Calendar.current.monthSymbols

    init(
        selectedDate: Date,
        onSelect: @escaping (Date) -> Void
    ) {
        self.selectedDate = selectedDate
        self.onSelect = onSelect

        let components = Calendar.current.dateComponents([.month, .year], from: selectedDate)

        _selectedMonth = State(initialValue: components.month ?? 1)
        _selectedYear = State(initialValue: components.year ?? 2026)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                HStack {
                    Picker("Month", selection: $selectedMonth) {
                        ForEach(1...12, id: \.self) { month in
                            Text(months[month - 1])
                                .tag(month)
                        }
                    }
                    .pickerStyle(.wheel)

                    Picker("Year", selection: $selectedYear) {
                        ForEach(2020...2035, id: \.self) { year in
                            Text(String(year))
                                .tag(year)
                        }
                    }
                    .pickerStyle(.wheel)
                }
                .frame(height: 180)

                Button {
                    let newDate = makeSelectedDate()
                    onSelect(newDate)
                } label: {
                    Text("Go to Month")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
            }
            .navigationTitle("Choose Month")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func makeSelectedDate() -> Date {
        var components = DateComponents()
        components.year = selectedYear
        components.month = selectedMonth
        components.day = 1
        components.hour = 0
        components.minute = 0

        return Calendar.current.date(from: components) ?? selectedDate
    }
}
