//
//  GameListViewController.swift
//  SimpleAppWithMoya
//
//  Created by Viennarz Curtiz on 5/4/21.
//

import UIKit

class GameListViewController: UITableViewController {
    var items: [GameItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableView.automaticDimension
        
        let worker = FakeWorker()
        worker.fetchGames { (result) in
            
            switch result {
            
            case .success(let list):
                self.items = list
                self.tableView.reloadData()
                
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = items[indexPath.row].title + " is \(items[indexPath.row].description)"
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        
        cell.detailTextLabel?.numberOfLines = 0
        cell.detailTextLabel?.lineBreakMode = .byWordWrapping
        
        return cell
    }
}
