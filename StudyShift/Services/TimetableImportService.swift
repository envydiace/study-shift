//
//  TimetableImportService.swift
//  StudyShift
//
//  Created by Đức Anh on 26/4/26.
//

import Foundation

struct ImportedCalendarEvent {
    let uid: String
    let title: String
    let location: String
    let startDate: Date
    let endDate: Date
}

final class TimetableImportService {
    func importEvents(from urlString: String) async throws -> [ImportedCalendarEvent] {
        guard let url = URL(string: urlString) else {
            throw TimetableImportError.invalidURL
        }

        let (data, _) = try await URLSession.shared.data(from: url)

        guard let icsText = String(data: data, encoding: .utf8) else {
            throw TimetableImportError.invalidData
        }

        return parseICSText(icsText)
    }

    private func parseICSText(_ text: String) -> [ImportedCalendarEvent] {
        let eventBlocks = text.components(separatedBy: "BEGIN:VEVENT")
            .dropFirst()
            .compactMap { block -> String? in
                guard let eventText = block.components(separatedBy: "END:VEVENT").first else {
                    return nil
                }
                return eventText
            }

        return eventBlocks.compactMap { block in
            guard
                let uid = value(for: "UID", in: block),
                let title = value(for: "SUMMARY", in: block),
                let startRaw = value(for: "DTSTART", in: block),
                let endRaw = value(for: "DTEND", in: block),
                let startDate = parseICSDate(startRaw),
                let endDate = parseICSDate(endRaw)
            else {
                return nil
            }

            return ImportedCalendarEvent(
                uid: uid,
                title: title,
                location: value(for: "LOCATION", in: block) ?? "",
                startDate: startDate,
                endDate: endDate
            )
        }
    }

    private func value(for key: String, in block: String) -> String? {
        let lines = block.components(separatedBy: .newlines)

        for line in lines {
            if line.hasPrefix("\(key):") {
                return line.replacingOccurrences(of: "\(key):", with: "")
            }

            // Handles lines like DTSTART;TZID=Australia/Sydney:20260512T110000
            if line.hasPrefix("\(key);"),
               let value = line.components(separatedBy: ":").last {
                return value
            }
        }

        return nil
    }

    private func parseICSDate(_ raw: String) -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")

        if raw.hasSuffix("Z") {
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            formatter.dateFormat = "yyyyMMdd'T'HHmmss'Z'"
            return formatter.date(from: raw)
        } else {
            formatter.timeZone = TimeZone(identifier: "Australia/Sydney")
            formatter.dateFormat = "yyyyMMdd'T'HHmmss"
            return formatter.date(from: raw)
        }
    }
}

enum TimetableImportError: Error {
    case invalidURL
    case invalidData
}
