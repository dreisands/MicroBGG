//
//  WishListTableViewController.swift
//  MicroBGG
//
//  Created by Trey Sands on 3/13/16.
//  Copyright © 2016 Trey Sands. All rights reserved.
//

import UIKit
import CoreData

class WishListTableViewController: UITableViewController {
    
    // MARK: Properties
    
    // The wishlist that will populate the cells
    var wishList: [BoardGame]?
    
    let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let predicate = NSPredicate(format: "onWishList == true")
        let fetch = NSFetchRequest(entityName: "BoardGame")
        fetch.predicate = predicate
        do {
            let fetchResults = try delegate?.managedObjectContext.executeFetchRequest(fetch) as? [BoardGame]
            wishList = fetchResults
        } catch {
            return
        }
        self.tableView.reloadData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 100
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
        let game = wishList![indexPath.row]
        cell.gameTitle.text = game.title
        self.tableView.backgroundColor = .blueColor()
        
        if game.coverImage != nil {
            let image = UIImage(data: game.coverImage!)
            cell.gameImage.image = image
        }
        
        cell.gameDatePublished.text = game.yearPublished

        return cell
    }
    

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            // Delete it from the managedObjectContext
            let gameToDelete = wishList![indexPath.row]
            delegate?.managedObjectContext.deleteObject(gameToDelete)
            wishList?.removeAtIndex(indexPath.row)
            delegate?.saveContext()
            
            // Tell the table view to animate out that row
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
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
                gameDetailVC.gameCoreData = selectedGame
                gameDetailVC.fromWishList = true
            }
        }
    }
    

}
