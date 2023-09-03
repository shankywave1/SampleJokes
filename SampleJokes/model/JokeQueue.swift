//
//  JokeQueue.swift
//  SampleJokes
//
//  Created by Pran Kishore on 02/09/23.
//

import Foundation

/// It is based on the concept of Queue where the element is  added to the front instead at the end and when the fixed size of the queue is reached the oldest item. i.e. the one at the end is discarded.
/// A fixed size Queue where the max capacity of elements in the queue is defined.
protocol FixedSizeQueue {
    associatedtype Element
    
    /// Helps add the element to the queue.
    /// - Parameter item: any generic item accepted by the queue.
    func enqueue(item: Element)
    
    /// gives the current status of the queue
    var itemsList: [Element] {get}
    
    
    /// gives the max queue size.
    var maxQueueSize: Int {get}
}

/// Represents the joke queue, conforms to the fixed size queue protocol, accepts the max size of the queue during intialization. which can't be altered later.
class JokeQueue: FixedSizeQueue {
    private var items: [Joke]
    private let maxSize: Int
    
    init(maxSize: Int) {
        self.maxSize = maxSize
        self.items = [Joke]()
    }
    
    func enqueue(item: Joke) {
        if items.count == maxSize {
            items.removeLast()
        }
        items.insert(item, at: 0)
    }
    
    var itemsList: [Joke] {
        items
    }
    
    var maxQueueSize: Int {
        maxSize
    }
}
