
//
//  AppError.swift
//  StudyShift
//
//  Created by Đức Anh on 11/5/26.
//

import Foundation

enum RepositoryError: LocalizedError {
    case entityNotFound

    var errorDescription: String? {
        switch self {
        case .entityNotFound:
            return "The selected item could not be found."
        }
    }
}
