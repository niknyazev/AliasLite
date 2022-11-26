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
    private let buttonHeight: CGFloat = 46
    
    private lazy var startGameButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 21/255, green: 101/255, blue: 192/255, alpha: 1)
        button.setTitle("New game", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(startNewGamePressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var continueButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 21/255, green: 101/255, blue: 192/255, alpha: 1)
        button.setTitle("Continue game", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(continueGamePressed), for: .touchUpInside)
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
    
    private lazy var labelNoPlayersYet: UILabel = {
        let label = UILabel()
        label.text = "No games yet"
        label.font = .systemFont(ofSize: 20)
        label.textColor = .gray
        label.isHidden = true
        return label
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        startGameButton.layer.cornerRadius = startGameButton.frame.height / 2
        continueButton.layer.cornerRadius = continueButton.frame.height / 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.updateData()
        tableTopPlayers.reloadData()
        labelNoPlayersYet.isHidden = viewModel.numberOfSections == 0
        setupContinueButton()
    }
    
    // MARK: - Private methods
    
    private func setupContinueButton() {
        continueButton.isEnabled = viewModel.numberOfSections == 2
        continueButton.alpha = continueButton.isEnabled ? 1 : 0.2
    }
    
    private func setupElements() {
        title = viewModel.viewTitle
        view.backgroundColor = .white
        setupContinueButton()
    }
    
    private func addConstraints() {
        
        view.addSubview(startGameButton)
        view.addSubview(continueButton)
        view.addSubview(tableTopPlayers)
        view.addSubview(labelNoPlayersYet)
        
        // Buttons
        
        let buttonHeight: CGFloat = 40
        let buttonWidth: CGFloat = 250
        
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            continueButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            continueButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    
        startGameButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            startGameButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            startGameButton.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: -15),
            startGameButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            startGameButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        // Table view
        
        tableTopPlayers.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableTopPlayers.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableTopPlayers.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableTopPlayers.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableTopPlayers.bottomAnchor.constraint(equalTo: startGameButton.topAnchor, constant: -30)
        ])
        
        labelNoPlayersYet.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            labelNoPlayersYet.centerYAnchor.constraint(equalTo: tableTopPlayers.centerYAnchor),
            labelNoPlayersYet.centerXAnchor.constraint(equalTo: tableTopPlayers.centerXAnchor)
        ])
    }
    
    @objc private func startNewGamePressed() {
        viewModel.removeOldGameData()
        let gameSettings = GameSettingsViewController()
        navigationController?.pushViewController(gameSettings, animated: true)
    }
    
    @objc private func continueGamePressed() {
        let gameSession = UINavigationController(rootViewController: CurrentSessionViewController())
        gameSession.modalPresentationStyle = .fullScreen
        present(gameSession, animated: true)
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
        content.secondaryText = indexPath.section == 0
            ? "\(player.score)"
            : "\(player.currentGameScores)"
        // TODO: remove this array
        content.image = UIImage(named: player.imageName) // TODO: remove this mock
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

