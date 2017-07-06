//
//  DetailViewController.swift
//  twitter_alamofire_demo
//
//  Created by Daniel Afolabi on 7/6/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, TweetCellDelegate {
    
    @IBOutlet weak var profilePictureImageVIew: UIImageView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!

    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    @IBOutlet weak var timestampLabel: UILabel!
    
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var tweet: Tweet!
    
    weak var delegate: TweetCellDelegate?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let url = URL(string: tweet.user.profilePicutreUrl)!
        profilePictureImageVIew.af_setImage(withURL: url)
        
        tweetTextLabel.text = tweet.text
        screennameLabel.text = tweet.user.username
        
        timestampLabel.text = tweet.detailCreatedAtString
        
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
        if tweet.favoriteCount! >= 1000000 {
            favoriteCountLabel.text = String(tweet.favoriteCount! / 1000000) + "M"
        } else if tweet.favoriteCount! >= 1000 {
            favoriteCountLabel.text = String(tweet.favoriteCount! / 1000) + "K"
            
        } else {
            favoriteCountLabel.text = String(tweet.favoriteCount!)
        }
        
        
        
        // retweet count
        if tweet.retweetCount >= 1000000 {
            retweetCountLabel.text = String(tweet.retweetCount / 1000000) + "M"
        } else if tweet.retweetCount >= 1000 {
            retweetCountLabel.text = String(tweet.retweetCount / 1000) + "K"
            
        } else {
            retweetCountLabel.text = String(tweet.retweetCount)
        }
    
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapProfile(_ sender: Any) {
        delegate?.didTapProfile(of: tweet.user)
    }
    
    func didTapProfile(of user: User) {
        performSegue(withIdentifier: "toProfile", sender: user)
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let user = sender as! User
        let profileViewController = segue.destination as! ProfileViewController
        profileViewController.user = user
    }
    
}
