//
//  CalendarEvent.swift
//  StudyShift
//
//  Created by Đức Anh on 28/4/26.
//

import Foundation
import SwiftUI

struct CalendarEvent: Identifiable {
    let id = UUID()
    let title: String
    let start: Date
    let end: Date
    let color: Color
}
