//
//  DisplayItemsPresenter.swift
//  FetchRewards
//
//  Created by Eric Figura on 9/26/20.
//  Copyright © 2020 FetchRewards. All rights reserved.
//

import Foundation

protocol DisplayItemsPresenterInterface: class {
    func attachView(view: DisplayItemsView)
    func getItems()
}

class DisplayItemsPresenter: DisplayItemsPresenterInterface {
    
    
    typealias DisplayItem = DisplayItemsViewController.DisplayItem
    
    weak var view: DisplayItemsView?
    
    //Used an interface for testability. The sorting logic below is tested in FetchRewardsTests
    var apiService: APIInterface = FetchRewardsAPI.shared
    
    func attachView(view: DisplayItemsView) {
        self.view = view
    }
    
    //Get the items from the service call
    func getItems() {
        view?.showSpinner()
        apiService.get(router: .GetItems) { (result: Result<[Item], Error>) in
            switch result {
            case .success(let items):
                //Filter out the items without names and not empty
                let viewItems = items.filter { item in
                    if let name = item.name, !name.isEmpty {
                        return true
                    }
                    return false
                }.sorted { (lhs, rhs) -> Bool in
                    //Sort by the list Id
                    if lhs.listId < rhs.listId {
                        return true
                    }
                    else if lhs.listId > rhs.listId {
                        return false
                    }
                    // Sort by the name. I think I understood this correctly and with strings "20" comes before "3" based on the character order
                    if let lhsName = lhs.name, let rhsName = rhs.name,  lhsName < rhsName {
                        return true
                    }
                    
                    return false
                }.map { item in
                    //Format the list Id string to display in the cell. Also I decided to unwrap with ??. I could force unwrap it because of the filter above. 
                    return DisplayItem(listId: "List Id: \(item.listId)", name: item.name ?? "")
                }
                
                self.view?.getItemsSuccess(items: viewItems)
                self.view?.hideSpinner()
            case .failure(let error):
                self.view?.getItemsError(error: error)
                self.view?.hideSpinner()
            }
        }
    }
}
