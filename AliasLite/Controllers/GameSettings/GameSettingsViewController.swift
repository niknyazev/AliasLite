//
//  GameSettingsViewController.swift
//  AliasLite
//
//  Created by Николай on 10.08.2022.
//

import UIKit

class GameSettingsViewController: UITableViewController {
    
    let playerCellID = "player"
    let buttonCellID = "button"
    let valueCellID = "value"
    
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: playerCellID)
        tableView.register(ButtonCell.self, forCellReuseIdentifier: buttonCellID)
        tableView.register(ValueCell.self, forCellReuseIdentifier: valueCellID)
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
            message: "Enter duration of session",
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
        
    private func startGamePressed() {
        let gameSession = UINavigationController(rootViewController: CurrentSessionViewController())
        gameSession.modalPresentationStyle = .fullScreen
        present(gameSession, animated: true)
    }

}

class ButtonCell: UITableViewCell {
    
    private lazy var startLabel: UILabel = {
        let label = UILabel()
        label.text = "Start"
        label.font = .systemFont(ofSize: 18)
        label.textColor = .white
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        
        backgroundColor = UIColor(red: 21/255, green: 101/255, blue: 192/255, alpha: 1)
        
        contentView.addSubview(startLabel)

        startLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            startLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            startLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}

class ValueCell: UITableViewCell {
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value2, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension GameSettingsViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return viewModel.playersCount
        } else if section == 1 {
            return 2
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
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: playerCellID, for: indexPath)
            var content = cell.defaultContentConfiguration()
            
            content.text = viewModel.getPlayerName(index: indexPath.row)
            cell.selectionStyle = .none
            cell.contentConfiguration = content
            
            return cell
            
        } else if indexPath.section == 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: valueCellID, for: indexPath)
            var content = cell.defaultContentConfiguration()
            
            content.text = viewModel.sessionSettings[indexPath.row].settingName
            content.secondaryText = viewModel.sessionSettings[indexPath.row].settingValue
            
            cell.contentConfiguration = content
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: buttonCellID, for: indexPath)
            return cell
        }
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
