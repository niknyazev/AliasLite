//
//  CurrentSessionViewController.swift
//  AliasLite
//
//  Created by Николай on 10.08.2022.
//

import UIKit
import CoreData

class CurrentSessionViewController: UIViewController {

    var timer = Timer()
    var time = 5 {
        didSet {
            timerLabel.text = "\(time)"
        }
    }
    var words: [Word] = []
    var currentWordIndex = 0
    
    private lazy var wordsManagingButtonsStack: UIStackView = {
        let result = UIStackView(arrangedSubviews: [dropWordButton, guessWordButton])
        result.distribution = .fillEqually
        result.spacing = 10
        return result
    }()
    
    private lazy var sessionControlButtonsStack: UIStackView = {
        let result = UIStackView(arrangedSubviews: [finishButton, startPauseButton])
        result.distribution = .fillEqually
        result.spacing = 10
        return result
    }()
    
    private lazy var guessWordButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 21/255, green: 101/255, blue: 192/255, alpha: 1)
        button.setTitle("Guess", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(nextWordPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var dropWordButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 21/255, green: 101/255, blue: 192/255, alpha: 1)
        button.setTitle("Drop", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 4
//        button.addTarget(self, action: #selector(startNewGamePressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var startPauseButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 21/255, green: 101/255, blue: 192/255, alpha: 1)
        button.setTitle("Start", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(startPausePressed), for: .touchUpInside)
        return button
    }()
        
    private lazy var finishButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 21/255, green: 101/255, blue: 192/255, alpha: 1)
        button.setTitle("Finish", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 4
//        button.addTarget(self, action: #selector(startNewGamePressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var currentWordLabel: UILabel = {
        let label = UILabel()
        label.text = "Any word"
        label.font = .systemFont(ofSize: 20)
        label.textColor = .black
        return label
    }()
    
    private lazy var playerNameLabel: UILabel = {
        let label = UILabel()
        label.text = "User name"
        label.font = .systemFont(ofSize: 30)
        label.textColor = .black
        return label
    }()
    
    private lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.text = "001"
        label.font = .systemFont(ofSize: 30)
        label.textColor = .black
        return label
    }()
    
    override func viewDidLoad() {
        
        // TODO: remove
        view.backgroundColor = .green
        
        super.viewDidLoad()
        addConstraints()
        getWords()
        setupElements()
    }
    
    private func getWords() {
        words = WordsReader.getWords().shuffled()
    }
    
    private func setupElements() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis.circle"),
            style: .plain,
            target: self,
            action: #selector(menuPressed)
        )
    }
    
    @objc private func menuPressed() {
        
        let alertController = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: .actionSheet
        )

        let logAction = UIAlertAction(title: "Log", style: .default) { _ in
            print("Log")
        }
        
        let gameSettings = UIAlertAction(title: "Game settings", style: .default) { _ in
            print("Log")
        }

        let endSession = UIAlertAction(title: "End session", style: .destructive) { _ in
            print("Log")
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        alertController.addAction(logAction)
        alertController.addAction(gameSettings)
        alertController.addAction(endSession)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
    
    private func addConstraints() {
        
        view.addSubview(wordsManagingButtonsStack)
        view.addSubview(sessionControlButtonsStack)
        view.addSubview(timerLabel)
        view.addSubview(currentWordLabel)
        view.addSubview(playerNameLabel)
              
        // Players name
        
        playerNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            playerNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            playerNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playerNameLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 30)
        ])

        // Session buttons
        
        sessionControlButtonsStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sessionControlButtonsStack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            sessionControlButtonsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            sessionControlButtonsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
        ])
        
        // Working with word buttons

        wordsManagingButtonsStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            wordsManagingButtonsStack.bottomAnchor.constraint(equalTo: sessionControlButtonsStack.topAnchor, constant: -20),
            wordsManagingButtonsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            wordsManagingButtonsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
        ])
                
        // Timer
        
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            timerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timerLabel.bottomAnchor.constraint(equalTo: wordsManagingButtonsStack.topAnchor, constant: -20)
        ])
        
        // Current word
        
        currentWordLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            currentWordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentWordLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc private func nextWordPressed() {
        
        if currentWordIndex >= words.count {
            currentWordIndex = 0
            return
        }
        
        currentWordLabel.text = words[currentWordIndex].text
        currentWordIndex += 1
    }
    
    @objc private func startPausePressed() {
        
        if timer.isValid {
            timer.invalidate()
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
            view.backgroundColor = .red
            showAlertTimeIsOver()
        }
    }
    
    private func showAlertTimeIsOver() {
        
        let alertController = UIAlertController(
            title: nil,
            message: "Time is over. Pass the phone to the Team",
            preferredStyle: .alert
        )

        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
        }

        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
