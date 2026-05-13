//
//  WeekHeaderView.swift
//  StudyShift
//
//  Created by Đức Anh on 29/4/26.
//

import SwiftUI

struct WeekHeaderView: View {
    let weekDates: [Date]

    var body: some View {
        HStack(spacing: 0) {
            Spacer(minLength: 50)
            ForEach(weekDates, id: \.self) { date in
                VStack {
                    Text(dayOfWeek(from: date))
                        .font(.caption)
                        .foregroundColor(.black)

                    Text(dayNumber(from: date))
                        .font(.headline)
                        .fontWeight(isToday(date) ? .bold : .semibold)
                        .foregroundColor(isToday(date) ? .white : .primary)
                        .frame(width: 34, height: 34)
                        .background(
                            Circle()
                                .fill(isToday(date) ? Color.tealDark : Color.clear)
                        )
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.vertical, 6)
    }
    
    private func isToday(_ date: Date) -> Bool {
            Calendar.current.isDateInToday(date)
        }

    func dayOfWeek(from date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "EEE"
        return f.string(from: date)
    }

    func dayNumber(from date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "d"
        return f.string(from: date)
    }
}

#Preview {
    WeekHeaderView(weekDates: currentWeek(from: Date()))
}

func currentWeek(from date: Date) -> [Date] {
    let calendar = Calendar.current
    let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: date)!.start

    return (0..<7).map {
        calendar.date(byAdding: .day, value: $0, to: startOfWeek)!
    }
}
