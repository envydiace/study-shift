//
//  CalendarLayoutHelper.swift
//  StudyShift
//
//  Created by Đức Anh on 28/4/26.
//

import Foundation
import SwiftUI

struct CalendarLayoutHelper {
    
    static func yPosition(for date: Date, hourHeight: CGFloat) -> CGFloat {
        let cal = Calendar.current
        let hour = cal.component(.hour, from: date)
        let minute = cal.component(.minute, from: date)
        
        return CGFloat(hour) * hourHeight
        + CGFloat(minute) / 60 * hourHeight
    }
    
    static func dayIndex(for date: Date) -> Int {
        let weekday = Calendar.current.component(.weekday, from: date)
        return (weekday + 5) % 7 // Monday = 0
    }
}
