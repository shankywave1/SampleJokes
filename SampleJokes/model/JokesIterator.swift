//
//  JokesIterator.swift
//  SampleJokes
//
//  Created by Pran Kishore on 04/09/23.
//

import Foundation


struct JokesAsyncSequence: AsyncSequence {
    typealias Element = String
    
    let apiCaller: JokeAPICaller
    
    func makeAsyncIterator() -> JokesIterator {
        return JokesIterator(apiCaller: apiCaller)
    }
}

struct JokesIterator: AsyncIteratorProtocol {
    typealias Element = String
    
    private let apiCaller: JokeAPICaller
    private var shouldFetchJokes: Bool
    
    init(apiCaller: JokeAPICaller, shouldFetchJokes: Bool = true) {
        self.apiCaller = apiCaller
        self.shouldFetchJokes = shouldFetchJokes
    }
    
    mutating func stopJokeFetch() {
        shouldFetchJokes = false
    }
    
    func next() async throws -> String? {
        guard shouldFetchJokes else { return nil }
        return try await apiCaller.getJokes()
    }
}
