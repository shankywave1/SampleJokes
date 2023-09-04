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
    let mockJokeAPICaller = MockJokeAPICall()
    
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
        let jokeViewModel = JokesViewModel(maxJokes: Constants.maxJokes, jokeFileName: Constants.jokesFileName, apiManager: mockJokeAPICaller)
        
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
    
    func testJokeModelNeedsRemoval() throws {
        // GIVEN
        let jokeViewModel = JokesViewModel(maxJokes: Constants.maxJokes, jokeFileName: Constants.jokesFileName, apiManager: mockJokeAPICaller)
        
        // WHEN
        for index in 1...20 {
            let joke = Joke(joke: "This is joke number \(index)")
            jokeViewModel.appendJoke(joke)
            // THEN
            if index < 10 {
                XCTAssertFalse(jokeViewModel.needsRemovingLastElement)
            } else {
                XCTAssertTrue(jokeViewModel.needsRemovingLastElement)
            }
        }
    }

    
    func testSaveJokeAndCorrectOrderPostLoadInViewModel() throws {
        // GIVEN
        var jokeViewModel = JokesViewModel(maxJokes: Constants.maxJokes, jokeFileName: Constants.jokesFileName, apiManager: mockJokeAPICaller)
        for index in 1...3 {
            let joke = Joke(joke: "This is joke number \(index)")
            jokeViewModel.appendJoke(joke)
        }
        let firstjokePreSave = jokeViewModel.jokeForRow(0)

        // WHEN
        // Instantiate a new view model but with the same file name
        jokeViewModel = JokesViewModel(maxJokes: Constants.maxJokes, jokeFileName: Constants.jokesFileName, apiManager: mockJokeAPICaller)

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
    
    func testAsyncJokeSequence() async throws {
        // GIVEN
        let jokeViewModel = JokesViewModel(maxJokes: Constants.maxJokes, jokeFileName: Constants.jokesFileName, apiManager: mockJokeAPICaller)
        var numberofJokes = 0
        
        // WHEN
        let asyncJokeSequence = jokeViewModel.fetchAsyncStreamJokes()
        for try await joke in asyncJokeSequence {
            jokeViewModel.appendJoke(Joke(joke: joke))
            numberofJokes += 1
            if numberofJokes == Constants.maxJokes {
                break
            }
        }
        
        // THEN
        // Check the number should be exactly 10
        XCTAssert(jokeViewModel.numberOfJokes == 10)
    }
    
    func testEmptyJoke() async throws {
        // GIVEN
        let jokeViewModel = JokesViewModel(maxJokes: Constants.maxJokes, jokeFileName: Constants.jokesFileName, apiManager: mockJokeAPICaller)
        
        // WHEN
        // Empty View Model No Joke Present
        
        // THEN
        // Check there are no jokes
        let joke = jokeViewModel.jokeForRow(0)
        XCTAssert(joke == nil)
    }
}


struct MockJokeAPICall: JokeAPICaller {
    var timeInterval: UInt64 {
        1_000_000
    }
    
    func getJokes() async throws -> String {
        try await Task.sleep(nanoseconds: timeInterval)
        return "Best Joke of my life"
    }
}
