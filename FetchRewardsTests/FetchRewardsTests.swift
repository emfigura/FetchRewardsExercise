//
//  FetchRewardsTests.swift
//  FetchRewardsTests
//
//  Created by Eric Figura on 9/26/20.
//  Copyright © 2020 FetchRewards. All rights reserved.
//

import XCTest
@testable import FetchRewards

class FetchRewardsTests: XCTestCase {
    
    typealias DisplayItem = DisplayItemsViewController.DisplayItem
    
    func testExample() throws {
        let view = SpyDisplayItemsView()
        let presenter = DisplayItemsPresenter()
        presenter.apiService = MockAPI()
        presenter.attachView(view: view)
        
        view.getItemsSuccessExpectation = expectation(description: "Get items expectation")
        
        presenter.getItems()
        
        waitForExpectations(timeout: 5, handler: nil)
        
        //Verify we removed the 2 items with invalid names
        XCTAssertEqual(view.items?.count, 3)
        
        //Test the ordering of the items
        XCTAssertEqual(DisplayItem(listId: "List Id: 1", name: "Item 1"), view.items?[0])
        XCTAssertEqual(DisplayItem(listId: "List Id: 2", name: "Item 20"), view.items?[1])
        XCTAssertEqual(DisplayItem(listId: "List Id: 2", name: "Item 3"), view.items?[2])
    }
    
    class SpyDisplayItemsView: DisplayItemsView {
        var getItemsSuccessExpectation: XCTestExpectation?
        var items: [DisplayItem]?
        func getItemsSuccess(items: [DisplayItem]) {
            self.items = items
            getItemsSuccessExpectation?.fulfill()
        }
        
        func getItemsError(error: Error) {}
        
        func showSpinner() {}
        
        func hideSpinner() {}
    }


    struct MockAPI: APIInterface {
        func get<T: Codable>(router: Router, completion: @escaping (Result<[T], Error>) -> ()) {
            // Mock data for the business logic
            let items: [T] = [Item(id: 1, listId: 1, name: nil) as! T,
                             Item(id: 2, listId: 1, name: "") as! T,
                             Item(id: 3, listId: 1, name: "Item 1") as! T,
                             Item(id: 4, listId: 2, name: "Item 3") as! T,
                             Item(id: 5, listId: 2, name: "Item 20") as! T]
            
            switch router {
            case .GetItems:
                completion(.success(items))
            }
        }
    }
}
