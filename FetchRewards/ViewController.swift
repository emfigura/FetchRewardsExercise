//
//  ViewController.swift
//  FetchRewards
//
//  Created by Eric Figura on 9/26/20.
//  Copyright © 2020 FetchRewards. All rights reserved.
//

import UIKit

class DisplayItemsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        FetchRewardsAPI.shared.get(router: .GetItems) { (result: Result<[Item], Error>) in
            switch result {
            case .success(let items):
                print(items)
            case .failure(let error):
                print(error)
            }
        }
        
    }
}

