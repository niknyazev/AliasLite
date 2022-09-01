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

class PlayerDataViewModel: PlayerDataViewModelProtocol {
    
    var name: String
    // Rename to wins
    var score: Int
    
    init(player: Player) {
        name = player.name ?? ""
        score = Int(player.wins)
    }
}

protocol MainScreenViewModelProtocol {
    var playersCount: Int { get }
    var viewTitle: String { get }
    func getPlayerData(for index: Int) -> PlayerDataViewModelProtocol
}

class MainScreenViewModel: MainScreenViewModelProtocol {
        
    var playersCount: Int {
        topPlayers.count
    }
    
    let viewTitle = "Alias lite"
    
    private let topPlayers: [Player]
    
    init() {
        topPlayers = PlayersManager.shared.getTopPlayers()
    }

    func getPlayerData(for index: Int) -> PlayerDataViewModelProtocol {
        PlayerDataViewModel(player: topPlayers[index])
    }
}
