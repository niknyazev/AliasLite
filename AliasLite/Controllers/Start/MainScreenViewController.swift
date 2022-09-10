//
//  ViewController.swift
//  AliasLite
//
//  Created by Николай on 04.08.2022.
//

import UIKit

class MainScreenViewController: UIViewController {
    
    // MARK: - Properties
    
    private var viewModel: MainScreenViewModelProtocol!
    
    private lazy var startNewGame: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 21/255, green: 101/255, blue: 192/255, alpha: 1)
        button.setTitle("New game", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(startNewGamePressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var tableTopPlayers: UITableView = {
        let result = UITableView()
        result.dataSource = self
        result.delegate = self
        result.register(PlayerCell.self, forCellReuseIdentifier: PlayerCell.cellId)
        result.register(ButtonCell.self, forCellReuseIdentifier: ButtonCell.cellId)
        return result
    }()
        
    // MARK: - ViewController life circle
    
    override func loadView() {
        super.loadView()
        // TODO: need fill this method with viewDidLoad body?
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = MainScreenViewModel()
        addConstraints()
        setupElements()
    }
    
    // MARK: - Private methods
    
    private func setupElements() {
        title = viewModel.viewTitle
        view.backgroundColor = .white
    }
    
    private func addConstraints() {
        
        view.addSubview(startNewGame)
        view.addSubview(tableTopPlayers)
                
        // Button
        
        startNewGame.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            startNewGame.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            startNewGame.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startNewGame.widthAnchor.constraint(greaterThanOrEqualToConstant: 170)
        ])
        
        // Table view
        
        tableTopPlayers.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableTopPlayers.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableTopPlayers.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableTopPlayers.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableTopPlayers.bottomAnchor.constraint(equalTo: startNewGame.topAnchor, constant: -30)
        ])
    }
    
    @objc private func startNewGamePressed() {
        let gameSettings = GameSettingsViewController()
        navigationController?.pushViewController(gameSettings, animated: true)
    }
}

extension MainScreenViewController: UITableViewDataSource, UITableViewDelegate {
   
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        viewModel.title(for: section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.playersCount(for: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: PlayerCell.cellId, for: indexPath)
        let player = viewModel.getPlayerData(for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = player.name
        content.secondaryText = "\(player.score)"
        content.image = UIImage(named: "flat") // TODO: remove this mock
        content.imageProperties.maximumSize = CGSize(width: 40, height: 40)
        content.imageProperties.cornerRadius = 20
        cell.contentConfiguration = content
        return cell
    }
}

// TODO: Move to another file
class PlayerCell: UITableViewCell {
    
    static let cellId = "playerData"
   
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

