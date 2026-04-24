//
//  Item.swift
//  StudyShift
//
//  Created by Đức Anh on 24/4/26.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
