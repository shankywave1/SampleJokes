//
//  SampleJokesTests.swift
//  SampleJokesTests
//
//  Created by Pran Kishore on 29/08/23.
//

import XCTest
@testable import SampleJokes

final class SampleJokesTests: XCTestCase {

    let diskManager = DiskDataManager(fileName: Constants.jokesFileName)
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        diskManager.delete()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        diskManager.delete()
    }

    func testFixedJokeQueue() throws {
        // GIVEN
        let jokeQueue = JokeQueue(maxSize: Constants.maxJokes)
        
        // WHEN
        for index in 1...100 {
            let joke = Joke(joke: "This is joke number \(index)")
            jokeQueue.enqueue(item: joke)
        }
        
        // THEN
        let firstJoke = try XCTUnwrap(jokeQueue.itemsList.first)
        let lastJoke = try XCTUnwrap(jokeQueue.itemsList.last)
        XCTAssert(firstJoke.joke == "This is joke number 100" )
        XCTAssert(lastJoke.joke == "This is joke number 91" )
        XCTAssert(jokeQueue.itemsList.count == jokeQueue.maxQueueSize)
    }
    
    func testJokeOrderInViewModel() throws {
        // GIVEN
        let jokeViewModel = JokesViewModel(maxJokes: Constants.maxJokes, jokeFileName: Constants.jokesFileName)
        
        // WHEN
        for index in 1...3 {
            let joke = Joke(joke: "This is joke number \(index)")
            jokeViewModel.appendJoke(joke)
        }
        
        // THEN
        // Check the number should be exactly 3
        // Check the last joke that was inserted is the first joke
        XCTAssert(jokeViewModel.numberOfJokes == 3)
        let firstJoke = jokeViewModel.jokeForRow(0)
        let lastJoke = jokeViewModel.jokeForRow(2)
        XCTAssert(firstJoke?.joke == "This is joke number 3" )
        XCTAssert(lastJoke?.joke == "This is joke number 1" )
        
    }

    
    func testSaveJokeAndCorrectOrderPostLoadInViewModel() throws {
        // GIVEN
        var jokeViewModel = JokesViewModel(maxJokes: Constants.maxJokes, jokeFileName: Constants.jokesFileName)
        for index in 1...3 {
            let joke = Joke(joke: "This is joke number \(index)")
            jokeViewModel.appendJoke(joke)
        }
        let firstjokePreSave = jokeViewModel.jokeForRow(0)

        // WHEN
        // Instantiate a new view model but with the same file name
        jokeViewModel = JokesViewModel(maxJokes: Constants.maxJokes, jokeFileName: Constants.jokesFileName)

        // THEN
        // Check the number should be exactly 3
        // Check the last joke that was inserted is the first joke
        // Dates before and after saving the joke should be the same.
        XCTAssert(jokeViewModel.numberOfJokes == 3)
        let firstJoke = jokeViewModel.jokeForRow(0)
        let lastJoke = jokeViewModel.jokeForRow(2)
        XCTAssert(firstJoke?.joke == "This is joke number 3")
        XCTAssert(lastJoke?.joke == "This is joke number 1")
        XCTAssert(firstJoke?.joke == firstjokePreSave?.joke)
        XCTAssert(firstJoke?.displayDate == firstjokePreSave?.displayDate)
    }
}
