//
//  DisplayItemTableViewCell.swift
//  FetchRewards
//
//  Created by Eric Figura on 9/26/20.
//  Copyright © 2020 FetchRewards. All rights reserved.
//

import UIKit

class DisplayItemTableViewCell: UITableViewCell {
    
    static let reuseId = "DisplayItemTableViewCell"
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var listIdLabel: UILabel!

    func configure(name: String, listId: String) {
        nameLabel.text = name
        listIdLabel.text = listId
    }
    
}
