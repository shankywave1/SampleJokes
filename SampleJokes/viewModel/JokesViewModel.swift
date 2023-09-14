//
//  JokesViewModel.swift
//  SampleJokes
//
//  Created by Pran Kishore on 02/09/23.
//

import Foundation

class JokesViewModel {

    let maxJokes: Int
    private let jokeQueue: JokeQueue
    private let diskDataManager: DiskDataManager
    private let apiManager: JokeAPICaller

    init(maxJokes: Int, jokeFileName: String, apiManager: JokeAPICaller) {
        self.maxJokes = maxJokes
        self.jokeQueue = JokeQueue(maxSize: maxJokes)
        self.diskDataManager = DiskDataManager(fileName: jokeFileName)
        self.apiManager = apiManager
        loadJokes()
    }

    var numberOfJokes: Int {
        jokeQueue.itemsList.count
    }

    var needsRemovingLastElement: Bool {
        numberOfJokes == maxJokes
    }

    func jokeForRow(_ row: Int) -> Joke? {
        let jokes = jokeQueue.itemsList
        guard row <= jokes.count - 1 else { return nil }
        return jokes[row]
    }

    func appendJoke(_ joke: Joke) {
        jokeQueue.enqueue(item: joke)
        saveJokes()
    }
}

// MARK: - API CAll
extension JokesViewModel {
    func fetchAsyncStreamJokes() -> JokesAsyncSequence {
        JokesAsyncSequence(apiCaller: apiManager)
    }
}

// MARK: - data management
extension JokesViewModel {
    private func saveJokes() {
        diskDataManager.save(jokeQueue.itemsList)
    }

    private func loadJokes() {
        guard let jokes: [Joke] = diskDataManager.load() else { return }
        for joke in jokes.reversed() {
            appendJoke(joke)
        }
    }
}
