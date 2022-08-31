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
        
    func fetchPlayers() -> [PlayerCore] {
        return [PlayerCore()]
    }
    
    func savePlayer(name: String) -> PlayerCore {
        
        let player = PlayerCore(context: viewContext)
        player.name = name
        
        saveContext()
        
        return player
    }
    
    func fetchWord() -> WordCore? {
        return WordCore()
    }
    
    func saveWord(text: String) -> WordCore {
        
        let word = WordCore(context: viewContext)
        word.text = text
        
        saveContext()
        
        return word
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


