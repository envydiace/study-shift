//
//  UUIDIdentifiableModel.swift
//  StudyShift
//
//  Created by Đức Anh on 11/5/26.
//

import Foundation
import SwiftData

protocol UUIDIdentifiableModel: PersistentModel {
    var id: UUID { get }
}
