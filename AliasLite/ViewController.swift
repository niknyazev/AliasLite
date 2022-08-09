//
//  ViewController.swift
//  AliasLite
//
//  Created by Николай on 04.08.2022.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var getWordButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 21/255, green: 101/255, blue: 192/255, alpha: 1)
        button.setTitle("Press to get the Word", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(startButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var currentWord: UILabel = {
        let label = UILabel()
        label.text = "Word"
        label.font = .systemFont(ofSize: 20)
        label.textColor = .black
        return label
    }()

    var words: [Word] = []
    
    // MARK: - ViewController life circle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getWords()
        addConstraints()
    }
    
    // MARK: - Methods
    
    func addConstraints() {
        
        // Button
        
        view.addSubview(getWordButton)
        view.addSubview(currentWord)
        
        getWordButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            getWordButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            getWordButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            getWordButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        // Label
        
        currentWord.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            currentWord.topAnchor.constraint(equalTo: getWordButton.bottomAnchor, constant: 50),
            currentWord.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            currentWord.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func getWords() {
        words = WordsReader.getWords()
    }
    
   @objc private func startButtonPressed() {
       currentWord.text = words.randomElement()?.text ?? "No word"
   }
}

