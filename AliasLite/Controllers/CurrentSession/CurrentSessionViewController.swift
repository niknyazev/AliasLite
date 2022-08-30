//
//  CurrentSessionViewController.swift
//  AliasLite
//
//  Created by Николай on 10.08.2022.
//

import UIKit
import CoreData

class CurrentSessionViewController: UIViewController {

    private var timer = Timer()
    private var time = 5 {
        didSet {
            startPauseButton.setTitle("\(time)", for: .normal)
        }
    }
    private var words: [Word] = []
    private var currentWordIndex = 0
    private var viewModel: CurrentSessionViewModelProtocol!
    
    private lazy var wordsManagingButtonsStack: UIStackView = {
        let result = UIStackView(arrangedSubviews: [dropWordButton, guessWordButton])
        result.distribution = .fillEqually
        result.spacing = 10
        return result
    }()
    
    private lazy var guessWordButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .green
        button.setTitle("Guess", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(nextWordPressed), for: .touchUpInside)
        
        // Shadow
        
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 3
        button.layer.cornerRadius = 15
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.layer.shadowOpacity = 0.7
        
        return button
    }()
    
    private lazy var dropWordButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.setTitle("Drop", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        
        // Shadow
        
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 3
        button.layer.cornerRadius = 15
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.layer.shadowOpacity = 0.7
        
//        button.addTarget(self, action: #selector(startNewGamePressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var startPauseButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.lightGray
        button.setTitle("Start", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(startPausePressed), for: .touchUpInside)
        return button
    }()
        
    private lazy var currentWordLabel: UILabel = {
        let label = UILabel()
        label.text = "Any word"
        label.font = .systemFont(ofSize: 30)
        label.textColor = .black
        return label
    }()
    
    private lazy var scoreLabel: UILabel = {
        let label = UILabel()
        label.text = "Score: 10"
        label.font = .systemFont(ofSize: 25)
        label.textColor = .red
        return label
    }()
    
//    private lazy var buttonsDescriptionStack: UIStackView = {
//        let result = UIStackView(arrangedSubviews: [droppedLabel, guessedLabel])
//        result.distribution = .fillEqually
//        result.alignment = .center
////        result.spacing = 10
//        return result
//    }()
    
    private lazy var droppedLabel: UILabel = {
        let label = UILabel()
        label.text = "dropped: 0"
        label.font = .systemFont(ofSize: 17)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private lazy var guessedLabel: UILabel = {
        let label = UILabel()
        label.text = "guessed: 3"
        label.font = .systemFont(ofSize: 17)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    
    
//    private lazy var playerNameLabel: UILabel = {
//        let label = UILabel()
//        label.text = "User name"
//        label.font = .systemFont(ofSize: 20)
//        label.textColor = .black
//        return label
//    }()
    
//    private lazy var timerLabel: UILabel = {
//        let label = UILabel()
//        label.text = "\(time)"
//        label.font = .systemFont(ofSize: 30)
//        label.textColor = .blue
//        return label
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        addConstraints()
        getWords()
        setupElements()
        // TODO: refactoring
        fillViewWithData()
    }
    
    private func setupViewModel() {
        viewModel = CurrentSessionViewModel()
        viewModel.viewModelDidChange = fillViewWithData
    }
    
    private func getWords() {
        words = WordsReader.shared.getWords().shuffled()
    }
    
    private func fillViewWithData() {
        title = viewModel.playerName
        currentWordLabel.text = viewModel.currentWord
        droppedLabel.text = viewModel.wordsDroppedTitle
        guessedLabel.text = viewModel.wordsGuessedTitle
    }
    
    private func setupElements() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis.circle"),
            style: .plain,
            target: self,
            action: #selector(menuPressed)
        )
        view.backgroundColor = .white
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
        view.addSubview(startPauseButton)
        view.addSubview(currentWordLabel)
        view.addSubview(scoreLabel)
        view.addSubview(droppedLabel)
        view.addSubview(guessedLabel)
              
        // Score label
        
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            scoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scoreLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 30)
        ])
        
        // Working with word buttons

        wordsManagingButtonsStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            wordsManagingButtonsStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            wordsManagingButtonsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            wordsManagingButtonsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            wordsManagingButtonsStack.heightAnchor.constraint(equalToConstant: 110)
        ])
        
        // Buttons description

        droppedLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            droppedLabel.topAnchor.constraint(equalTo: wordsManagingButtonsStack.bottomAnchor, constant: 10),
            droppedLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            droppedLabel.widthAnchor.constraint(equalTo: dropWordButton.widthAnchor, multiplier: 1)
        ])
        
        guessedLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            guessedLabel.topAnchor.constraint(equalTo: wordsManagingButtonsStack.bottomAnchor, constant: 10),
            guessedLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            guessedLabel.widthAnchor.constraint(equalTo: guessWordButton.widthAnchor, multiplier: 1)
        ])
              
        // Start button
        
        startPauseButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            startPauseButton.bottomAnchor.constraint(equalTo: wordsManagingButtonsStack.topAnchor, constant: -30),
            startPauseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startPauseButton.widthAnchor.constraint(equalToConstant: 120),
            startPauseButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
//        // Timer
//
//        timerLabel.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            timerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            timerLabel.bottomAnchor.constraint(equalTo: wordsManagingButtonsStack.topAnchor, constant: -40)
//        ])
        
        // Current word
        
        currentWordLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            currentWordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentWordLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc private func nextWordPressed() {
        viewModel.wordGuessed()
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
            self.viewModel.nextPlayer()
            self.fillViewWithData()
        }

        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
