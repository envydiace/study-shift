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
    let onTitleTap: () -> Void

    var body: some View {
        HStack {
            Button {
                onPreviousWeek()
            } label: {
                Image(systemName: "chevron.left")
            }

            Spacer()

            Button {
                onTitleTap()
            } label: {
                HStack(spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .fontWeight(.semibold)

                    Image(systemName: "chevron.down")
                        .font(.caption)
                }
                .foregroundColor(.primary)
            }

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
