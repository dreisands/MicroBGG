//
//  WishListTableViewCell.swift
//  MicroBGG
//
//  Created by Trey Sands on 3/13/16.
//  Copyright © 2016 Trey Sands. All rights reserved.
//

import UIKit

class WishListTableViewCell: UITableViewCell {
    
    // MARK: Properties
    
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var gameTitle: UILabel!
    @IBOutlet weak var gameDatePublished: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius=10
        self.layer.borderColor = UIColor.blackColor().CGColor
        self.layer.borderWidth = 1
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
