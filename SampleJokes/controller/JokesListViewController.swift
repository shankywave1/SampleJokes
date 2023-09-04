//
//  ViewController.swift
//  SampleJokes
//
//  Created by Pran Kishore on 29/08/23.
//

import UIKit

class JokesListViewController: UITableViewController {

    var viewModel: JokesViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Unlimint Jokes"
        setupNavigationBar()
        setupTableView()
        viewModel = JokesViewModel(maxJokes: Constants.maxJokes,
                                   jokeFileName: Constants.jokesFileName,
                                   apiManager: JokeAPICall(timeInterval: Constants.jokeFetchTimeIntervalSec))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupJokesStream()
    }

    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: SJColorType.darkGreen.color]
        appearance.largeTitleTextAttributes = [.foregroundColor: SJColorType.darkGreen.color]
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .black
        
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
    }
    
    private func setupTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        tableView.backgroundColor = .black
        tableView.register(JokeTableViewCell.self, forCellReuseIdentifier: "JokeTableViewCell")
    }
    
    func updateTableView(with joke: String) {
        tableView.beginUpdates()
        // Remove the last only if we have reached the max capacity
        if viewModel.needsRemovingLastElement {
            self.tableView.deleteRows(at: [IndexPath(row: Constants.maxJokes - 1, section: 0)], with: .none)
        }
        viewModel.appendJoke(Joke(joke: joke))
        // Update the table view
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .none)
        tableView.endUpdates()
    }
}

// MARK: - Table View Data Source
extension JokesListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfJokes
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JokeTableViewCell", for: indexPath) as! JokeTableViewCell
        let joke = viewModel.jokeForRow(indexPath.row)
        cell.lblTitle.text = joke?.joke
        cell.lblDetail.text = joke?.displayDate
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Check if the cell is your custom cell class.
        // And we want to animate the first cell only.
        if let customCell = cell as? JokeTableViewCell, indexPath.row == 0 {
            AnimationFactory.animateWithSpringBehaviour(customCell.containerView)
        }
    }
    
}

// MARK: - JokesViewModelDelegate
extension JokesListViewController {
    func setupJokesStream() {
        Task(priority: .background) { [weak self] in
            guard let self = self else {return}
            let jokeStream = viewModel.fetchAsyncStreamJokes()
            for try await joke in jokeStream {
                await MainActor.run {
                    self.updateTableView(with: joke)
                }
            }
        }
    }
}
