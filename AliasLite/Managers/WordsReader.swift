//
//  WordsReader.swift
//  AliasLite
//
//  Created by Николай on 09.08.2022.
//

import Foundation

final class WordsReader {
    
    static let shared = WordsReader()
    
    func getWords() -> [WordJson] {
        
        guard let path = Bundle.main.path(forResource: "Words", ofType: "json") else {
            return []
        }
        
        let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        
        guard let data = data else {
            return []
        }
        
        let words = JSONWorker.shared.decodeJSON(type: [WordJson].self, from: data)
        
        if let result = words {
            return result
        } else {
            return []
        }
    }
}
