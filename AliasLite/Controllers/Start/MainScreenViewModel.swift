//
//  MainScreenViewModel.swift
//  AliasLite
//
//  Created by Николай on 13.08.2022.
//

import Foundation

protocol MainScreenViewModelProtocol {
    var viewTitle: String { get }
    var numberOfSections: Int { get }
    func getPlayerData(for indexPath: IndexPath) -> PlayerDataViewModelProtocol
    func playersCount(for section: Int) -> Int
    func title(for section: Int) -> String
}

class MainScreenViewModel: MainScreenViewModelProtocol {
    
    var numberOfSections: Int {
        currentGamePlayers.isEmpty ? 1 : 2
    }
    let viewTitle = "Alias lite"
    
    private let storageManager = StorageManager.shared
    private let topPlayers: [Player]
    private let currentGamePlayers: [Player]
    
    init() {
        topPlayers = Array(storageManager.fetchPlayers().prefix(5))
        currentGamePlayers = Array(storageManager.fetchCurrentGamePlayers().prefix(4)) // TODO: mock data
        
        if storageManager.fetchWords().count == 0 {
            storageManager.importWords()
        }
    }

    func getPlayerData(for indexPath: IndexPath) -> PlayerDataViewModelProtocol {
        if indexPath.section == 0 {
            return PlayerDataViewModel(player: topPlayers[indexPath.row])
        } else {
            return PlayerDataViewModel(player: currentGamePlayers[indexPath.row])
        }
    }
    
    func playersCount(for section: Int) -> Int {
        if section == 0 {
            return topPlayers.count
        } else {
            return currentGamePlayers.count
        }
    }
    
    func title(for section: Int) -> String {
        if section == 0 {
            return "Top players"
        } else {
            return "Current game players"
        }
    }
}
