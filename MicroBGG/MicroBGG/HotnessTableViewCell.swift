//
//  HotnessTableViewCell.swift
//  MicroBGG
//
//  Created by Trey Sands on 6/3/16.
//  Copyright © 2016 Trey Sands. All rights reserved.
//

import UIKit

class HotnessTableViewCell: UITableViewCell {
    
    
    
    // MARK: Properties
    
    @IBOutlet weak var rank: UILabel!
    @IBOutlet weak var boardGameName: UILabel!
    @IBOutlet weak var yearPublished: UILabel!
   
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
