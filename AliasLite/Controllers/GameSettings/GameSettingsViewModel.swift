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
    func saveGameSettings()
    func selectPlayer(index: Int)
    func isPlayerSelected(index: Int) -> Bool
}

class SettingsRow {

    enum SettingsTypes: String {
        case roundDuration = "Round duration"
        case totalScore = "Total score"
    }

    let type: SettingsTypes
    var title: String {
        type.rawValue
    }
    var value: Int
    var valueTitle: String {
        "\(value)"
    }
    let alertTitle: String
    
    init(type: SettingsTypes, value: Int, alertTitle: String) {
        self.type = type
        self.value = value
        self.alertTitle = alertTitle
    }
}

class GameSettingsViewModel: GameSettingsViewModelProtocol {

    let sessionSettings: [SettingsRow]
    var viewDidChange: (() -> Void)?
    var playersCount: Int {
        players.count
    }

    private let storageManager = StorageManager.shared
    private var players: [Player] = []
    private var selectedPlayers: Set<Player>
    
    func isPlayerSelected(index: Int) -> Bool {
        let player = players[index]
        return selectedPlayers.contains(player)
    }
    
    func selectPlayer(index: Int) {
        
        let player = players[index]
        
        if selectedPlayers.contains(player) {
            selectedPlayers.remove(player)
        } else {
            selectedPlayers.insert(player)
        }
    }
    
    func saveGameSettings() {
        
        var gameGoal = 0
        var roundDuration = 0
        
        sessionSettings.forEach { settingRow in
            switch settingRow.type {
            case .totalScore:
                gameGoal = settingRow.value
            case .roundDuration:
                roundDuration = settingRow.value
            }
        }
        
        storageManager.saveGameSettings(
            gameGoal: gameGoal,
            roundDuration: roundDuration,
            players: Array(selectedPlayers).shuffled(),
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
        
        let currentSettings = storageManager.fetchSettings()
        
        sessionSettings = [
            SettingsRow(
                type: .roundDuration,
                value: Int(currentSettings?.roundDuration ?? 60),
                alertTitle: "Enter the duration of the round"
            ),
            SettingsRow(
                type: .totalScore,
                value: Int(currentSettings?.gameGoal ?? 100),
                alertTitle: "Enter the goal scores of the game"
            )
        ]
        
        selectedPlayers = Set(storageManager.fetchCurrentGamePlayers())
        getPlayers()
    }
    
    private func getPlayers() {
        players = storageManager.fetchPlayers()
    }
}
