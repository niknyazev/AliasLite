//
//  ViewController.swift
//  AliasLite
//
//  Created by Николай on 04.08.2022.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var startNewGame: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 21/255, green: 101/255, blue: 192/255, alpha: 1)
        button.setTitle("New game", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(startButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var tableTopPlayers: UITableView = {
        let result = UITableView()
        result.dataSource = self
        result.delegate = self
        result.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        return result
    }()
    
    private lazy var currentWord: UILabel = {
        let label = UILabel()
        label.text = "Top players"
        label.font = .systemFont(ofSize: 20)
        label.textColor = .black
        return label
    }()

    var words: [Word] = []
    var topPlayers: [Player] = []
    let cellID = "playerData"
    
    // MARK: - ViewController life circle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getWords()
        getTopPlayers()
        addConstraints()
    }
    
    // MARK: - Methods
    
    func addConstraints() {
        
        view.addSubview(startNewGame)
        view.addSubview(currentWord)
        view.addSubview(tableTopPlayers)
        
        // Label
        
        currentWord.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            currentWord.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            currentWord.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            currentWord.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        // Button
        
        startNewGame.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            startNewGame.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            startNewGame.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            startNewGame.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
        ])
        
        // Table view
        
        tableTopPlayers.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableTopPlayers.topAnchor.constraint(equalTo: currentWord.bottomAnchor, constant: 30),
            tableTopPlayers.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableTopPlayers.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableTopPlayers.bottomAnchor.constraint(equalTo: startNewGame.topAnchor, constant: -30)
        ])
    }
    
    private func getWords() {
        words = WordsReader.getWords()
    }
    
    private func getTopPlayers() {
        topPlayers = PlayersManager.shared.getTopPlayers()
    }
    
   @objc private func startButtonPressed() {
       currentWord.text = words.randomElement()?.text ?? "No word"
   }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        topPlayers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let player = topPlayers[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = player.name
        content.secondaryText = "\(player.score)"
        cell.contentConfiguration = content
        return cell
    }
}

