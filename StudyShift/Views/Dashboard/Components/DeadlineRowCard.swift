//
//  DeadlineRowCard.swift
//  StudyShift
//
//  Created by Đức Anh on 13/5/26.
//

import SwiftUI

struct DeadlineRowCard: View {
    let item: DashboardDeadlineItem

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(red: 0.07, green: 0.86, blue: 0.66))
                    .frame(width: 38, height: 38)

                Image(systemName: "doc.text.fill")
                    .foregroundColor(.black)
                    .font(.system(size: 16, weight: .semibold))
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.system(size: 17, weight: .medium))
                    .lineLimit(1)

                Text(item.dueText)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.black.opacity(0.55))
            }

            Spacer()

            Text(item.statusText)
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(item.statusColor)
                .padding(.horizontal, 18)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(item.statusBackground)
                )
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
        )
    }
}

//#Preview {
//    DeadlineRowCard()
//}
