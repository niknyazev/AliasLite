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
