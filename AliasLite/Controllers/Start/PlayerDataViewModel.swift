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
    var imageName: String { get }
}

class PlayerDataViewModel: PlayerDataViewModelProtocol {
    
    let name: String
    // TODO: Rename to wins
    let score: Int
    let currentGameScores: Int
    let imageName: String
    
    init(player: Player) {
        name = player.name ?? ""
        imageName = player.imageName ?? "greyman"
        score = Int(player.wins)
        currentGameScores = Int(player.currentScores)
    }
}
