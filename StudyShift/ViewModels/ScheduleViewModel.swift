//
//  ScheduleViewModel.swift
//  StudyShift
//
//  Created by Đức Anh on 28/4/26.
//

import Foundation
import SwiftUI
import Combine

final class ScheduleViewModel: ObservableObject {
    
    // MARK: - Public API
    func makeEvents(
        classSessions: [ClassSession],
        workShifts: [WorkShift],
        tasks: [TodoTask],
        assessments: [Assessment]
    ) -> [CalendarEvent] {
        
        var events: [CalendarEvent] = []
        
        // Class
        events += classSessions.map {
            CalendarEvent(
                title: $0.title,
                start: $0.startTime,
                end: $0.endTime,
                color: .blue
            )
        }
        
        // Work
        events += workShifts.map {
            CalendarEvent(
                title: $0.workplace.isEmpty ? $0.title : $0.workplace,
                start: $0.startTime,
                end: $0.endTime,
                color: .orange
            )
        }
        
        // Tasks
        events += tasks.compactMap {
            guard let start = $0.scheduledStart,
                  let end = $0.scheduledEnd else { return nil }
            
            return CalendarEvent(
                title: $0.title,
                start: start,
                end: end,
                color: .green
            )
        }
        
        // Assessments
//        events += assessments.map {
//            CalendarEvent(
//                title: $0.title,
//                start: $0.startTime,
//                end: $0.endTime,
//                color: .purple
//            )
//        }
//        
        return events
    }
}
