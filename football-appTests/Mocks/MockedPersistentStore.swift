//
//  MockedPersistentStore.swift
//  football-appTests
//
//  Created by James on 12/01/2024.
//

import CoreData
import Combine
@testable import football_app

final class MockedPersistentStore: Mock, PersistentStore {
    struct ContextSnapshot: Equatable {
        let inserted: Int
        let updated: Int
        let deleted: Int
    }
    enum Action: Equatable {
        case count
        case update(ContextSnapshot)
        case fetchAllTeam(ContextSnapshot)
        case fetchAllMatch(ContextSnapshot)
    }
    var actions = MockActions<Action>(expected: [])
    
    var countResult: Int = 0
    
    deinit {
        destroyDatabase()
    }
    
    // MARK: - count
    
    func count<T>(_ fetchRequest: NSFetchRequest<T>) -> AnyPublisher<Int, Error> {
        register(.count)
        return Just<Int>.withErrorType(countResult, Error.self).publish()
    }
    
    // MARK: - fetch
    
    func fetch<ManagedObject, DecoableObject>(_ fetchRequest: NSFetchRequest<ManagedObject>,
                     map: @escaping (ManagedObject) throws -> DecoableObject?) -> AnyPublisher<LazyList<DecoableObject>, Error> {
        do {
            let context = container.viewContext
            context.reset()
            let result = try context.fetch(fetchRequest)
            if ManagedObject.self is FootballTeamMO.Type {
                register(.fetchAllTeam(context.snapshot))
            } else if ManagedObject.self is FootballMatchMO.Type {
                register(.fetchAllMatch(context.snapshot))
            } else {
                fatalError("Add a case for \(String(describing: ManagedObject.self))")
            }
            let list = LazyList<DecoableObject>(count: result.count, useCache: true, { index in
                try map(result[index])
            })
            return Just<LazyList<DecoableObject>>.withErrorType(list, Error.self).publish()
        } catch {
            return Fail<LazyList<DecoableObject>, Error>(error: error).publish()
        }
    }

    // MARK: - update

    func update<Result>(_ operation: @escaping DBOperation<Result>) -> AnyPublisher<Result, Error> {
        do {
            let context = container.viewContext
            context.reset()
            let result = try operation(context)
            register(.update(context.snapshot))
            return Just(result).setFailureType(to: Error.self).publish()
        } catch {
            return Fail<Result, Error>(error: error).publish()
        }
    }
    
    // MARK: - preloadData
    
    func preloadData(_ preload: (NSManagedObjectContext) throws -> Void) throws {
        try preload(container.viewContext)
        if container.viewContext.hasChanges {
            try container.viewContext.save()
        }
        container.viewContext.reset()
    }
    
    // MARK: - Database
    
    private let dbVersion = CoreDataStack.Version(CoreDataStack.Version.actual)
    
    private var dbURL: URL {
        guard let url = dbVersion.dbFileURL(.cachesDirectory, .userDomainMask)
            else { fatalError() }
        return url
    }
    
    private lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: dbVersion.modelName)
        try? FileManager().removeItem(at: dbURL)
        let store = NSPersistentStoreDescription(url: dbURL)
        container.persistentStoreDescriptions = [store]
        let group = DispatchGroup()
        group.enter()
        container.loadPersistentStores { (desc, error) in
            if let error = error {
                fatalError("\(error)")
            }
            group.leave()
        }
        group.wait()
        container.viewContext.mergePolicy = NSOverwriteMergePolicy
        container.viewContext.undoManager = nil
        return container
    }()
    
    private func destroyDatabase() {
        try? container.persistentStoreCoordinator
            .destroyPersistentStore(at: dbURL, ofType: NSSQLiteStoreType, options: nil)
        try? FileManager().removeItem(at: dbURL)
    }
}

extension NSManagedObjectContext {
    var snapshot: MockedPersistentStore.ContextSnapshot {
        .init(inserted: insertedObjects.count,
              updated: updatedObjects.count,
              deleted: deletedObjects.count)
    }
}
