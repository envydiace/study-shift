//
//  DashboardDeadlineItem.swift
//  StudyShift
//
//  Created by Đức Anh on 13/5/26.
//

import Foundation
import SwiftUI

struct DashboardDeadlineItem: Identifiable {
    let id = UUID()
    let title: String
    let dueText: String
    let statusText: String
    let statusColor: Color
    let statusBackground: Color
}
