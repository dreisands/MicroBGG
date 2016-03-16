//
//  WishListTableViewController.swift
//  MicroBGG
//
//  Created by Trey Sands on 3/13/16.
//  Copyright © 2016 Trey Sands. All rights reserved.
//

import UIKit

class WishListTableViewController: UITableViewController {
    
    // MARK: Properties
    
    // The wishlist that will populate the cells
    var wishList: [Game]?
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("loading data from \(Game.ArchiveURL.path!)")
        wishList = NSKeyedUnarchiver.unarchiveObjectWithFile(Game.ArchiveURL.path!) as? [Game]
        self.tableView.reloadData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("loading data from \(Game.ArchiveURL.path!)")
        self.tableView.rowHeight = 100
        wishList = NSKeyedUnarchiver.unarchiveObjectWithFile(Game.ArchiveURL.path!) as? [Game]
        self.tableView.reloadData()

        self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let wishCount = wishList?.count {
            return wishCount
        }
        return 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("WishListTableViewCell", forIndexPath: indexPath) as! WishListTableViewCell
        if wishList?.count < 1 {
            return cell
        }
        let game = wishList![indexPath.row].gameInfo
        cell.gameTitle.text = game["name"] as? String
        
        if game["image"] != nil {
            let image = game["image"] as! UIImage
            cell.gameImage.image = image
        }
        
        cell.gameDatePublished.text = game["yearpublished"] as? String


        return cell
    }
    

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            wishList = NSKeyedUnarchiver.unarchiveObjectWithFile(Game.ArchiveURL.path!) as? [Game]
            print("Unarchiving from \(Game.ArchiveURL.path!)")
            let i = indexPath.row
            wishList?.removeAtIndex(i)
            let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(wishList!, toFile: Game.ArchiveURL.path!)
            if !isSuccessfulSave {
                print("Failed to save games...")
                
            }
            print("Archiving from \(Game.ArchiveURL.path!)")
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showGameDetail" {
            let gameDetailNVC = segue.destinationViewController as! UINavigationController
            let gameDetailVC = gameDetailNVC.viewControllers.first as! GameDetailViewController
            
            // Get the cell that generated this segue.
            if let selectedSearchCell = sender as? WishListTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedSearchCell)!
                if wishList!.count < indexPath.row + 1 {
                    return
                }
                let selectedGame = wishList![indexPath.row]
                print("selected game: \(selectedGame)")
                gameDetailVC.gameObj = selectedGame
                gameDetailVC.fromWishList = true
            }
        }
    }
    

}
