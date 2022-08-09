//
//  WordsReader.swift
//  AliasLite
//
//  Created by Николай on 09.08.2022.
//

import Foundation

class WordsReader {
    
    static func getWords() throws -> [Word] {
        
        guard let path = Bundle.main.path(forResource: "Words", ofType: "json") else {
            return []
        }
        
        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        let words = JSONWorker.shared.decodeJSON(type: [Word].self, from: data)
        
        if let result = words {
            return result
        } else {
            return []
        }
    }
}
