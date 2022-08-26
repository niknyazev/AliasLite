//
//  CurrentSessionViewModel.swift
//  AliasLite
//
//  Created by Николай on 22.08.2022.
//

import Foundation

protocol CurrentSessionViewModelProtocol {
    var playerName: String { get }
    var currentWord: String { get }
    var wordsDropped: Int { get }
    var wordsGuessed: Int { get }
    func nextWord()
}

class CurrentSessionViewModel: CurrentSessionViewModelProtocol {
    
    var playerName: String = "Test player"
    var currentWord: String = "Press start"
    var wordsDropped: Int = 10
    var wordsGuessed: Int = 10
    
    func nextWord() {
        
    }
}
