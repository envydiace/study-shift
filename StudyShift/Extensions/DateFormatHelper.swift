//
//  DateFormatHelper.swift
//  StudyShift
//
//  Created by Đức Anh on 12/5/26.
//

import Foundation

struct DateFormatHelper {
    static func formatHourMinute(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    static func formatDay(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date)
    }
}
