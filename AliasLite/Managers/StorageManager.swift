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
        
    func fetchCurrentGamePlayers() -> [Player] {
        
        let settings = fetchSettings()
        
        if let players = settings?.players {
            return (players.array as? [Player]) ?? []
        } else {
            return []
        }
    }
    
    func removeGameData() {
        
        let log = fetchLogData()
        
        log.forEach {
            delete($0)
        }
        
        let settings = fetchSettings()
        
        guard let settings = settings else {
            return
        }
        
        delete(settings)
    }
    
    @discardableResult
    func savePlayer(name: String) -> Player {
        
        let player = Player(context: viewContext)
        player.name = name
        
        saveContext()
        
        return player
    }
    
    func putToLog(player: Player, word: Word, guessed: Bool) {
      
        let log = GameLog(context: viewContext)
        
        log.player = player
        log.word = word.text
        log.guessed = guessed
          
        saveContext()
    }
    
    func saveGameSettings(gameGoal: Int, roundDuration: Int, players: [Player], currentPlayer: Player? = nil) {
                
        let savedSettings = fetchSettings()
        let settings = savedSettings == nil ? GameSettings(context: viewContext) : savedSettings!
        
        settings.players = NSOrderedSet(array: players)
        settings.gameGoal = Int16(gameGoal)
        settings.roundDuration = Int16(roundDuration)
        
        saveContext()
    }
    
    func fetchWords() -> [Word] {
        
        let fetchRequest = Word.fetchRequest()
        
        do {
            return try viewContext.fetch(fetchRequest)
        } catch {
            return []
        }
    }
    
    func fetchSettings() -> GameSettings? {
        
        let fetchRequest = GameSettings.fetchRequest()
        
        do {
            let result = try viewContext.fetch(fetchRequest)
            return result.first
        } catch {
            return nil
        }
    }
    
    func fetchLogData() -> [GameLog] {
        
        let fetchRequest = GameLog.fetchRequest()
        
        do {
            return try viewContext.fetch(fetchRequest)
        } catch {
            return []
        }
    }
    
    func importWords() {
        
        let words = WordsReader.shared.getWords()
        
        for word in words {
            saveWord(text: word.text)
        }
    }
    
    func saveWord(text: String) {
        
        let word = Word(context: viewContext)
        word.text = text
        
        saveContext()
    }
    
    func deleteAllWords() {
        for word in fetchWords() {
            delete(word)
        }
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


