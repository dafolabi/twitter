//
//  Tweet.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/18/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import Foundation

class Tweet {
    
    // MARK: Properties
    var id: Int64 // For favoriting, retweeting & replying
    var text: String // Text content of tweet
    var favoriteCount: Int? // Update favorite count label
    var favorited: Bool? // Configure favorite button
    var retweetCount: Int // Update favorite count label
    var retweeted: Bool // Configure retweet button
    var user: User // Contains name, screenname, etc. of tweet author
    var createdAtString: String // Display date
    var detailCreatedAtString: String // Display date
    
    var displayUrl: URL?

    
    // MARK: - Create initializer with dictionary
    init(dictionary: [String: Any]) {
        id = dictionary["id"] as! Int64
        text = dictionary["text"] as! String
        favoriteCount = dictionary["favorite_count"] as? Int
        favorited = dictionary["favorited"] as? Bool
        retweetCount = dictionary["retweet_count"] as! Int
        retweeted = dictionary["retweeted"] as! Bool
        
        //getting the photo out of the tweet body
        let entities = dictionary["entities"] as! [String: Any]
        if let media = entities["media"] as? [[String: Any]] {
            let firstMediaItem = media[0]
            let displayURLString = firstMediaItem["media_url_https"] as! String
            displayUrl = URL(string: displayURLString)
        }
        
        let user = dictionary["user"] as! [String: Any]
        self.user = User(dictionary: user)
        
        let createdAtOriginalString = dictionary["created_at"] as! String
        let formatter = DateFormatter()
        // Configure the input format to parse the date string
        formatter.dateFormat = "E MMM d HH:mm:ss Z y"
        // Convert String to Date
        let date = formatter.date(from: createdAtOriginalString)!
        
        // Configure output format
        let interval = -1 * Int(date.timeIntervalSinceNow)
        if Int(interval) < 60 {
            let intervalString = String(interval)
            createdAtString = intervalString + "s"
        }
        
        else if Int(interval) < 3600 {
            let intervalString = String(interval / 60)
            createdAtString = intervalString + "m"
        }
        
        else if Int(interval) < 86400 {
            let intervalString = String(interval / 60 / 60)
            createdAtString = intervalString + "h"
        }
        
        else {
            formatter.dateStyle = .short
            formatter.timeStyle = .none
            // Convert Date to String
            createdAtString = formatter.string(from: date)
        }
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        // Convert Date to String
        detailCreatedAtString = formatter.string(from: date)
        
        
 
    }
    
}

