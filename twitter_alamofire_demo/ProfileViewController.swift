//
//  ProfileViewController.swift
//  twitter_alamofire_demo
//
//  Created by Daniel Afolabi on 7/3/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit
import AlamofireImage

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {

    @IBOutlet weak var coverPhotoImageView: UIImageView!
    @IBOutlet weak var profilePictureImageVIew: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!

    var isMoreDataLoading = false
    var loadingMoreView:InfiniteScrollActivityView?
    
    var tweets: [Tweet] = []
    
    var user = User.current!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if user == nil {
            let user = User.current
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        

        // profile picture
        let profileUrl = URL(string: user.profilePicutreUrl)!
        profilePictureImageVIew.af_setImage(withURL: profileUrl)
        
        profilePictureImageVIew.layer.cornerRadius = profilePictureImageVIew.frame.width * 0.5
        profilePictureImageVIew.layer.masksToBounds = true
        
        // cover picture
        let coverUrl = URL(string: user.coverPictureUrl)!
        coverPhotoImageView.af_setImage(withURL: coverUrl)
        
        
        
        screennameLabel.text = user.username
        usernameLabel.text = user.name
        
        
        if Int(user.followingCount)! >= 1000000 {
            followingCountLabel.text = String(Int(user.followingCount)! / 1000000) + "M"
        } else if Int(user.followingCount)! >= 1000 {
            followingCountLabel.text = String(Int(user.followingCount)! / 1000) + "K"
            
        } else {
            followingCountLabel.text = user.followingCount
        }
        
        
        if Int(user.followersCount)! >= 1000000 {
            followersCountLabel.text = String(Int(user.followersCount)! / 1000000) + "M"
        } else if Int(user.followersCount)! >= 1000 {
            followersCountLabel.text = String(Int(user.followersCount)! / 1000) + "K"
            
        } else {
            followersCountLabel.text = user.followersCount
        }
        
     
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        
        // add refresh control to table view
        tableView.insertSubview(refreshControl, at: 0)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        // Set up Infinite Scroll loading indicator
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        tableView.contentInset = insets

        
        APIManager.shared.getUserTimeLine(with: user, completion: { (tweets, error) in
            if let tweets = tweets {
                self.tweets = tweets
                self.tableView.reloadData()
            } else if let error = error {
                print("Error getting user timeline: " + error.localizedDescription)
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserTweetCell", for: indexPath) as! UserTweetCell
        
        cell.tweet = tweets[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        APIManager.shared.getUserTimeLine(with: user, completion: { (tweets, error) in
            if let tweets = tweets {
                self.tweets = tweets
                self.tableView.reloadData()
            } else if let error = error {
                print("Error getting user timeline: " + error.localizedDescription)
            }
        })
        refreshControl.endRefreshing()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                
                isMoreDataLoading = true
                
                // Code to load more results
                APIManager.shared.getNewUserTweets(with: Int(tweets.last!.id), user: user, completion: { (tweets: [Tweet]?, error: Error?) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else if let tweets = tweets {
                        print("Success")
                        
                        // Update flag
                        self.isMoreDataLoading = false
                        
                        // Stop the loading indicator
                        self.loadingMoreView!.stopAnimating()
                        for tweet in tweets {
                            self.tweets.append(tweet)
                        }
                        
                        self.tableView.reloadData()
                        
                    } else {
                        print("There are no new tweets")
                    }
                })
            }
        }
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
