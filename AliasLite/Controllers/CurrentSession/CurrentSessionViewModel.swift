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
    var wordsDroppedTitle: String { get }
    var wordsGuessedTitle: String { get }
    var viewModelDidChange: (() -> Void)? { get set }
    var scoresTitle: String { get }
    
    func wordGuessed()
    func wordDropped()
    func nextPlayer()
}

class CurrentSessionViewModel: CurrentSessionViewModelProtocol {
        
    var scoresTitle: String {
        "Scores: \(scores)"
    }
    var wordsDroppedTitle: String {
        "dropped: \(wordsDropped)"
    }
    var wordsGuessedTitle: String {
        "guessed: \(wordsGuessed)"
    }
    var playerName: String {
        currentPlayer?.name ?? ""
    }
    var currentWord = "Press start"
    var viewModelDidChange: (() -> Void)?
    
    private let players = PlayersManager.shared.getTopPlayers()
    private var currentPlayerIndex = 0
    private let words = StorageManager.shared.fetchWords()
    private var currentWordIndex = 0
    private var currentPlayer: Player?
    private var wordsDropped = 0
    private var wordsGuessed = 0
    private var scores: Int {
        (wordsGuessed - wordsDropped) < 0 ? 0 : (wordsGuessed - wordsDropped)
    }
    private let storageManager = StorageManager.shared
    
    // MARK: - Public methods
    
    func wordGuessed() {
        
        guard let currentPlayer = currentPlayer else {
            return
        }
        
        storageManager.putToLog(
            player: currentPlayer,
            word: words[currentWordIndex],
            guessed: true
        )
        
        wordsGuessed += 1
        nextWord()
        viewModelDidChange?()
    }
    
    func wordDropped() {
        
        guard let currentPlayer = currentPlayer else {
            return
        }
        
        storageManager.putToLog(
            player: currentPlayer,
            word: words[currentWordIndex],
            guessed: false
        )

        wordsDropped += 1
        nextWord()
        viewModelDidChange?()
    }
    
    func nextPlayer() {

        currentPlayerIndex += 1
        
        if currentPlayerIndex >= players.count {
            currentPlayerIndex = 0
        }

        currentPlayer = players[currentPlayerIndex]
        nextWord()
        viewModelDidChange?()
    }
    
    init() {
        currentPlayer = players.first
    }
    
    // MARK: - Private methods
    
    private func nextWord() {
        
        currentWordIndex += 1
        
        if currentWordIndex >= words.count {
            currentWordIndex = 0
        }
        
        currentWord = words[currentWordIndex].text ?? ""
    }
}
