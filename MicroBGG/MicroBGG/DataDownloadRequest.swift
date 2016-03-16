//
//  MicroBGG.swift
//  Micro BGG
//
//  Created by Trey Sands on 2/7/16.
//  Copyright © 2016 Trey Sands. All rights reserved.
//

import UIKit

class DataDownloadRequest: UIView {
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .White)
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    
    
    init() {
        super.init(frame: CGRectMake(0, 0, 100, 100))
        self.frame = CGRectMake(0, 0, 100, 100)
        self.backgroundColor = UIColor.grayColor()
        self.layer.cornerRadius = 5
        activityIndicator.center = self.center
        activityIndicator.startAnimating()
        self.addSubview(activityIndicator)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
