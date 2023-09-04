//
//  Joke.swift
//  SampleJokes
//
//  Created by Pran Kishore on 29/08/23.
//

import Foundation

/// Easily throw generic errors with a text description.
extension String: Error { }

struct Joke: Codable {
    // String representing a Geeky Joke
    let joke: String
    let date: Date

    init(joke: String) {
        self.joke = joke
        self.date = Date()
    }
}

extension Joke {
    var displayDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy 'at' hh:mm:ss a"
        return dateFormatter.string(from: date)
    }
}

struct Constants {
    /// Maximun number of jokes allowed to store / save in UI
    static let maxJokes = 10

    /// Time interval between fetching of two Jokes in seconds. As per business definition it is one second.
    static let jokeFetchTimeIntervalSec: UInt64 = 1_000_000_000_0

    /// File name which is used to store the jokes
    static let jokesFileName = "Jokes"
}
