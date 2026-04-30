//
//  ClassSession.swift
//  StudyShift
//
//  Created by Đức Anh on 26/4/26.
//

import Foundation
import SwiftData

@Model
final class ClassSession {
    var id = UUID()
    var title: String
    var location: String
    var startTime: Date
    var endTime: Date

    var externalEventId: String?
    var sourceURL: String?

    var subject: Subject?

    init(
        id: UUID = UUID(),
        title: String,
        location: String = "",
        startTime: Date,
        endTime: Date,
        externalEventId: String? = nil,
        sourceURL: String? = nil,
        subject: Subject? = nil
    ) {
        self.id = id
        self.title = title
        self.location = location
        self.startTime = startTime
        self.endTime = endTime
        self.externalEventId = externalEventId
        self.sourceURL = sourceURL
        self.subject = subject
    }
}
