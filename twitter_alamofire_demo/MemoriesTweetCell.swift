//
//  MemoriesTweetCell.swift
//  twitter_alamofire_demo
//
//  Created by Daniel Afolabi on 7/5/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit
import AlamofireImage

class MemoriesTweetCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    
    weak var delegate: TweetCellDelegate?

    var tweet: Tweet! {
        didSet {
            let url = URL(string: tweet.user.profilePicutreUrl)!
            profileImageView.af_setImage(withURL: url)
            
            tweetTextLabel.text = tweet.text
            screennameLabel.text = "@" + tweet.user.username
            timestampLabel.text = tweet.createdAtString
            usernameLabel.text = tweet.user.name
            
            
            // favorite button
            if tweet.favorited! {
                favoriteButton.isSelected = true
            }
            else {
                favoriteButton.isSelected = false
            }
            
            // retweet button
            if tweet.retweeted {
                retweetButton.isSelected = true
            } else {
                retweetButton.isSelected = false
            }
            
            
            
            // favorite count
            if tweet.favoriteCount == 0 {
                favoriteCountLabel.text = ""
            } else {
                if tweet.favoriteCount! >= 1000000 {
                    favoriteCountLabel.text = String(tweet.favoriteCount! / 1000000) + "M"
                } else if tweet.favoriteCount! >= 1000 {
                    favoriteCountLabel.text = String(tweet.favoriteCount! / 1000) + "K"
                    
                } else {
                    favoriteCountLabel.text = String(tweet.favoriteCount!)
                }
            }
            
            
            // retweet count
            if tweet.retweetCount == 0 {
                retweetCountLabel.text = ""
            } else {
                if tweet.retweetCount >= 1000000 {
                    retweetCountLabel.text = String(tweet.retweetCount / 1000000) + "M"
                } else if tweet.retweetCount >= 1000 {
                    retweetCountLabel.text = String(tweet.retweetCount / 1000) + "K"
                    
                } else {
                    retweetCountLabel.text = String(tweet.retweetCount)
                }
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
    
    @IBAction func didTapProfile(_ sender: Any) {
        delegate?.didTapProfile(of: tweet.user)
    }
    
    @IBAction func didHitFavorite(_ sender: Any) {
        if tweet.favorited! {
            favoriteButton.isSelected = false
            tweet.favorited = false
            
            tweet.favoriteCount = tweet.favoriteCount! - 1
            
            // favorite count
            if tweet.favoriteCount == 0 {
                favoriteCountLabel.text = ""
            } else {
                if tweet.favoriteCount! >= 1000000 {
                    favoriteCountLabel.text = String(tweet.favoriteCount! / 1000000) + "M"
                } else if tweet.favoriteCount! >= 1000 {
                    favoriteCountLabel.text = String(tweet.favoriteCount! / 1000) + "K"
                    
                } else {
                    favoriteCountLabel.text = String(tweet.favoriteCount!)
                }
            }
            
            // network request
            APIManager.shared.unfavorite(with: tweet, completion: { (tweet: Tweet?, error: Error?) in
                if let error = error {
                    print("Error retweeting Tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Unfavorite success!")
                    
                }
                
            })
        }
        else {
            favoriteButton.isSelected = true
            tweet.favorited = true
            
            favoriteButton.isSelected = true
            tweet.favoriteCount = tweet.favoriteCount! + 1
            
            // favorite count
            if tweet.favoriteCount == 0 {
                favoriteCountLabel.text = ""
            } else {
                if tweet.favoriteCount! >= 1000000 {
                    favoriteCountLabel.text = String(tweet.favoriteCount! / 1000000) + "M"
                } else if tweet.favoriteCount! >= 1000 {
                    favoriteCountLabel.text = String(tweet.favoriteCount! / 1000) + "K"
                    
                } else {
                    favoriteCountLabel.text = String(tweet.favoriteCount!)
                }
            }
            
            // network request
            APIManager.shared.favorite(with: tweet, completion: { (tweet: Tweet?, error: Error?) in
                if let error = error {
                    print("Error retweeting Tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Favorite success!")
                    
                }
                
            })
            
        }
        
    }
    
    @IBAction func didHitRetweet(_ sender: Any) {
        if tweet.retweeted {
            retweetButton.isSelected = false
            tweet.retweeted = false
            
            tweet.retweetCount = tweet.retweetCount - 1
            
            // retweet count
            if tweet.retweetCount == 0 {
                retweetCountLabel.text = ""
            } else {
                if tweet.retweetCount >= 1000000 {
                    retweetCountLabel.text = String(tweet.retweetCount / 1000000) + "M"
                } else if tweet.retweetCount >= 1000 {
                    retweetCountLabel.text = String(tweet.retweetCount / 1000) + "K"
                    
                } else {
                    retweetCountLabel.text = String(tweet.retweetCount)
                }
            }
            
            // network request
            APIManager.shared.unretweet(with: tweet, completion: { (tweet: Tweet?, error: Error?) in
                if let error = error {
                    print("Error retweeting Tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Unretweet success!")
                    
                }
                
            })
        }
        else {
            retweetButton.isSelected = true
            tweet.retweeted = true
            
            retweetButton.isSelected = true
            tweet.retweetCount = tweet.retweetCount + 1
            
            // retweet count
            if tweet.retweetCount == 0 {
                retweetCountLabel.text = ""
            } else {
                if tweet.retweetCount >= 1000000 {
                    retweetCountLabel.text = String(tweet.retweetCount / 1000000) + "M"
                } else if tweet.retweetCount >= 1000 {
                    retweetCountLabel.text = String(tweet.retweetCount / 1000) + "K"
                    
                } else {
                    retweetCountLabel.text = String(tweet.retweetCount)
                }
            }
            
            // network request
            APIManager.shared.retweet(with: tweet, completion: { (tweet: Tweet?, error: Error?) in
                if let error = error {
                    print("Error retweeting Tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Retweet success!")
                    
                }
                
            })
            
        }
        
    }
    
}
