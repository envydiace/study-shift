//
//  ProgressBar.swift
//  StudyShift
//
//  Created by Đức Anh on 13/5/26.
//

import SwiftUI

struct ProgressBar: View {
    let progress: Double

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.purple.opacity(0.15))
                    .frame(height: 6)

                Capsule()
                    .fill(Color.purple)
                    .frame(width: geometry.size.width * progress, height: 6)
            }
        }
        .frame(height: 6)
    }
}

#Preview {
    ProgressBar(progress: 30)
}
