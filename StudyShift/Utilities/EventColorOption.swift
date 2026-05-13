//
//  EventColorOption.swift
//  StudyShift
//
//  Created by Đức Anh on 13/5/26.
//

import SwiftUI

struct EventColorOption: Identifiable, Hashable {
    let id: String
    let name: String
    let hex: String

    var color: Color {
        Color(hex: hex)
    }
}

extension EventColorOption {
    static let options: [EventColorOption] = [
        EventColorOption(id: "blue", name: "Blue", hex: "#0060F2"),
        EventColorOption(id: "purple", name: "Purple", hex: "#7048E8"),
        EventColorOption(id: "orange", name: "Orange", hex: "#D95C0D"),
        EventColorOption(id: "red", name: "Red", hex: "#C92A2A"),
        EventColorOption(id: "green", name: "Green", hex: "#006B3C"),
        EventColorOption(id: "teal", name: "Teal", hex: "#0B7285"),
        EventColorOption(id: "pink", name: "Pink", hex: "#D6336C"),
        EventColorOption(id: "indigo", name: "Indigo", hex: "#3B5BDB"),
        EventColorOption(id: "brown", name: "Brown", hex: "#8B5E34"),
        EventColorOption(id: "gray", name: "Gray", hex: "#495057")
    ]

    static let defaultColor = EventColorOption(
        id: "blue",
        name: "Blue",
        hex: "#0060F2"
    )
}
