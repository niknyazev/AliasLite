//
//  CurrentSessionViewModel.swift
//  AliasLite
//
//  Created by Николай on 22.08.2022.
//

import Foundation
import CloudKit

protocol CurrentSessionViewModelProtocol {
    var playerName: String { get }
    var currentWord: String { get }
    var wordsDroppedTitle: String { get }
    var wordsGuessedTitle: String { get }
    var wordDidChange: (() -> Void)? { get set }
    var timerDidChange: ((Int) -> Void)? { get set } // TODO: make boxing
    var playerDidChange: (() -> Void)? { get set }
    var scoresTitle: String { get }
    var timeTitle: String { get }
    
    func startRound()
    func wordGuessed()
    func wordDropped()
    func nextPlayer()
    func endGame()
}

class CurrentSessionViewModel: CurrentSessionViewModelProtocol {
    
    // MARK: - Methods for updating view
    
    var playerDidChange: (() -> Void)?
    var timerDidChange: ((Int) -> Void)?
    var wordDidChange: (() -> Void)?
    
    // MARK: - Properties
    
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
    
    private let players: [Player]
    private var playersScores: [Player: Int] = [:]
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
        
        for player in players {
            playersScores[player] = 0
        }
        
        currentPlayer = players.first
        words = storageManager.fetchWords()
        currentWord = words.first?.text ?? ""
        gameSettings = storageManager.fetchSettings()
        time = Int(gameSettings?.roundDuration ?? 0)
        playerDidChange?()
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
        wordDidChange?()
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
        wordDidChange?()
    }
    
    func nextPlayer() {

        currentPlayerIndex += 1
        
        if currentPlayerIndex >= players.count {
            currentPlayerIndex = 0
        }

        currentPlayer = players[currentPlayerIndex]
        nextWord()
        time = Int(gameSettings?.roundDuration ?? 0)
        wordDidChange?()
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
            timerInvalidated()
            playerDidChange?()
            wordDidChange?()
        }
        
        timerDidChange?(time)
    }
    
    private func timerInvalidated() {
        
        if let player = currentPlayer {
            playersScores[player] =
                (playersScores[player] ?? 0) + (scores < 0 ? 0 : scores)
        }
        
        wordsDropped = 0
        wordsGuessed = 0
    }
    
    private func nextWord() {
        
        currentWordIndex += 1
        
        if currentWordIndex >= words.count {
            currentWordIndex = 0
        }
        
        currentWord = words[currentWordIndex].text ?? ""
    }
}
