//
//  MemoriesViewController.swift
//  twitter_alamofire_demo
//
//  Created by Daniel Afolabi on 7/4/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit

class MemoriesViewController:  UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, TweetCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var isMoreDataLoading = false
    var loadingMoreView:InfiniteScrollActivityView?
    
    var tweets: [Tweet] = []
    
    let user = User.current!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if user == nil {
            let user = User.current
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        
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
        
        // Set the logo image in the navigation item
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        let image = UIImage(named: "TwitterLogoBlue.png");
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView
        
        
        APIManager.shared.getMentionsTimeLine(completion: { (tweets, error) in
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemoriesTweetCell", for: indexPath) as! MemoriesTweetCell
        
        cell.tweet = tweets[indexPath.row]
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        APIManager.shared.getMentionsTimeLine(completion: { (tweets, error) in
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
                APIManager.shared.getMentionsTweets(with: Int(tweets.last!.id), completion: { (tweets: [Tweet]?, error: Error?) in
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

