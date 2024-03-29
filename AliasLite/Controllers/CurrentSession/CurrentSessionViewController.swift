//
//  CurrentSessionViewController.swift
//  AliasLite
//
//  Created by Николай on 10.08.2022.
//

import UIKit
import CoreData

class CurrentSessionViewController: UIViewController {

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
        button.addTarget(self, action: #selector(wordGuessPressed), for: .touchUpInside)
        
        button.addShadow()
        
        return button
    }()
    
    private lazy var dropWordButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.setTitle("Drop", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(wordDropPressed), for: .touchUpInside)
        
        button.addShadow()
        
        return button
    }()
        
    private lazy var startPauseButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
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
        label.isHidden = true
        return label
    }()
    
    private lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.text = "60"
        label.font = .systemFont(ofSize: 30)
        label.textColor = .blue
        return label
    }()
    
    private lazy var scoreLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 25)
        label.textColor = .red
        return label
    }()
        
    private lazy var droppedLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private lazy var guessedLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        addConstraints()
        setupElements()
        // TODO: refactoring
        prepareForNewWord()
        changeAlphaButtons(isActive: false)
    }
    
    private func setupViewModel() {
        viewModel = CurrentSessionViewModel()
        viewModel.wordDidChange = prepareForNewWord
        viewModel.playerDidChange = playerDidChange
        viewModel.timerDidChange = timerDidChange
    }
    
    private func timerDidChange(time: Int) {
        timerLabel.text = viewModel.timeTitle
        if time == 0 {
            showAlertTimeIsOver()
        }
    }
    
    private func playerDidChange() {
        changeAlphaButtons(isActive: false)
        title = viewModel.playerName
        showHideStartButton(isHidden: false)
    }
    
    private func prepareForNewWord() {
        currentWordLabel.text = viewModel.currentWord
        droppedLabel.text = viewModel.wordsDroppedTitle
        guessedLabel.text = viewModel.wordsGuessedTitle
        scoreLabel.text = viewModel.scoresTitle
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
       
    private func addConstraints() {
        
        view.addSubview(wordsManagingButtonsStack)
        view.addSubview(startPauseButton)
        view.addSubview(currentWordLabel)
        view.addSubview(scoreLabel)
        view.addSubview(droppedLabel)
        view.addSubview(guessedLabel)
        view.addSubview(timerLabel)
        
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
              
        // Score label
        
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scoreLabel.bottomAnchor.constraint(equalTo: wordsManagingButtonsStack.topAnchor, constant: -30),
            scoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scoreLabel.widthAnchor.constraint(equalToConstant: 120)
        ])
                
        // Timer
        
        timerLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            timerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            timerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
                        
        // Current word
        
        currentWordLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            currentWordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentWordLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        // Start button
        
        startPauseButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            startPauseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startPauseButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            startPauseButton.widthAnchor.constraint(equalToConstant: 120),
            startPauseButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - Buttons handlers
    
    @objc private func wordDropPressed() {
        viewModel.wordDropped()
    }
    
    @objc private func wordGuessPressed() {
        viewModel.wordGuessed()
    }
    
    @objc private func menuPressed() {
        
        let alertController = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: .actionSheet
        )

        let logAction = UIAlertAction(title: "Log", style: .default) { _ in
            let navigationController = UINavigationController(rootViewController: GameLogViewController())
            self.present(navigationController, animated: true)
        }
        
        let gameSettings = UIAlertAction(title: "Game settings", style: .default) { _ in
            let navigationController = UINavigationController(rootViewController:
                GameSettingsViewController(isEnabled: false)
            )
            self.present(navigationController, animated: true)
        }

        let endSession = UIAlertAction(title: "End game", style: .destructive) { _ in
            self.questionBeforeEndingGame()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        alertController.addAction(logAction)
        alertController.addAction(gameSettings)
        alertController.addAction(endSession)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
 
    private func questionBeforeEndingGame() {
        
        let alertController = UIAlertController(
            title: nil,
            message: "Do you want to finish game?",
            preferredStyle: .alert
        )

        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
            self.viewModel.endGame()
            self.dismiss(animated: true)
        }

        let noAction = UIAlertAction(title: "No", style: .cancel)

        alertController.addAction(yesAction)
        alertController.addAction(noAction)

        present(alertController, animated: true, completion: nil)
    }
    
    @objc private func startPausePressed() {
        showHideStartButton(isHidden: true)
        changeAlphaButtons(isActive: true)
        viewModel.startRound()
    }
    
    private func changeAlphaButtons(isActive: Bool) {
        let alphaValue = isActive ? 1 : 0.3
        guessWordButton.alpha = alphaValue
        dropWordButton.alpha = alphaValue
        scoreLabel.alpha = alphaValue
    }
    
    private func showHideStartButton(isHidden: Bool) {
        startPauseButton.isHidden = isHidden
        currentWordLabel.isHidden = !isHidden
    }
    
    private func showAlertTimeIsOver() {
        
        let alertController = UIAlertController(
            title: nil,
            message: "Time is over. Pass the phone to the Team",
            preferredStyle: .alert
        )

        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.viewModel.nextPlayer()
        }

        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
