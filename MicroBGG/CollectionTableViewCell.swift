//
//  CollectionTableViewCell.swift
//  MicroBGG
//
//  Created by Trey Sands on 3/14/16.
//  Copyright © 2016 Trey Sands. All rights reserved.
//

import UIKit

class CollectionTableViewCell: UITableViewCell {
    
    // MARK: Properties
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var gameRating: UILabel!
    @IBOutlet weak var gamePublished: UILabel!
    @IBOutlet weak var gameTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
