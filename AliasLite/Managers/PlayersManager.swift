//
//  PlayersManager.swift
//  AliasLite
//
//  Created by Николай on 10.08.2022.
//

import Foundation

final class PlayersManager {
    
    static let shared = PlayersManager()
    
    private init() { }
    
    private var players = [
        Player(),
        Player(),
        Player()
    ]
    
    func getTopPlayers() -> [Player] {
        // TODO: need refactoring
        StorageManager.shared.fetchPlayers()
    }
    
    func savePlayer(name: String) {
        players.append(Player())
    }
}
