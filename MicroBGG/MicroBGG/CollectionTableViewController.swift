////
////  CollectionTableViewController.swift
////  MicroBGG
////
////  Created by Trey Sands on 3/14/16.
////  Copyright © 2016 Trey Sands. All rights reserved.
////
//
//import UIKit
//
//class CollectionTableViewController: UITableViewController {
//    
//    var username: String?
//    
//    var searchResults: XMLIndexer? {
//        willSet{
//        }
//        didSet{
//            self.tableView.userInteractionEnabled = true
//            reloadDataHelper() { (_) in
//                print("Cell contents: \(self.cellContents)")
//                self.tableView.reloadData()
//            }
//        }
//    }
//    
//    // Game info to be used into cell list
//    var gameInfo: XMLIndexer?
//    
//    // Image to be included in the cellContents.
//    var gameImage: UIImage?
//    
//    var temp = [[String: AnyObject]]()
//    
//    // The view that shows that network activity is being used
//    var ddr = DataDownloadRequest()
//    
//    
//    // This is the actual list for the cells.
//    var cellContents:[[String: AnyObject]] = [] {
//        willSet{
//            
//        }
//        didSet{
//            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
//            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                self.tableView.reloadData()
//            })
//        }
//    }
//    
//    var isDone = false {
//        willSet {
//            
//        }
//        didSet {
//            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                self.tableView.reloadData()
//            })
//        }
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        username = "natureslayer"
//        let searchURL = "https://www.boardgamegeek.com/xmlapi2/collection/?username=" + username! + "&own=1&subtype=boardgame&stats=1"
//        searchAction(searchURL)
//        
//
//        // Uncomment the following line to preserve selection between presentations
//        // self.clearsSelectionOnViewWillAppear = false
//
//        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//    // MARK: - Table view data source
//
//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }
//
//    /*
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
//
//        // Configure the cell...
//
//        return cell
//    }
//    */
//
//    /*
//    // Override to support conditional editing of the table view.
//    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//        // Return false if you do not want the specified item to be editable.
//        return true
//    }
//    */
//
//    /*
//    // Override to support editing the table view.
//    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        if editingStyle == .Delete {
//            // Delete the row from the data source
//            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
//        } else if editingStyle == .Insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }    
//    }
//    */
//
//    /*
//    // Override to support rearranging the table view.
//    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
//
//    }
//    */
//
//    /*
//    // Override to support conditional rearranging of the table view.
//    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//        // Return false if you do not want the item to be re-orderable.
//        return true
//    }
//    */
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
//    */
//    
//    
//    // MARK: Helper functions
//    
//    // Takes the search term query from the search bar and calls the appropriate API. Then the cells in
//    // the table view are populated
//    func searchAction(searchURL: String) {
//        searchResults = nil
//        temp = [[String: AnyObject]]()
//        cellContents = [[String: AnyObject]]()
//        ddr.center = self.view.center
//        ddr.alpha = 0
//        self.view.addSubview(ddr)
//        UIView.animateWithDuration(1, animations: {
//            self.ddr.alpha = 1.0
//        })
//        SharedNetworking.sharedInstance.searchTermQuery(searchURL)  { (response) -> Void in
//            NSOperationQueue.mainQueue().addOperationWithBlock {
//                guard let response = response else {
//                    let alert = UIAlertController(title: "Alert", message: "Error: BGG API call did not work.", preferredStyle: UIAlertControllerStyle.Alert)
//                    alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.Default, handler: nil))
//                    self.presentViewController(alert, animated: true, completion: nil)
//                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
//                    
//                    
//                    return
//                }
//                
//                self.searchResults = response
//                return
//            }
//        }
//    }
//    
//    
//    // Calls the APIs to get the search results for a given
//    func populateCells(){
//        if searchResults == nil {
//            UIView.animateWithDuration(1, animations: {
//                self.ddr.alpha = 0.0
//                
//                }, completion: { finished in
//                    self.ddr.removeFromSuperview()
//            })
//            return
//        }
//        let totalResults = Int((searchResults!["items"].element?.attributes["totalitems"])!)
//        if totalResults == 0 {
//            UIView.animateWithDuration(1, animations: {
//                self.ddr.alpha = 0.0
//                
//                }, completion: { finished in
//                    self.ddr.removeFromSuperview()
//            })
//            return
//        }
//        for i in 0...totalResults!-1 {
//            
//            self.temp.append(["name": "temp"])
//            self.temp[i]["name"] = self.searchResults!["items"]["item"][i]["name"].element?.attributes["value"]!
//            self.temp[i]["id"] = self.searchResults!["items"]["item"][i].element?.attributes["objectid"]!
//            print("game name and id are \(self.temp[i]["name"]) and \(self.temp[i]["objectid"])")
//            let id = (self.temp[i])["id"] as! String
//            let searchURL = "https://www.boardgamegeek.com/xmlapi2/thing/?id="+id+"&stats=1"
//            //print("Calling api: \(searchURL)")
//            //self.temp[i]
//            SharedNetworking.sharedInstance.searchTermQuery(searchURL)  { (response) -> Void in
//                guard let response = response else {
//                    let alert = UIAlertController(title: "Alert", message: "Error: BGG API call did not work.", preferredStyle: UIAlertControllerStyle.Alert)
//                    alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.Default, handler: nil))
//                    self.presentViewController(alert, animated: true, completion: nil)
//                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
//                    
//                    
//                    return
//                }
//                
//                self.gameInfo = response
//                self.temp[i]["imageURL"] = self.gameInfo!["items"]["item"]["image"].element?.text
//                self.temp[i]["yearpublished"] = self.gameInfo!["items"]["item"]["yearpublished"].element?.attributes["value"]!
//                self.temp[i]["description"] = self.gameInfo!["items"]["item"]["description"].element?.text
//                self.temp[i]["minplayers"] = self.gameInfo!["items"]["item"]["minplayers"].element?.attributes["value"]!
//                self.temp[i]["maxplayers"] = self.gameInfo!["items"]["item"]["maxplayers"].element?.attributes["value"]!
//                self.temp[i]["playingtime"] = self.gameInfo!["items"]["item"]["playingtime"].element?.attributes["value"]!
//                self.temp[i]["minage"] = self.gameInfo!["items"]["item"]["minage"].element?.attributes["value"]!
//                self.temp[i]["minage"] = self.gameInfo!["items"]["item"]["minage"].element?.attributes["value"]!
//                self.temp[i]["averagerating"] = self.gameInfo!["items"]["item"]["statistics"]["ratings"]["average"].element?.attributes["value"]
//                self.temp[i]["ranking"] = self.gameInfo!["items"]["item"]["statistics"]["ratings"]["ranks"]["rank"][0].element?.attributes["value"]
//                
//                //print(self.gameInfo)
//                if self.temp[i]["imageURL"] != nil {
//                    let imageURL = self.temp[i]["imageURL"] as! String
//                    self.getImage(imageURL, num: i)
//                }
//                
//            }
//            
//            UIView.animateWithDuration(1, animations: {
//                self.ddr.alpha = 0.0
//                
//                }, completion: { finished in
//                    self.ddr.removeFromSuperview()
//            })
//            
//            self.tableView.reloadData()
//        }
//        isDone = true
//        
//    }
//    
//    
//    
//    func getImage(url: String, num: Int) {
//        let imageURL = "https:"+url
//        print("Calling api: \(imageURL)")
//        SharedNetworking.sharedInstance.searchGameImage(imageURL){ (response) -> Void in
//            guard let response = response else {
//                let alert = UIAlertController(title: "Alert", message: "Error: BGG API call did not work.", preferredStyle: UIAlertControllerStyle.Alert)
//                alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.Default, handler: nil))
//                self.presentViewController(alert, animated: true, completion: nil)
//                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
//                
//                return
//            }
//            
//            self.temp[num]["image"] = response
//            self.cellContents.append(self.temp[num])
//            
//        }
//        
//    }
//
//}
