//
//  JokeAPICall.swift
//  SampleJokes
//
//  Created by Pran Kishore on 03/09/23.
//

import Foundation

protocol JokeAPICaller {
    var timeInterval: UInt64 {get}
    func getJokes() async throws -> String
}

struct JokeAPICall: JokeAPICaller {
    let timeInterval: UInt64
    
    func getJokes() async throws -> String {
        guard let url = URL(string: "https://geek-jokes.sameerkumar.website/api") else {
            throw "The URL could not be created."
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw "The server responded with an error."
        }
        let result = try JSONDecoder().decode(String.self, from: data)
        try await Task.sleep(nanoseconds: timeInterval)
        return result
    }
}
