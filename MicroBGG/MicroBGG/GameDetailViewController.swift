//
//  GameDetailViewController.swift
//  MicroBGG
//
//  Created by Trey Sands on 3/8/16.
//  Copyright © 2016 Trey Sands. All rights reserved.
//

import UIKit
import SafariServices

class GameDetailViewController: UIViewController, SFSafariViewControllerDelegate {
    
    // MARK: Properties:
    
    // The game being displayed
    var gameObj: Game?
    var fromWishList = false
    
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
        scrollV.contentSize = CGSize(width: UIScreen.mainScreen().bounds.width-5, height: 330)
        let game = gameObj?.gameInfo
        gameImage.image = game!["image"] as? UIImage
        yearPublished.text = "Year Published: " + (game!["yearpublished"] as! String)
        playTime.text = "Playing Time: " + (game!["playingtime"] as! String)
        minAge.text = "Minimum Age: " + (game!["minage"] as! String)
        numPlayers.text = "# of Players: " + (game!["minplayers"] as! String) + " - " + (game!["maxplayers"] as! String)
        gameRank.text = "Rank: " + (game!["ranking"] as! String)
        gameRating.text = "Rating: " + (game!["averagerating"] as! String)
        var gameDesc = game!["description"] as! String
        gameDesc = gameDesc.stringByReplacingOccurrencesOfString("&#10;", withString: "\n")
        gameDesc = gameDesc.stringByReplacingOccurrencesOfString("&amp;", withString: "&")
        gameDesc = gameDesc.stringByReplacingOccurrencesOfString("&quot;", withString: "'")
        gameDescription.text = gameDesc
        gameTitle.text = game!["name"] as? String
        if fromWishList {
            self.navigationItem.rightBarButtonItem = nil
        }
        let tapGestRecog = UITapGestureRecognizer(target: self, action: "getWebViewForGame")
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
        if let id = gameObj!.gameInfo["id"] as? String{
            let url = "https://boardgamegeek.com/boardgame/"+id
            let svc = SFSafariViewController(URL: NSURL(string: url)!, entersReaderIfAvailable: true)
            svc.delegate = self
            self.presentViewController(svc, animated: true, completion: nil)
        }
        
    }
    
    func safariViewControllerDidFinish(controller: SFSafariViewController)
    {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
        
    
    // MARK: NSCoding
    
    
    // Saves the game to the wish list
    func saveToWishList() {
        // This will check whether the game is already in the data. If so, will not allowed to be saved
        // Currently is a little slow.
        if var data = NSKeyedUnarchiver.unarchiveObjectWithFile(Game.ArchiveURL.path!) as? [Game] {
            for g in data {
                if g.gameInfo["name"] as! String == gameObj?.gameInfo["name"] as! String {
                    print("Same name game")
                    return
                }
            }
            data.append(gameObj!)
            
            let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(data, toFile: Game.ArchiveURL.path!)
            if !isSuccessfulSave {
                print("Failed to save games...")
                
            }
            print("Saved game to \(Game.ArchiveURL.path!)")
        } else {
            var data = [Game]()
            data.append(gameObj!)
            let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(data, toFile: Game.ArchiveURL.path!)
            if !isSuccessfulSave {
                print("Failed to save games...")
            }
            print("Saved game to \(Game.ArchiveURL.path!)")
        }
    }
}
