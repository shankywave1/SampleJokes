//
//  JokesViewModel.swift
//  SampleJokes
//
//  Created by Pran Kishore on 02/09/23.
//

import Foundation

/// View Model supoprting the logic behind the view controller.
/// Serves the View Contoller with Jokes as and when needed.
/// Manages the saving of jokes to local data persistence mechanism at every new joke fetch.
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

    /// Number of jokes in the list of jokes.
    var numberOfJokes: Int {
        jokeQueue.itemsList.count
    }

    /// retuns if we need to remove the last element from the jokes list. Checks the max number of jokes allowed and the number of jokes in the list.
    var needsRemovingLastElement: Bool {
        numberOfJokes == maxJokes
    }

    /// Returns a joke for the given row number.
    /// - Parameter row: the number of row for which the joke is needed.
    /// - Returns: the Joke. `Joke` is a struct.
    func jokeForRow(_ row: Int) -> Joke? {
        let jokes = jokeQueue.itemsList
        guard row <= jokes.count - 1 else { return nil }
        return jokes[row]
    }

    /// Adds the given joke to the Joke Queue. And also triggers the save method to save the joke locally.
    /// - Parameter joke: `Joke` the struct defining the properties of a joke.
    func appendJoke(_ joke: Joke) {
        jokeQueue.enqueue(item: joke)
        saveJokes()
    }
}

// MARK: - API CAll
extension JokesViewModel {
    /// Creates an asyc stream of Jokes. this async sequence returns a `Joke` every regular interval.
    /// - Returns: a `Joke` item.
    func fetchAsyncStreamJokes() -> JokesAsyncSequence {
        JokesAsyncSequence(apiCaller: apiManager)
    }
}

// MARK: - data management
extension JokesViewModel {

    /// save jokes to local data peristence mechanism.
    private func saveJokes() {
        diskDataManager.save(jokeQueue.itemsList)
    }

    /// Load jokes form the data persistence mechanism if any. the data is loaded into the View Model
    private func loadJokes() {
        guard let jokes: [Joke] = diskDataManager.load() else { return }
        for joke in jokes.reversed() {
            appendJoke(joke)
        }
    }
}
