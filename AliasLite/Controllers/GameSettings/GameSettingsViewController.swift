//
//  GameSettingsViewController.swift
//  AliasLite
//
//  Created by Николай on 10.08.2022.
//

import UIKit

class GameSettingsViewController: UIViewController {
    
    let cellID = "player"
    
    private let viewModel: GameSettingsViewModelProtocol = GameSettingsViewModel()
    
    private lazy var playersTable: UITableView = {
        let result = UITableView()
        result.dataSource = self
        result.delegate = self
        result.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        return result
    }()
    
    private lazy var tableDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Choose the players:"
        label.font = .systemFont(ofSize: 20)
        label.textColor = .black
        return label
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
        addConstraints()
        setupElements()
    }
    
    private func setupElements() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewPlayer)
        )
        
        title = "New game"
        view.backgroundColor = .white
    }
    
    @objc private func addNewPlayer() {
        
        let alertController = UIAlertController(
            title: "Add new Player",
            message: "Enter the player name",
            preferredStyle: .alert
        )

        alertController.addTextField { textField in
            textField.placeholder = "Name"
        }

        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let newValue = alertController.textFields?.first?.text else { return }
            self.viewModel.savePlayer(name: newValue)
            self.playersTable.reloadData()
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)

        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
    
    private func addConstraints() {
        
        view.addSubview(startGame)
        view.addSubview(playersTable)
        view.addSubview(tableDescriptionLabel)
                
        // Table description
        
        tableDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableDescriptionLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            tableDescriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableDescriptionLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 100)
        ])
        
        // Button
        
        startGame.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            startGame.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            startGame.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            startGame.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
        ])
        
        // Table players
        
        playersTable.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            playersTable.topAnchor.constraint(equalTo: tableDescriptionLabel.bottomAnchor, constant: 10),
            playersTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            playersTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            playersTable.bottomAnchor.constraint(equalTo: startGame.topAnchor, constant: -50)
        ])
    }
    
    @objc private func startGamePressed() {
        let gameSession = UINavigationController(rootViewController: CurrentSessionViewController())
        gameSession.modalPresentationStyle = .fullScreen
        present(gameSession, animated: true)
    }

}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension GameSettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.playersCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = viewModel.getPlayerName(index: indexPath.row)
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
