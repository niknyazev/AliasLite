//
//  StorageManager.swift
//  AliasLite
//
//  Created by Николай on 31.08.2022.
//

import Foundation

//
//  StorageManager.swift
//  Flashcards
//
//  Created by Николай on 12.01.2022.
//

import CoreData

class StorageManager {
    
    // MARK: - Properties
    
    static let shared = StorageManager()
    
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Flashcards")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    private var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    private init() {}
    
    // MARK: - Public methods
    
    // MARK: - Fetching methods
    
    func fetchPlayers(completion: (Result<[Player], Error>) -> Void) {
//        let fetchRequest = Player.fetchRequest()
        
//        do {
//            let entities = try viewContext.fetch(fetchRequest)
//            completion(.success(entities))
//        } catch let error {
//            completion(.failure(error))
//        }
    }
    
    // MARK: - Saving methods
        
    // MARK: - Common methods
    
    func delete<T: NSManagedObject>(_ entity: T) {
        viewContext.delete(entity)
        saveContext()
    }
    
    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}


