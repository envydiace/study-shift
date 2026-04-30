//
//  CalendarTopBar.swift
//  StudyShift
//
//  Created by Đức Anh on 29/4/26.
//

import SwiftUI

struct CalendarTopBar: View {
    let title: String
    let onPreviousWeek: () -> Void
    let onNextWeek: () -> Void
    let onToday: () -> Void

    var body: some View {
        HStack {
            Button {
                onPreviousWeek()
            } label: {
                Image(systemName: "chevron.left")
            }

            Spacer()

            Text(title)
                .font(.headline)
                .fontWeight(.semibold)

            Spacer()

            Button {
                onNextWeek()
            } label: {
                Image(systemName: "chevron.right")
            }

            Button("Today") {
                onToday()
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
    }
}

//#Preview {
//    CalendarTopBar()
//}
