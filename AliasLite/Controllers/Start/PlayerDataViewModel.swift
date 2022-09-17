//
//  PlayerDataViewModel.swift
//  AliasLite
//
//  Created by Николай on 02.09.2022.
//

import Foundation

protocol PlayerDataViewModelProtocol {
    var name: String { get }
    var score: Int { get }
    var currentGameScores: Int { get }
}

class PlayerDataViewModel: PlayerDataViewModelProtocol {
    
    var name: String
    // TODO: Rename to wins
    var score: Int
    var currentGameScores: Int
    
    init(player: Player) {
        name = player.name ?? ""
        score = Int(player.wins)
        currentGameScores = Int(player.currentScores)
    }
}
