//
//  Entity+CoreDataProperties.swift
//  MicroBGG
//
//  Created by Trey Sands on 5/1/16.
//  Copyright © 2016 Trey Sands. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension BoardGame {

    @NSManaged var imageURL: String?
    @NSManaged var yearPublished: String?
    @NSManaged var descOfGame: String?
    @NSManaged var minPlayers: String?
    @NSManaged var maxPlayers: String?
    @NSManaged var playingTime: String?
    @NSManaged var minAge: String?
    @NSManaged var averageRating: String?
    @NSManaged var ranking: String?
    @NSManaged var coverImage: NSData?
    @NSManaged var title: String?
    @NSManaged var gameID: String?
    @NSManaged var onWishList: Bool

}
