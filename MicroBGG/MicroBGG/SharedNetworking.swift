//
//  MicroBGG.swift
//  MicroBGG
//
//  Created by Trey Sands on 5/8/16.
//  Copyright © 2016 Trey Sands. All rights reserved.
//

import UIKit

class SharedNetworking {
    static let sharedInstance = SharedNetworking()
    private init() {}
    var tempXML: XMLIndexer?
    
    
    /**
        Makes a request to the Board Game Geek API for results. This one is for just a search
        term. It will unserialize the XML into an Array of Dicionaries.
    
        - Parameter urlString: A String of the URL holding the XML
        - Parameter completion: A closure to run on the converted XML

    */
    
    func searchTermQuery(urlString: String, completion:(XMLIndexer?) -> Void) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        print("Calling api: \(urlString)")
        
        // Test that we can convert the `String` into an `NSURL` object.  If we can
        // not, then crash the application.
        guard let url = NSURL(string: urlString)  else {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            fatalError("No URL")
        }
        
        // Create a `NSURLSession` object
        let session = NSURLSession.sharedSession()
        
        // Create a task for the session object to complete
        let task = session.dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
            
            // Check for errors that occurred during the download.  If found, execute
            // the completion block with `nil`
            guard error == nil else {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                print("error: \(error!.localizedDescription): \(error!.userInfo)")
                completion(nil)
                return
            }
            
            // Print the response headers (for debugging purpose only)
            print(response)
            let status = (response as! NSHTTPURLResponse).statusCode
            if status == 503 || status == 500 {
                completion(nil)
                return
            }
            
            // Test that the data has a value and unwrap it to the variable `let`.  If
            // it is `nil` than pass `nil` to the completion closure.
            guard let data = data else {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                print("There was no data")
                completion(nil)
                return
            }
            
            // Unserialze the XML that was retrieved into an Array of Dictionaries.
            // Pass is as parameter to the completion block.
            
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                let xml = SWXMLHash.parse(data)
                completion(xml)
            })
        
        // Start the downloading.  NSURLSession objects are created in the paused
        // state, so to start it we need to tell it to *resume*
        task.resume()
    }
    
    
    
    
    /**
     Makes a request to the Board Game Geek API for results. This one is for just a games ID.
     It will unserialize the XML into an image.
     
     - Parameter urlString: A String of the URL holding the XML
     - Parameter completion: A closure to run on the UIIMage
     
     */
    func searchGameImage(urlString: String, completion:(UIImage?) -> Void) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        print("Calling api: \(urlString)")

        // Test that we can convert the `String` into an `NSURL` object.  If we can
        // not, then crash the application.
        guard let url = NSURL(string: urlString)  else {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            fatalError("No URL")
        }
        
        // Create a `NSURLSession` object
        let session = NSURLSession.sharedSession()
        
        // Create a task for the session object to complete
        let task = session.dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
            
            // Check for errors that occurred during the download.  If found, execute
            // the completion block with `nil`
            guard error == nil else {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                print("error: \(error!.localizedDescription): \(error!.userInfo)")
                completion(nil)
                return
            }
            
            // Print the response headers (for debugging purpose only)
            print(response)
            let status = (response as! NSHTTPURLResponse).statusCode
            
            if status == 503 || status == 500 {
                completion(nil)
                return
            }
            
            
            
            // Test that the data has a value and unwrap it to the variable `let`.  If
            // it is `nil` than pass `nil` to the completion closure.
            guard let data = data else {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                print("There was no data")
                completion(nil)
                return
            }
            
            // Unserialze the XML that was retrieved into an Array of Dictionaries.
            // Pass is as parameter to the completion block.
            let image = UIImage(data: data)
            completion(image)
        })
        
        // Start the downloading.  NSURLSession objects are created in the paused
        // state, so to start it we need to tell it to *resume*
        task.resume()
    }
}
