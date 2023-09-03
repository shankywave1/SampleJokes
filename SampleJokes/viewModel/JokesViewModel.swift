//
//  JokesViewModel.swift
//  SampleJokes
//
//  Created by Pran Kishore on 02/09/23.
//

import Foundation

protocol JokesViewModelDelegate: AnyObject {
    func didUpdate(with joke: String)
}


class JokesViewModel {

    let maxJokes: Int
    weak var delegate: JokesViewModelDelegate?
    private let jokeQueue: JokeQueue
    private let diskDataManager: DiskDataManager
    private let apiManager = JokeAPICall()
    
    init(maxJokes: Int, jokeFileName: String) {
        self.maxJokes = maxJokes
        self.jokeQueue = JokeQueue(maxSize: maxJokes)
        self.diskDataManager = DiskDataManager(fileName: jokeFileName)
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
    func fetchJokes() {
        let workItem = DispatchWorkItem {
            self.fetchJokes()
        }
        apiManager.getJoke { aJoke in
            if let joke = aJoke {
                self.delegate?.didUpdate(with: joke)
            }
            DispatchQueue.global().asyncAfter(deadline: (.now() + .milliseconds(1000*10)), execute: workItem)
        }
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
