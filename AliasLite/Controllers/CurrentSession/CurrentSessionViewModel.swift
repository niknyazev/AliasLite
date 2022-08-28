//
//  CurrentSessionViewModel.swift
//  AliasLite
//
//  Created by Николай on 22.08.2022.
//

import Foundation

protocol CurrentSessionViewModelProtocol {
    var playerName: String { get }
    var currentWord: String { get }
    var wordsDropped: Int { get }
    var wordsGuessed: Int { get }
    func nextWord()
    func nextPlayer()
}

class CurrentSessionViewModel: CurrentSessionViewModelProtocol {
    
    var playerName = "Test player"
    var currentWord = "Press start"
    var wordsDropped = 10
    var wordsGuessed = 10
    
    private let players = PlayersManager.shared.getTopPlayers()
    private var currentPlayerIndex = 0
    private let words = WordsReader.shared.getWords().shuffled()
    private var currentWordIndex = 0
    private var currentPlayer: Player?
    
    func nextWord() {
        
        currentWordIndex += 1
        
        if currentWordIndex >= words.count {
            currentWordIndex = 0
        }
        
        currentWord = words[currentWordIndex].text
    }
    
    func nextPlayer() {

        currentPlayerIndex += 1
        
        if currentPlayerIndex >= players.count {
            currentPlayerIndex = 0
        }

        currentPlayer = players[currentPlayerIndex]
    }
}
