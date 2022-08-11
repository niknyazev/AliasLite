//
//  CurrentSessionViewController.swift
//  AliasLite
//
//  Created by Николай on 10.08.2022.
//

import UIKit

class CurrentSessionViewController: UIViewController {

    private lazy var guessWordButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 21/255, green: 101/255, blue: 192/255, alpha: 1)
        button.setTitle("New game", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 4
//        button.addTarget(self, action: #selector(startNewGamePressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var dropWordButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 21/255, green: 101/255, blue: 192/255, alpha: 1)
        button.setTitle("New game", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 4
//        button.addTarget(self, action: #selector(startNewGamePressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var pauseButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 21/255, green: 101/255, blue: 192/255, alpha: 1)
        button.setTitle("New game", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 4
//        button.addTarget(self, action: #selector(startNewGamePressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var finishButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 21/255, green: 101/255, blue: 192/255, alpha: 1)
        button.setTitle("New game", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 4
//        button.addTarget(self, action: #selector(startNewGamePressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var currentWordLabel: UILabel = {
        let label = UILabel()
        label.text = "Any word"
        label.font = .systemFont(ofSize: 20)
        label.textColor = .black
        return label
    }()
    
    private lazy var playerName: UILabel = {
        let label = UILabel()
        label.text = "User name"
        label.font = .systemFont(ofSize: 30)
        label.textColor = .black
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
    }

}
