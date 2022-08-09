//
//  ViewController.swift
//  AliasLite
//
//  Created by Николай on 04.08.2022.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var startButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 21/255, green: 101/255, blue: 192/255, alpha: 1)
        button.setTitle("Start", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(startButtonPressed), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        addConstraints()
    }
    
    func addConstraints() {
        
        // Button
        
        view.addSubview(startButton)
        
        startButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            startButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    
   @objc func startButtonPressed() {
//       startButton.setTitle("Pressed", for: .normal)
       
       do {
           let words = try WordsReader.getWords()
           print(words)
       }
       catch {
           
       }
   }

}

