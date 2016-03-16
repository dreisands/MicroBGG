//
//  Game.swift
//  MicroBGG
//
//  Created by Trey Sands on 3/13/16.
//  Copyright © 2016 Trey Sands. All rights reserved.
//

import UIKit

class Game: NSObject, NSCoding {
    
    // This needs to be a proper object soon rather than just a dictionary
    // MARK: Properties
    
    var gameInfo: [String: AnyObject]
    
    // MARK: Types
    
    struct PropertyKey {
        static let gameInfoKey = "gameInfo"

    }
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("games")
    
    // MARK: Initialization
    
    init?(gameInfo: [String: AnyObject]){
        // Initialize stored properties
        self.gameInfo = gameInfo
        super.init()

    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(gameInfo, forKey: PropertyKey.gameInfoKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let gameInfo = aDecoder.decodeObjectForKey(PropertyKey.gameInfoKey) as! [String: AnyObject]

        
        // Must call designated initilizer.
        self.init(gameInfo: gameInfo)
    }
}
