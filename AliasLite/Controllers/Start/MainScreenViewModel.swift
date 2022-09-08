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
    var numberOfSections: Int { get }
    func getPlayerData(for section: Int, and index: Int) -> PlayerDataViewModelProtocol
}

class MainScreenViewModel: MainScreenViewModelProtocol {
    
    let numberOfSections = 2
    var playersCount: Int {
        topPlayers.count
    }
    let viewTitle = "Alias lite"
    
    private let storageManager = StorageManager.shared
    private let topPlayers: [Player]
    
    init() {
        topPlayers = PlayersManager.shared.getTopPlayers()
        
        if storageManager.fetchWords().count == 0 {
            storageManager.importWords()
        }
    }

    func getPlayerData(for section: Int, and index: Int) -> PlayerDataViewModelProtocol {
        PlayerDataViewModel(player: topPlayers[index])
    }
    
}
