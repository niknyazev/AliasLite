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
        let container = NSPersistentContainer(name: "AliasLite")
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
        
    func fetchPlayers() -> [Player] {
        
        let fetchRequest = Player.fetchRequest()
        
        do {
            return try viewContext.fetch(fetchRequest)
        } catch {
            return []
        }
    }
    
    @discardableResult
    func savePlayer(name: String) -> Player {
        
        let player = Player(context: viewContext)
        player.name = name
        
        saveContext()
        
        return player
    }
    
    func putToLog(player: Player, word: Word, guessed: Bool) {
        
    }
    
    func saveGameSettings() {
        
    }
    
    func fetchWords() -> [Word] {
        return [Word()]
    }
    
    func importWords() {
        
        let words = WordsReader.shared.getWords()
        
        for word in words {
            saveWord(text: word.text ?? "")
        }
    }
    
    func saveWord(text: String) {
        
        let word = Word(context: viewContext)
        word.text = text
        
        saveContext()
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

