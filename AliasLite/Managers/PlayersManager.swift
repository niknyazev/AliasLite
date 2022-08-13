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
        Player(name: "Nick", score: 10),
        Player(name: "Maya", score: 20),
        Player(name: "Jack", score: 5)
    ]
    
    func getTopPlayers() -> [Player] {
        players
    }
    
    func savePlayer(name: String) {
        players.append(Player(name: name, score: 0))
    }
}
