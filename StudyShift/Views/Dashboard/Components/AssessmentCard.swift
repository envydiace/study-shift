//
//  AssessmentCard.swift
//  StudyShift
//
//  Created by Đức Anh on 13/5/26.
//

import SwiftUI

struct AssessmentCard: View {
    let item: DashboardAssessmentItem

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("\(item.subjectCode) \(item.subjectName)")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.black.opacity(0.45))
                .lineLimit(1)

            HStack(alignment: .center) {
                Text(item.title)
                    .font(.system(size: 18, weight: .semibold))
                    .lineLimit(1)

                Spacer(minLength: 10)

                SmallProgressRing(progress: item.progress)
            }

            ProgressBar(progress: item.progress)
        }
        .padding(16)
        .frame(width: 260)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
        )
    }
}

//#Preview {
//    AssessmentCard()
//}
