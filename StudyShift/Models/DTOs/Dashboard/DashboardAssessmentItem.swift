//
//  DashboardAssessmentItem.swift
//  StudyShift
//
//  Created by Đức Anh on 13/5/26.
//

import Foundation

struct DashboardAssessmentItem: Identifiable {
    let id = UUID()
    let subjectCode: String
    let subjectName: String
    let title: String
    let progress: Double   // 0...1
}
