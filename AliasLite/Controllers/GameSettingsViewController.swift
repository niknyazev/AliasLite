//
//  GameSettingsViewController.swift
//  AliasLite
//
//  Created by Николай on 10.08.2022.
//

import UIKit

class GameSettingsViewController: UIViewController {

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
                
        // Button
        
        startGame.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            startGame.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            startGame.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            startGame.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
        ])

    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @objc private func startGamePressed() {
        let gameSettings = CurrentSessionViewController()
        gameSettings.modalPresentationStyle = .fullScreen
        present(gameSettings, animated: true)
    }

}
