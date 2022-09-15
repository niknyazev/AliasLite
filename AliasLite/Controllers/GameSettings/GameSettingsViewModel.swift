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
    var sessionSettings: [SettingsRow] { get }
    var viewDidChange: (() -> Void)? { get set }
    
    func getPlayerName(index: Int) -> String
    func savePlayer(name: String)
    func saveGameSettings(gameGoal: Int, roundDuration: Int)
    func selectPlayer(index: Int)
}

struct SettingsRow {

    enum SettingsTypes: String {
        case roundDuration = "Round duration"
        case totalScore = "Total score"
    }

    let type: SettingsTypes
    var title: String {
        type.rawValue
    }
    let value: Int
    var valueTitle: String {
        "\(value)"
    }
}

class GameSettingsViewModel: GameSettingsViewModelProtocol {
    
    let sessionSettings = [
        SettingsRow(type: .roundDuration, value: 60),
        SettingsRow(type: .totalScore, value: 300)
    ]
    var viewDidChange: (() -> Void)?
    var playersCount: Int {
        players.count
    }

    private let storageManager = StorageManager.shared
    private var players: [Player] = []
    private var selectedPlayers: Set<Player> = []
    
    func selectPlayer(index: Int) {
        
        let player = players[index]
        
        if selectedPlayers.contains(player) {
            selectedPlayers.remove(player)
        } else {
            selectedPlayers.insert(player)
        }
    }
    
    func saveGameSettings(gameGoal: Int, roundDuration: Int) {
        storageManager.saveGameSettings(
            gameGoal: gameGoal,
            roundDuration: roundDuration,
            players: Array(selectedPlayers),
            currentPlayer: selectedPlayers.first
        )
    }
    
    func getPlayerName(index: Int) -> String {
        players[index].name ?? ""
    }
    
    func savePlayer(name: String) {
        StorageManager.shared.savePlayer(name: name)
        getPlayers()
        viewDidChange?()
    }
    
    init() {
        getPlayers()
    }
    
    private func getPlayers() {
        players = storageManager.fetchPlayers()
    }
}
