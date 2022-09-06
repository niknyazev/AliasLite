//
//  GameLogViewModel.swift
//  AliasLite
//
//  Created by Николай on 06.09.2022.
//

import Foundation

protocol GameLogViewModelProtocol {
    var logData: [GameLog] { get }
}

class GameLogViewModel: GameLogViewModelProtocol {
    let logData: [GameLog] = []
}
