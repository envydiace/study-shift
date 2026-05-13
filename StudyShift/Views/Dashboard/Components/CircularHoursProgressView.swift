//
//  CircularHoursProgressView.swift
//  StudyShift
//
//  Created by Đức Anh on 13/5/26.
//

import SwiftUI

struct CircularHoursProgressView: View {
    let progress: Double
    let centerText: String

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.18), lineWidth: 10)

            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    Color(red: 0.83, green: 0.02, blue: 0.18),
                    style: StrokeStyle(lineWidth: 10, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))

            Text(centerText)
                .font(.system(size: 20, weight: .bold))
        }
        .frame(width: 88, height: 88)
    }
}

//#Preview {
//    CircularHoursProgressView()
//}
