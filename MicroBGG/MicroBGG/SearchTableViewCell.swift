//
//  SearchTableViewCell.swift
//  MicroBGG
//
//  Created by Trey Sands on 3/7/16.
//  Copyright © 2016 Trey Sands. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {


    // MARK: Properties
    @IBOutlet weak var searchResultTitle: UILabel!
    //@IBOutlet weak var searchResultImage: UIImageView!
    @IBOutlet weak var searchDatePublished: UILabel!
    
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
