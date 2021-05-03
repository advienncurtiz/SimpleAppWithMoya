//
//  ViewController.swift
//  SimpleAppWithMoya
//
//  Created by Viennarz Curtiz on 5/3/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let worker = FakeWorker()
        worker.fetchGames { (result) in
            
            switch result {
            
            case .success(let list):
                debugPrint(list)
                
            case .failure(let error):
                debugPrint(error)
            }
        }
    }


}

