//
//  SearchTableViewController.swift
//  MicroBGG
//
//  Created by Trey Sands on 3/7/16.
//  Copyright © 2016 Trey Sands. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController, UISearchBarDelegate {
    
    
    // MARK: Properties
    
    // The search bar that calls the BGG API
    @IBOutlet weak var searchTableSearchBar: UISearchBar!
    
    // The search term from the search bar
    var searchTerm: String?
    
    // The view that shows that network activity is being used
    var ddr = DataDownloadRequest()
    
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
    
    // Image to be included in the cellContents.
    var gameImage: UIImage?
    
    // Used during the downloading of game info
    var temp = [[String: AnyObject]]()
    

    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Sets the user defaults
        let defaults = NSUserDefaults.standardUserDefaults()
        if defaults.stringForKey("initialLaunch") == nil {
            defaults.setObject("Trey Sands", forKey: "designer")
            let date = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .MediumStyle, timeStyle: .ShortStyle)
            defaults.setObject(date, forKey: "initialLaunch")
        }
        
        // Creates and animates the splash screen
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let splash = UIView(frame: screenSize)
        splash.backgroundColor = .blueColor()
        let titleTextFrame = CGRect(x: 0, y: 0, width: splash.frame.width, height: splash.frame.height/4)
        let titleText = UITextView(frame: titleTextFrame)
        titleText.center = splash.center
        titleText.backgroundColor = .blueColor()
        titleText.textContainer.maximumNumberOfLines = 2
        titleText.text = "Micro BGG \n by Trey Sands"
        titleText.textColor = .yellowColor()
        titleText.textAlignment = .Center
        titleText.font = titleText.font!.fontWithSize(24)
        splash.addSubview(titleText)
        splash.alpha = 1
        self.view.addSubview(splash)
        UIView.animateWithDuration(1.0, delay: 2.5, options: .CurveEaseOut ,animations: {
            splash.alpha = 0
            }, completion: { done in
                return
        })
        
        self.searchTableSearchBar.userInteractionEnabled = true
        searchTableSearchBar.delegate = self
        self.tableView.rowHeight = 100
        
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
        let cellIdentifier = "SearchTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! SearchTableViewCell
        
        if self.cellContents.count < 1 {
            print("cell did not load")
            cell.searchResultTitle.text = "Did not load"
            
            return cell
        }
        let game: [String: AnyObject] = self.cellContents[indexPath.row]
        let title = game["name"] as! String
        let date = game["yearpublished"] as! String
        cell.searchDatePublished.text = date
        
        cell.searchResultTitle.text = title

        if game["image"] != nil {
            let image = game["image"] as! UIImage
            cell.searchResultImage.image = image
        }

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
            if let selectedSearchCell = sender as? SearchTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedSearchCell)!
                if cellContents.count < indexPath.row + 1 {
                    return
                }
                let selectedGame = cellContents[indexPath.row]
                let passedGame = Game(gameInfo: selectedGame)
                print("Passed Game is : \(passedGame)")
                gameDetailVC.gameObj = passedGame
            }
        }
    }
    
    
    // MARK: Search Bar Function
    
    /**
    This will create the URL used to call the BGG API. The results will then be serialized into a usable format.
    */
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        // Hides the keyboard
        self.view.endEditing(true)
        // URLs don't like spaces
        searchTerm = (searchBar.text)?.stringByReplacingOccurrencesOfString(" ", withString: "+")
        let searchURL = "https://www.boardgamegeek.com/xmlapi2/search/?query=" + searchTerm! + "&type=boardgame"
        searchAction(searchURL)
    }
    
    // MARK: Helper functions
    
    // Takes the search term query from the search bar and calls the appropriate API. Then the cells in
    // the table view are populated
    func searchAction(searchURL: String) {
        searchResults = nil
        temp = [[String: AnyObject]]()
        cellContents = [[String: AnyObject]]()
        ddr.center = self.view.center
        ddr.alpha = 0
        self.view.addSubview(ddr)
        UIView.animateWithDuration(1, animations: {
            self.ddr.alpha = 1.0
        })
        SharedNetworking.sharedInstance.searchTermQuery(searchURL)  { (response) -> Void in
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
        let totalResults = Int((searchResults!["items"].element?.attributes["total"])!)
        if totalResults == 0 {
            UIView.animateWithDuration(1, animations: {
                self.ddr.alpha = 0.0
                
                }, completion: { finished in
                    self.ddr.removeFromSuperview()
            })
            return
        }
        for i in 0...min(totalResults!-1, 10) {
            
            self.temp.append(["name": "temp"])
            self.temp[i]["name"] = self.searchResults!["items"]["item"][i]["name"].element?.attributes["value"]!
            self.temp[i]["id"] = self.searchResults!["items"]["item"][i].element?.attributes["id"]!
            
            let id = (self.temp[i])["id"] as! String
            let searchURL = "https://www.boardgamegeek.com/xmlapi2/thing/?id="+id+"&stats=1"
            print("Calling api: \(searchURL)")
            SharedNetworking.sharedInstance.searchTermQuery(searchURL)  { (response) -> Void in
                guard let response = response else {
                    let alert = UIAlertController(title: "Alert", message: "Error: BGG API call did not work.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    
                    
                    return
                }
                
                self.gameInfo = response
                self.temp[i]["imageURL"] = self.gameInfo!["items"]["item"]["image"].element?.text
                self.temp[i]["yearpublished"] = self.gameInfo!["items"]["item"]["yearpublished"].element?.attributes["value"]!
                self.temp[i]["description"] = self.gameInfo!["items"]["item"]["description"].element?.text
                self.temp[i]["minplayers"] = self.gameInfo!["items"]["item"]["minplayers"].element?.attributes["value"]!
                self.temp[i]["maxplayers"] = self.gameInfo!["items"]["item"]["maxplayers"].element?.attributes["value"]!
                self.temp[i]["playingtime"] = self.gameInfo!["items"]["item"]["playingtime"].element?.attributes["value"]!
                self.temp[i]["minage"] = self.gameInfo!["items"]["item"]["minage"].element?.attributes["value"]!
                self.temp[i]["minage"] = self.gameInfo!["items"]["item"]["minage"].element?.attributes["value"]!
                self.temp[i]["averagerating"] = self.gameInfo!["items"]["item"]["statistics"]["ratings"]["average"].element?.attributes["value"]
                self.temp[i]["ranking"] = self.gameInfo!["items"]["item"]["statistics"]["ratings"]["ranks"]["rank"][0].element?.attributes["value"]
                
                
                if self.temp[i]["imageURL"] != nil {
                    let imageURL = self.temp[i]["imageURL"] as! String
                    self.getImage(imageURL, num: i)
                }
                
            }
            
            UIView.animateWithDuration(1, animations: {
                self.ddr.alpha = 0.0
                
                }, completion: { finished in
                    self.ddr.removeFromSuperview()
            })
            
            self.tableView.reloadData()
        }
    }
    

    // This is for getting the image of a game from a search result
    func getImage(url: String, num: Int) {
        let imageURL = "https:"+url
        print("Calling api: \(imageURL)")
        SharedNetworking.sharedInstance.searchGameImage(imageURL){ (response) -> Void in
            guard let response = response else {
                let alert = UIAlertController(title: "Alert", message: "Error: BGG API call did not work.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                
                return
            }
            
            self.temp[num]["image"] = response
            self.cellContents.append(self.temp[num])
            
        }
        
    }
    
    func reloadDataHelper(completion: (test: String) -> ()) {
        populateCells()
        completion(test: "good to go")
    }
    
    // Provides info on the app
    @IBAction func giveInfo(sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Information", message: "Searches Board Game Geek for board games and board game expansions. Press a given result for more detailed information. There you can add to your wishlist which can be viewed later offline in the Wish List tab.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
}
