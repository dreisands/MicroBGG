//
//  HotnessTableViewController.swift
//  MicroBGG
//
//  Created by Trey Sands on 6/3/16.
//  Copyright © 2016 Trey Sands. All rights reserved.
//

import UIKit

class HotnessTableViewController: UITableViewController {
    
    // MARK: Properties
    
    // This is the search results to be made into the cells
    var searchResults: XMLIndexer? {
        willSet{
        }
        didSet{
            self.tableView.userInteractionEnabled = true
            reloadDataHelper() { (_) in
                self.tableView.reloadData()
            }
        }
    }
    
    // The view that shows that network activity is being used
    var ddr = DataDownloadRequest()
    
    // This is the actual list for the cells.
    var cellContents:[[String: AnyObject]] = [] {
        willSet{
            
        }
        didSet{
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
            })
        }
    }
    
    // Game info to be used into cell list
    var gameInfo: XMLIndexer?
    
    // Used during the downloading of game info
    var temp = [[String: AnyObject]]()
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 100
        hotnessAction()
        
        
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
        return max(0, cellContents.count)
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "HotnessTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! HotnessTableViewCell
        self.tableView.backgroundColor = .blueColor()
        
        if self.cellContents.count < 1 {
            print("cell did not load")
            cell.boardGameName.text = "Did not load"
            
            return cell
        }
        let game: [String: AnyObject] = self.cellContents[indexPath.row]
        let title = game["name"] as! String
        if let date = game["yearpublished"] as? String {
            cell.yearPublished.text = date
        } else {
            cell.yearPublished.text = "Date Published Not Available"
        }
        
        if let rank = game["rank"] as? String {
            cell.rank.text = "Rank: \(rank)"
        }
        
        cell.boardGameName.text = title
        
        return cell
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
            if let selectedSearchCell = sender as? HotnessTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedSearchCell)!
                if cellContents.count < indexPath.row + 1 {
                    return
                }
                let selectedGame = cellContents[indexPath.row]
                
                let id = selectedGame["id"] as! String
                print("ID: \(id)")
                gameDetailVC.gameID = id
                gameDetailVC.gameTitlePassed = selectedGame["name"] as? String
                
            }
        }
     }
 
    
    
    // MARK: Helper functions
    
    // Takes the search term query from the search bar and calls the appropriate API. Then the cells in
    // the table view are populated
 
    func hotnessAction() {
        temp = [[String: AnyObject]]()
        cellContents = [[String: AnyObject]]()
        ddr.center = self.view.center
        ddr.alpha = 0
        self.view.addSubview(ddr)
        UIView.animateWithDuration(1, animations: {
            self.ddr.alpha = 1.0
        })
        SharedNetworking.sharedInstance.getHotness()  { (response) -> Void in
            NSOperationQueue.mainQueue().addOperationWithBlock {
                guard let response = response else {
                    let alert = UIAlertController(title: "Alert", message: "Error: BGG API call did not work.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    
                    
                    return
                }
                
                self.searchResults = response
                return
            }
        }
    }
    
    // Calls the APIs to get the info on games in a given search result
    func populateCells(){
        if searchResults == nil {
            UIView.animateWithDuration(1, animations: {
                self.ddr.alpha = 0.0
                
                }, completion: { finished in
                    self.ddr.removeFromSuperview()
            })
            return
        }
        let totalResults = 50
        
        for i in 0...totalResults-1 {
            
            self.temp.append(["name": "temp"])
            self.temp[i]["name"] = self.searchResults!["items"]["item"][i]["name"].element?.attributes["value"]!
            self.temp[i]["id"] = self.searchResults!["items"]["item"][i].element?.attributes["id"]!
            self.temp[i]["yearpublished"] = self.searchResults!["items"]["item"][i]["yearpublished"].element?.attributes["value"]!
            self.temp[i]["rank"] = self.searchResults!["items"]["item"][i].element?.attributes["rank"]!
            self.cellContents.append(self.temp[i])
            
            UIView.animateWithDuration(1, animations: {
                self.ddr.alpha = 0.0
                
                }, completion: { finished in
                    self.ddr.removeFromSuperview()
            })
            
            self.tableView.reloadData()
        }
    }
    
    
    func reloadDataHelper(completion: (test: String) -> ()) {
        populateCells()
        completion(test: "good to go")
    }
    
    @IBAction func giveInfo(sender: AnyObject) {
        let alert = UIAlertController(title: "Information", message: "The 50 most viewed board games in the last week as determined by the users on BoardGameGeek.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
