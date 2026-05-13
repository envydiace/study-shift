//
//  DashboardEmptyStateCard.swift
//  StudyShift
//
//  Created by Đức Anh on 14/5/26.
//

import SwiftUI

struct DashboardEmptyStateCard: View {
    let icon: String
    let title: String
    let message: String

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(.tealDark)

            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.primary)

            Text(message)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.black.opacity(0.55))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 22)
        .padding(.horizontal, 18)
        .background(Color.white.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    DashboardEmptyStateCard(
        icon: "doc.text",
        title: "No assessments yet",
        message: "Add assessments to track your progress here."
    )
}
