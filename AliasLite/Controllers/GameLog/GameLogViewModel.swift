//
//  GameLogViewModel.swift
//  AliasLite
//
//  Created by Николай on 06.09.2022.
//

import Foundation

protocol GameLogViewModelProtocol {
    
    var playersNames: [String] { get }
    
    func title(for section: Int) -> String
    func log(for section: Int) -> [GameLog]
}

class GameLogViewModel: GameLogViewModelProtocol {

    let playersNames: [String]
    private let logData: [String: [GameLog]]
    
    init() {
        logData = StorageManager.shared.fetchLogData().reduce(into: [:]) { result, logRow in
            let name = logRow.player?.name ?? "Unknown"
            result[name] == nil
                ? result[name] = [logRow]
                : result[name]?.append(logRow)
        }
        playersNames = Array(logData.keys)
    }
   
    func title(for section: Int) -> String {
        playersNames[section]
    }
    
    func log(for section: Int) -> [GameLog] {
        logData[playersNames[section]] ?? []
    }
    
}
