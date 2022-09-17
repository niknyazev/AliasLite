//
//  Extension + Player.swift
//  AliasLite
//
//  Created by Николай on 17.09.2022.
//

import Foundation

extension Player {
    var currentScores: Int {
        guard let log = log else {
            return 0
        }
                
        let result = log.reduce(into: 0) { partialResult, logData in
            let data = logData as! GameLog
            partialResult += data.guessed ? 1 : -1
        }
        
        return result < 0 ? 0 : result
    }
}
