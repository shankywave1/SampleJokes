//
//  DiskDataManager.swift
//  SampleJokes
//
//  Created by Pran Kishore on 02/09/23.
//

import Foundation

struct DiskDataManager {
    
    let fileName: String

    private var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func save<T: Codable>(_ object: T) {
        let url = documentsDirectory.appendingPathComponent(fileName)
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(object) {
            try? encoded.write(to: url, options: .atomicWrite)
        }
    }
    
    func load<T: Codable>() -> T? {
        let url = documentsDirectory.appendingPathComponent(fileName)
        let decoder = JSONDecoder()
        if let data = try? Data(contentsOf: url),
           let decoded = try? decoder.decode(T.self, from: data) {
            return decoded
        }
        return nil
    }
    
    // Delete a file
    func delete () {
        let url = documentsDirectory.appendingPathComponent(fileName, isDirectory: false)
        if FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.removeItem(at: url)
            }catch{
                fatalError(error.localizedDescription)
            }
        }
    }
}
