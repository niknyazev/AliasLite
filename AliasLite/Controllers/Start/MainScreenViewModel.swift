//
//  MainScreenViewModel.swift
//  AliasLite
//
//  Created by Николай on 13.08.2022.
//

import Foundation

protocol PlayerDataViewModelProtocol {
    var name: String { get }
    var score: Int { get }
}

class PlayerData: PlayerDataViewModelProtocol {
    
    var name: String
    var score: Int
    
    init(player: Player) {
        name = player.name
        score = player.score
    }
}

protocol MainScreenViewModelProtocol {
    var playersCount: Int { get }
    func getPlayerData(for index: Int) -> PlayerDataViewModelProtocol
}

class MainScreenViewModel: MainScreenViewModelProtocol {
        
    var playersCount: Int {
        topPlayers.count
    }
    
    private let topPlayers: [Player]
    
    init() {
        topPlayers = PlayersManager.shared.getTopPlayers()
    }

    func getPlayerData(for index: Int) -> PlayerDataViewModelProtocol {
        PlayerData(player: topPlayers[index])
    }
}
