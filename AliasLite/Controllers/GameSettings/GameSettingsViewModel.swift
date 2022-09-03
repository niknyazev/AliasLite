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
    var sessionSettings: [(settingName: String, settingValue: String)] { get }
    var viewDidChange: (() -> Void)? { get set }
    
    func getPlayerName(index: Int) -> String
    func savePlayer(name: String)
}

class GameSettingsViewModel: GameSettingsViewModelProtocol {
    
    var viewDidChange: (() -> Void)?
    var sessionSettings = [
        (settingName: "Round duration:", settingValue: "60"),
        (settingName: "Total score:", settingValue: "100")
    ]
    var playersCount: Int {
        players.count
    }

    private let playersManager = PlayersManager.shared
    private var players: [Player] = []
    
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
        players = playersManager.getTopPlayers()
    }
}
