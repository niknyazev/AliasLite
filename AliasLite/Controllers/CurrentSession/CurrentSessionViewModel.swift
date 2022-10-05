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
    var timerDidChange: ((Int) -> Void)? { get set } // TODO: make boxing
    var newRoundPrepare: (() -> Void)? { get set }
    var scoresTitle: String { get }
    var timeTitle: String { get }
    
    func startRound()
    func wordGuessed()
    func wordDropped()
    func nextPlayer()
    func endGame()
}

class CurrentSessionViewModel: CurrentSessionViewModelProtocol {
    
    var newRoundPrepare: (() -> Void)?
    var timerDidChange: ((Int) -> Void)?
    var timeTitle: String {
        "\(time)"
    }
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
    var currentWord: String
    var viewModelDidChange: (() -> Void)?
    
    private let players: [Player]
    private let words: [Word]
    private var currentPlayerIndex = 0
    private var currentWordIndex = 0
    private var currentPlayer: Player?
    private var wordsDropped = 0
    private var wordsGuessed = 0
    private var scores: Int {
        (wordsGuessed - wordsDropped) < 0 ? 0 : (wordsGuessed - wordsDropped)
    }
    private let storageManager = StorageManager.shared
    private var timer = Timer()
    private var time: Int
    private let gameSettings: GameSettings?
    
    init() {
        players = storageManager.fetchCurrentGamePlayers()
        currentPlayer = players.first
        words = storageManager.fetchWords()
        currentWord = words.first?.text ?? ""
        gameSettings = storageManager.fetchSettings()
        time = Int(gameSettings?.roundDuration ?? 0)
        newRoundPrepare?()
    }
    
    // MARK: - Public methods
    
    func startRound() {
        startTimer()
    }
    
    func endGame() {
        storageManager.removeGameData()
    }
    
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
        time = Int(gameSettings?.roundDuration ?? 0)
        viewModelDidChange?()
    }
    
    
    // MARK: - Private methods
    
    private func startTimer() {
                
        if timer.isValid {
            timer.invalidate()
            timerDidChange?(time)
            return
        }
        
        timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(timeChanged),
            userInfo: nil,
            repeats: true
        )
    }
    
    @objc private func timeChanged() {
        
        time -= 1
        
        if time == 0 {
            timer.invalidate()
            newRoundPrepare?()
        }
        
        timerDidChange?(time)
    }
    
    private func nextWord() {
        
        currentWordIndex += 1
        
        if currentWordIndex >= words.count {
            currentWordIndex = 0
        }
        
        currentWord = words[currentWordIndex].text ?? ""
    }
}
