//
//  GameSettingsViewController.swift
//  AliasLite
//
//  Created by Николай on 10.08.2022.
//

import UIKit

class GameSettingsViewController: UITableViewController {
    
    let cellID = "player"
    
    private let viewModel: GameSettingsViewModelProtocol = GameSettingsViewModel()
        
    private lazy var tableDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Choose the players:"
        label.font = .systemFont(ofSize: 20)
        label.textColor = .black
        return label
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
        
        title = "New game settings"
        view.backgroundColor = .white
        
        tableView = UITableView(frame: CGRect.zero, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
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
//            self.playersTable.reloadData()
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)

        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
    
    private func changeSessionDuration() {
        
        let alertController = UIAlertController(
            title: nil,
            message: "Enter the duration of session",
            preferredStyle: .alert
        )

        alertController.addTextField { textField in
            textField.placeholder = "Duration"
        }

        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let newValue = alertController.textFields?.first?.text else { return }
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
    
    private func addConstraints() {
        
//        view.addSubview(startGame)
//        view.addSubview(playersTable)
//        view.addSubview(tableDescriptionLabel)
//
//        // Table description
//
//        tableDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            tableDescriptionLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
//            tableDescriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            tableDescriptionLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 100)
//        ])
        
        // Button
        
//        startGame.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            startGame.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
//            startGame.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
//            startGame.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
//        ])
        
//        // Table players
//
//        playersTable.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            playersTable.topAnchor.constraint(equalTo: tableDescriptionLabel.bottomAnchor, constant: 10),
//            playersTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            playersTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            playersTable.bottomAnchor.constraint(equalTo: startGame.topAnchor, constant: -50)
//        ])
    }
    
    private func startGamePressed() {
        let gameSession = UINavigationController(rootViewController: CurrentSessionViewController())
        gameSession.modalPresentationStyle = .fullScreen
        present(gameSession, animated: true)
    }

}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension GameSettingsViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return viewModel.playersCount
        } else {
            return 1
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Select the players:"
        }
        
        return nil
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        var content = cell.defaultContentConfiguration()
        
        if indexPath.section == 0 {
            content.text = viewModel.getPlayerName(index: indexPath.row)
            cell.selectionStyle = .none
            cell.contentConfiguration = content
        } else if indexPath.section == 1 {
            content.text = "Session time"
            cell.contentConfiguration = content
        } else {
            content.text = "Start"
            cell.contentConfiguration = content
            cell.tintColor = .blue
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            
            let cell = tableView.cellForRow(at: indexPath)
            
            guard let cell = cell else {
                return
            }
            
            cell.accessoryType = (cell.accessoryType == .checkmark ? .none : .checkmark)
            
        } else if indexPath.section == 1 {
            changeSessionDuration()
        } else {
            startGamePressed()
        }
    }
}
