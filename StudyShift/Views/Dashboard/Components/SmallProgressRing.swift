//
//  SmallProgressRing.swift
//  StudyShift
//
//  Created by Đức Anh on 13/5/26.
//

import SwiftUI

struct SmallProgressRing: View {
    let progress: Double

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.purple.opacity(0.18), lineWidth: 5)

            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    Color.purple,
                    style: StrokeStyle(lineWidth: 5, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))

            Text("\(Int(progress * 100))%")
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(.purple)
        }
        .frame(width: 38, height: 38)
    }
}

#Preview {
    SmallProgressRing(progress: 30)
}
