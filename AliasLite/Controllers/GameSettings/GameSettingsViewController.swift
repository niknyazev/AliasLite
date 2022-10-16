//
//  GameSettingsViewController.swift
//  AliasLite
//
//  Created by Николай on 10.08.2022.
//

import UIKit

class GameSettingsViewController: UITableViewController {
    
    let playerCellID = "player"
    let valueCellID = "value"
    private var isEnabled: Bool = true
    
    private var viewModel: GameSettingsViewModelProtocol!
    
    convenience init(isEnabled: Bool = true) {
        self.init(style: .grouped)
        self.isEnabled = isEnabled
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
        setupViewModel()
    }
    
    private func setupViewModel() {
        viewModel = GameSettingsViewModel()
        viewModel.viewDidChange = {
            self.tableView.reloadData()
        }
    }
    
    private func setupElements() {
            
        if isEnabled {
            addNewPlayerButton()
        }
        
        title = "New game settings"
        view.backgroundColor = .white
        
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: playerCellID)
        tableView.register(ButtonCell.self, forCellReuseIdentifier: ButtonCell.cellId)
        tableView.register(ValueCell.self, forCellReuseIdentifier: valueCellID)
    }
    
    private func addNewPlayerButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewPlayer)
        )
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
            guard let name = alertController.textFields?.first?.text else { return }
            self.viewModel.savePlayer(name: name)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)

        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
    
    private func changeValue(for settingsIndex: Int) {
        
        let currentSettings = viewModel.sessionSettings[settingsIndex]
        
        let alertController = UIAlertController(
            title: nil,
            message: currentSettings.alertTitle,
            preferredStyle: .alert
        )

        alertController.addTextField { textField in
            textField.placeholder = currentSettings.title
            textField.text = currentSettings.valueTitle
        }

        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let newValue = alertController.textFields?.first?.text else { return }
            currentSettings.value = Int(newValue) ?? 0
            self.tableView.reloadRows(at: [IndexPath(row: settingsIndex, section: 1)], with: .none)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
        
    private func startGamePressed() {
        viewModel.saveGameSettings()
        let gameSession = UINavigationController(rootViewController: CurrentSessionViewController())
        gameSession.modalPresentationStyle = .fullScreen
        present(gameSession, animated: true)
    }

}

class ButtonCell: UITableViewCell {
    
    static let cellId = "button"
    
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
        
        switch section {
        case 0:
            return viewModel.playersCount
        case 1:
            return viewModel.sessionSettings.count
        default:
            return 1
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        isEnabled ? 3 : 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Select the players:"
        }
        
        return nil
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: playerCellID, for: indexPath)
            var content = cell.defaultContentConfiguration()
            
            content.text = viewModel.getPlayerName(index: indexPath.row)
            cell.selectionStyle = .none
            cell.contentConfiguration = content
            
            cell.accessoryType = viewModel.isPlayerSelected(index: indexPath.row)
                ? .checkmark
                : .none
            
            return cell
            
        case 1:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: valueCellID, for: indexPath)
            var content = cell.defaultContentConfiguration()
            
            content.text = viewModel.sessionSettings[indexPath.row].title
            content.secondaryText = viewModel.sessionSettings[indexPath.row].valueTitle
            
            cell.contentConfiguration = content
            
            return cell
            
        default:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: ButtonCell.cellId, for: indexPath)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if !isEnabled {
            return
        }
        
        switch indexPath.section {
        case 0:
            
            let cell = tableView.cellForRow(at: indexPath)
            
            guard let cell = cell else {
                return
            }
            
            viewModel.selectPlayer(index: indexPath.row)
            
            cell.accessoryType = viewModel.isPlayerSelected(index: indexPath.row)
                ? .checkmark
                : .none
            
        case 1:
            changeValue(for: indexPath.row)
            tableView.deselectRow(at: indexPath, animated: true)
        default:
            startGamePressed()
        }
    }
}
