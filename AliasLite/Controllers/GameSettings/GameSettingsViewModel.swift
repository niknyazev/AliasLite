//
//  GameSettingsViewModel.swift
//  AliasLite
//
//  Created by Николай on 13.08.2022.
//

import Foundation

protocol GameSettingsViewModelProtocol {
    // TODO: Substitute Player with view model
    
    var playersCount: Int { get }
    
    func getPlayerName(index: Int) -> String
    func savePlayer(name: String)
}

class GameSettingsViewModel: GameSettingsViewModelProtocol {
  
    private let playersManager = PlayersManager.shared
    private var players: [Player] = []
    
    var playersCount: Int {
        players.count
    }
    
    func getPlayerName(index: Int) -> String {
        players[index].name
    }
    
    func savePlayer(name: String) {
        playersManager.savePlayer(name: name)
        // TODO: Need refactoring
        getPlayers()
    }
    
    init() {
        getPlayers()
    }
    
    private func getPlayers() {
        players = playersManager.getTopPlayers()
    }
}
