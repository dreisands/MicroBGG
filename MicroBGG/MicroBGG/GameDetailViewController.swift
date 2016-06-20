//
//  GameDetailViewController.swift
//  MicroBGG
//
//  Created by Trey Sands on 3/8/16.
//  Copyright © 2016 Trey Sands. All rights reserved.
//

import UIKit
import SafariServices
import CoreData

class GameDetailViewController: UIViewController, SFSafariViewControllerDelegate {
    
    // MARK: Properties:
    
    // The game being displayed
    var gameID: String?
    var gameTitlePassed: String?
    var gameCoreData: BoardGame?
    var fromWishList = false
    
    let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
    
    var ddr = DataDownloadRequest()
    
    @IBOutlet weak var gameImage: UIImageView!

    @IBOutlet weak var scrollV: UIScrollView!
    @IBOutlet weak var yearPublished: UILabel!
    @IBOutlet weak var playTime: UILabel!
    @IBOutlet weak var minAge: UILabel!
    @IBOutlet weak var numPlayers: UILabel!
    @IBOutlet weak var gameRank: UILabel!
    @IBOutlet weak var gameRating: UILabel!
    @IBOutlet weak var gameDescription: UITextView!
    @IBOutlet weak var gameTitle: UILabel!
    
    @IBOutlet weak var scrollContent: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollV.contentSize = CGSize(width: 276, height: 330)
        if fromWishList {
            self.yearPublished.text = "Year Published: " + (self.gameCoreData?.yearPublished)!
            self.playTime.text = "Playing Time: " + (self.gameCoreData?.playingTime)!
            self.minAge.text = "Minimum Age: " + (self.gameCoreData?.minAge)!
            self.numPlayers.text = "# of Players: " + (self.gameCoreData?.minPlayers)! + " - " + (self.gameCoreData?.maxPlayers)!
            self.gameRank.text = "Rank: " + (self.gameCoreData?.ranking)!
            self.gameRating.text = "Rating: " + (self.gameCoreData?.averageRating)!
            var gameDesc = (self.gameCoreData?.descOfGame)!
            gameDesc = gameDesc.stringByReplacingOccurrencesOfString("&#10;", withString: "\n")
            gameDesc = gameDesc.stringByReplacingOccurrencesOfString("&amp;", withString: "&")
            gameDesc = gameDesc.stringByReplacingOccurrencesOfString("&quot;", withString: "'")
            self.gameDescription.text = gameDesc
            self.gameTitle.text = (self.gameCoreData?.title)!
            if let coverImage = self.gameCoreData?.coverImage {
                self.gameImage.image = UIImage(data: coverImage)
            }
            self.gameID = self.gameCoreData?.gameID
            self.gameTitlePassed = self.gameCoreData?.title
            self.navigationItem.rightBarButtonItem = nil
        } else {
            gameCoreData =  NSEntityDescription.insertNewObjectForEntityForName("BoardGame", inManagedObjectContext: (self.delegate?.managedObjectContext)!) as? BoardGame
            let searchURL = "https://www.boardgamegeek.com/xmlapi2/thing/?id="+gameID!+"&stats=1"
            searchAction(searchURL)
        }
        let tapGestRecog = UITapGestureRecognizer(target: self, action: #selector(GameDetailViewController.getWebViewForGame))
        gameImage.userInteractionEnabled = true
        gameImage.addGestureRecognizer(tapGestRecog)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    // This will dismiss the current view and go back to the previous one
    @IBAction func unwindSegue(sender: UIBarButtonItem) {
        print("Done button pushed")
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    // MARK: Actions
    
    // This adds the current game to the wishlist
    @IBAction func addToWishList(sender: UIBarButtonItem) {
        print("current game added to wish list")
        saveToWishList()
        
    }
    
    // Opens up a safari VC so the user can look at the game on the BGG site
    func getWebViewForGame() {
        let url = "https://boardgamegeek.com/boardgame/"+gameID!
        let svc = SFSafariViewController(URL: NSURL(string: url)!, entersReaderIfAvailable: true)
        svc.delegate = self
        self.presentViewController(svc, animated: true, completion: nil)
        
        
    }
    
    func safariViewControllerDidFinish(controller: SFSafariViewController)
    {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Searching
    
    func searchAction(searchURL: String) {
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
                    UIView.animateWithDuration(1, animations: {
                        self.ddr.alpha = 0.0
                        
                        }, completion: { finished in
                            self.ddr.removeFromSuperview()
                    })
                    
                    
                    return
                }
                
                let gameInfo = response

                // Add game to Entity
                self.gameCoreData?.title = self.gameTitlePassed
                self.gameCoreData?.imageURL = gameInfo["items"]["item"]["image"].element?.text
                self.gameCoreData?.yearPublished = gameInfo["items"]["item"]["yearpublished"].element?.attributes["value"]!
                self.gameCoreData?.descOfGame = gameInfo["items"]["item"]["description"].element?.text
                self.gameCoreData?.minPlayers = gameInfo["items"]["item"]["minplayers"].element?.attributes["value"]!
                self.gameCoreData?.maxPlayers = gameInfo["items"]["item"]["maxplayers"].element?.attributes["value"]!
                self.gameCoreData?.playingTime = gameInfo["items"]["item"]["playingtime"].element?.attributes["value"]!
                self.gameCoreData?.minAge = gameInfo["items"]["item"]["minage"].element?.attributes["value"]!
                self.gameCoreData?.averageRating = gameInfo["items"]["item"]["statistics"]["ratings"]["average"].element?.attributes["value"]
                self.gameCoreData?.ranking = gameInfo["items"]["item"]["statistics"]["ratings"]["ranks"]["rank"][0].element?.attributes["value"]
                self.gameCoreData?.gameID = self.gameID
                self.gameCoreData?.onWishList = false
            
            
                // Update views
                self.yearPublished.text = "Year Published: " + (self.gameCoreData?.yearPublished)!
                self.playTime.text = "Playing Time: " + (self.gameCoreData?.playingTime)!
                self.minAge.text = "Minimum Age: " + (self.gameCoreData?.minAge)!
                self.numPlayers.text = "# of Players: " + (self.gameCoreData?.minPlayers)! + " - " + (self.gameCoreData?.maxPlayers)!
                self.gameRank.text = "Rank: " + (self.gameCoreData?.ranking)!
                self.gameRating.text = "Rating: " + (self.gameCoreData?.averageRating)!
                var gameDesc = (self.gameCoreData?.descOfGame)!
                gameDesc = gameDesc.stringByReplacingOccurrencesOfString("&#10;", withString: "\n")
                gameDesc = gameDesc.stringByReplacingOccurrencesOfString("&amp;", withString: "&")
                gameDesc = gameDesc.stringByReplacingOccurrencesOfString("&quot;", withString: "'")
                self.gameDescription.text = gameDesc
                self.gameTitle.text = (self.gameCoreData?.title)!
                // Get Cover Image
                let imageURL = "https:"+(self.gameCoreData?.imageURL)!
                SharedNetworking.sharedInstance.searchGameImage(imageURL) { (response) -> Void in
                    NSOperationQueue.mainQueue().addOperationWithBlock {
                        guard let response = response else {
                            let alert = UIAlertController(title: "Alert", message: "Error: BGG API call did not work.", preferredStyle: UIAlertControllerStyle.Alert)
                            alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.Default, handler: nil))
                            self.presentViewController(alert, animated: true, completion: nil)
                            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                            UIView.animateWithDuration(1, animations: {
                                self.ddr.alpha = 0.0
                                
                                }, completion: { finished in
                                    self.ddr.removeFromSuperview()
                            })
                            
                            return
                        }
                        let image = response
                        self.gameCoreData?.coverImage = UIImagePNGRepresentation(image)
                        self.gameImage.image = image
                        UIView.animateWithDuration(1, animations: {
                            self.ddr.alpha = 0.0
                            
                            }, completion: { finished in
                                self.ddr.removeFromSuperview()
                        })
                    }
                }
                return
            }
        }
    }
    
    
    // Saves the game to the wish list
    func saveToWishList() {
        // This will check whether the game is already in the data. If so, will not allowed to be saved
        // Currently is a little slow.
        print(gameID!)
        let predicate = NSPredicate(format: "gameID == %@ AND onWishList == true", gameID!)
        print(predicate)
        let fetch = NSFetchRequest(entityName: "BoardGame")
        fetch.predicate = predicate
        // If game is already in wish list
        do {
            let temp = try delegate?.managedObjectContext.executeFetchRequest(fetch)
            print(temp!.count)
            if temp!.isEmpty {
                gameCoreData?.onWishList = true
                delegate?.saveContext()
                 print("Game Saved")
            } else {
                print("Game already there")
            }
        } catch {
            gameCoreData?.onWishList = true
            delegate?.saveContext()
            print("Game Saved")
        }
        
        
    }
}
