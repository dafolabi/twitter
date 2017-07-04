//
//  TweetCell.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/18/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit
import Alamofire

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    
    
    var tweet: Tweet! {
        didSet {
            tweetTextLabel.text = tweet.text
            screennameLabel.text = tweet.user.username
            timestampLabel.text = tweet.createdAtString
            
            if tweet.favoriteCount == 0 {
                favoriteCountLabel.text = ""
                
            } else {
                favoriteCountLabel.text = String(tweet.favoriteCount!)
            }
            
            if tweet.retweetCount == 0 {
                retweetCountLabel.text = ""
            } else {
                retweetCountLabel.text = String(tweet.retweetCount)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func didHitFavorite(_ sender: Any) {
        if favoriteButton.isSelected {
            favoriteButton.isSelected = false
            tweet.favoriteCount = tweet.favoriteCount! - 1
            
            if tweet.favoriteCount == 0 {
                favoriteCountLabel.text = ""
                
            } else {
                favoriteCountLabel.text = String(tweet.favoriteCount!)
            }
        } else {
            favoriteButton.isSelected = true
            tweet.favoriteCount = tweet.favoriteCount! + 1
            
            if tweet.favoriteCount == 0 {
                favoriteCountLabel.text = ""
                
            } else {
                favoriteCountLabel.text = String(tweet.favoriteCount!)
            }
        }
    }
    
    @IBAction func didHitRetweet(_ sender: Any) {
        if retweetButton.isSelected {
            retweetButton.isSelected = false
            tweet.retweetCount = tweet.retweetCount - 1
            
            if tweet.retweetCount == 0 {
                retweetCountLabel.text = ""
            } else {
                retweetCountLabel.text = String(tweet.retweetCount)
            }
        }
        else {
            retweetButton.isSelected = true
            tweet.retweetCount = tweet.retweetCount + 1
            
            if tweet.retweetCount == 0 {
                retweetCountLabel.text = ""
            } else {
                retweetCountLabel.text = String(tweet.retweetCount)
            }
        }
    }
    
}
