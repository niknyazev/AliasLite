//
//  GameSettingsViewController.swift
//  AliasLite
//
//  Created by Николай on 10.08.2022.
//

import UIKit

class GameSettingsViewController: UIViewController {
    
    let players = PlayersManager.shared.getTopPlayers()
    let cellID = "player"
    
    private lazy var playersTable: UITableView = {
        let result = UITableView()
        result.dataSource = self
        result.delegate = self
        result.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        return result
    }()

    private lazy var startGame: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 21/255, green: 101/255, blue: 192/255, alpha: 1)
        button.setTitle("New game", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(startGamePressed), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        addConstraints()

        // Do any additional setup after loading the view.
    }
    
    private func addConstraints() {
        
        view.addSubview(startGame)
        view.addSubview(playersTable)
                
        // Button
        
        startGame.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            startGame.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            startGame.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            startGame.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
        ])
        
        playersTable.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            playersTable.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            playersTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            playersTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            playersTable.bottomAnchor.constraint(equalTo: startGame.topAnchor, constant: -50)
        ])
    }
    
    @objc private func startGamePressed() {
        let gameSettings = CurrentSessionViewController()
        gameSettings.modalPresentationStyle = .fullScreen
        present(gameSettings, animated: true)
    }

}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension GameSettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let player = players[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = player.name
        cell.selectionStyle = .none
        cell.contentConfiguration = content
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        
        guard let cell = cell else {
            return
        }
        
        cell.accessoryType = (cell.accessoryType == .checkmark ? .none : .checkmark)
    }
}
