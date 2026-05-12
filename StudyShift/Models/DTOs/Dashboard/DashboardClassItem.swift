//
//  DashboardClassItem.swift
//  StudyShift
//
//  Created by Đức Anh on 13/5/26.
//

import Foundation

struct DashboardClassItem: Identifiable {
    let id = UUID()
    let subjectCode: String
    let subjectName: String
    let startTime: String
    let endTime: String
    let dayText: String
}
