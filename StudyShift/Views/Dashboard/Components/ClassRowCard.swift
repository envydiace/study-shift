//
//  ClassRowCard.swift
//  StudyShift
//
//  Created by Đức Anh on 13/5/26.
//

import SwiftUI

struct ClassRowCard: View {
    let item: DashboardClassItem

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(red: 0.07, green: 0.86, blue: 0.66))
                    .frame(width: 38, height: 38)

                Image(systemName: "book.closed.fill")
                    .foregroundColor(.black)
                    .font(.system(size: 16, weight: .semibold))
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("\(item.subjectCode) \(item.subjectName)")
                    .font(.system(size: 17, weight: .medium))
                    .lineLimit(1)

                Text("\(item.startTime) - \(item.endTime)")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.black.opacity(0.55))
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 8) {
                Text("CB11.02.101")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.green.opacity(0.85))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(Color.green.opacity(0.18))
                    )

                Text(item.dayText)
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(Color(red: 0.60, green: 0.55, blue: 0.00))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(Color.yellow.opacity(0.35))
                    )
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
        )
    }
}

//#Preview {
//    ClassRowCard()
//}
