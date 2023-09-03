//
//  JokeAPICall.swift
//  SampleJokes
//
//  Created by Pran Kishore on 03/09/23.
//

import Foundation

struct JokeAPICall {
    func getJoke(_ completion: @escaping (String?) -> Void) {
        let url = URL(string: "https://geek-jokes.sameerkumar.website/api")!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                completion(nil)
                return
            }
            
            if let responseString = String(data: data, encoding: .utf8) {
                completion(responseString)
            } else {
                print("Unable to convert data to string")
                completion(nil)
            }
        }
        task.resume()
    }
}
