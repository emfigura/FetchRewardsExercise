//
//  DisplayItemsViewController.swift
//  FetchRewards
//
//  Created by Eric Figura on 9/26/20.
//  Copyright © 2020 FetchRewards. All rights reserved.
//

import UIKit

/**
 I decided to go with the MVP pattern. It's definitely overkill for something simple but for an exercise project it shows a bit more of a design vs MVC.
 */
protocol DisplayItemsView: class {
    func getItemsSuccess(items: [DisplayItemsViewController.DisplayItem])
    func getItemsError(error: Error)
    func showSpinner()
    func hideSpinner()
}

class DisplayItemsViewController: UIViewController {
    
    struct DisplayItem: Equatable {
        let listId: String
        let name: String
        
        static func == (lhs: DisplayItem, rhs: DisplayItem) -> Bool {
            return lhs.listId == rhs.listId && lhs.name == rhs.name
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    /**
    I did this as a protocol for testing. I think the logic in the view controller is simple enough that it's not really testable. I could test with UITests but the prompt said not to spend more than a few hours on the project.
     */
    let presenter: DisplayItemsPresenterInterface = DisplayItemsPresenter()
    
    var displayItems: [DisplayItem]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.register(UINib(nibName: "DisplayItemTableViewCell", bundle: nil),
                           forCellReuseIdentifier: DisplayItemTableViewCell.reuseId)
        
        //Attaching the view controller as the delegate to the presenter
        presenter.attachView(view: self)
        //This is where the service call is made
        presenter.getItems()
        
    }
}

// The return calls from the presenter's service call
extension DisplayItemsViewController: DisplayItemsView {
    func getItemsSuccess(items: [DisplayItem]) {
        self.displayItems = items
        tableView.reloadData()
    }
    
    func getItemsError(error: Error) {
        let alertController = UIAlertController(title: nil, message: "Something went wrong!", preferredStyle: .alert)
        
        let retryAction = UIAlertAction(title: "Retry", style: .default, handler: { _ in
            self.presenter.getItems()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(retryAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func showSpinner() {
        activityIndicator.startAnimating()
    }
    
    func hideSpinner() {
        activityIndicator.stopAnimating()
    }
    
    
}

extension DisplayItemsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DisplayItemTableViewCell.reuseId, for: indexPath) as! DisplayItemTableViewCell
        if let item = displayItems?[indexPath.row] {
            cell.configure(name: item.name, listId: item.listId)
        }
        return cell
    }
}
