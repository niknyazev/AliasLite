//
//  JSONReader.swift
//  AliasLite
//
//  Created by Николай on 08.08.2022.
//

import Foundation

final class JSONWorker {
        
    static let shared = JSONWorker()
    
    private init() { }
    
    func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        guard let data = from else { return nil }
        
        do {
            let objects = try decoder.decode(type.self, from: data)
            return objects
        } catch let jsonError {
            print("Failed to decode JSON", jsonError)
            return nil
        }
    }
    
}
