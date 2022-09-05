//
//  MainScreenViewModel.swift
//  AliasLite
//
//  Created by Николай on 13.08.2022.
//

import Foundation

protocol MainScreenViewModelProtocol {
    var playersCount: Int { get }
    var viewTitle: String { get }
    func getPlayerData(for index: Int) -> PlayerDataViewModelProtocol
}

class MainScreenViewModel: MainScreenViewModelProtocol {
    
    private let storageManager = StorageManager.shared
        
    var playersCount: Int {
        topPlayers.count
    }
    
    let viewTitle = "Alias lite"
    
    private let topPlayers: [Player]
    
    init() {
        topPlayers = PlayersManager.shared.getTopPlayers()
        
        if storageManager.fetchWords().count == 0 {
            storageManager.importWords()
        }
    }

    func getPlayerData(for index: Int) -> PlayerDataViewModelProtocol {
        PlayerDataViewModel(player: topPlayers[index])
    }
}
