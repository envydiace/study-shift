//
//  TimeGridView.swift
//  StudyShift
//
//  Created by Đức Anh on 28/4/26.
//

import SwiftUI

struct TimeGridView: View {
    
    let hourHeight: CGFloat
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<24, id: \.self) { hour in
                HStack(spacing: 0) {
                    
                    // Time label
                    Text(String(format: "%02d:00", hour))
                        .font(.caption2)
                        .foregroundColor(.gray)
                        .frame(width: 50, alignment: .trailing)
                        .padding(.trailing, 4)
                    
                    // Horizontal line
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 1)
                }
                .frame(height: hourHeight)
            }
        }
    }
}

#Preview {
    TimeGridView(hourHeight: CGFloat(60))
}
