//
//  Repository.swift
//  StudyShift
//
//  Created by Codex on 30/4/26.
//

import Foundation
import SwiftData

protocol RepositoryProtocol {
    associatedtype Entity: PersistentModel

    var context: ModelContext { get }

    func fetch(with descriptor: FetchDescriptor<Entity>) throws -> [Entity]
    func fetchAll() throws -> [Entity]
    func insert(_ entity: Entity) throws
    func insert(_ entities: [Entity]) throws
    func delete(_ entity: Entity) throws
    func save() throws
}

extension RepositoryProtocol {
    func fetch(with descriptor: FetchDescriptor<Entity>) throws -> [Entity] {
        try context.fetch(descriptor)
    }

    func fetchAll() throws -> [Entity] {
        try fetch(with: FetchDescriptor<Entity>())
    }

    func insert(_ entity: Entity) throws {
        context.insert(entity)
        try save()
    }

    func insert(_ entities: [Entity]) throws {
        for entity in entities {
            context.insert(entity)
        }

        try save()
    }

    func delete(_ entity: Entity) throws {
        context.delete(entity)
        try save()
    }

    func save() throws {
        try context.save()
    }
}
