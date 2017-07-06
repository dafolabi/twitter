//
//  ComposeViewController.swift
//  twitter_alamofire_demo
//
//  Created by Daniel Afolabi on 7/4/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit
import AlamofireImage

protocol ComposeViewControllerDelegate: class {
    func did(post: Tweet)
}


class ComposeViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var textInputTextView: UITextView!
    @IBOutlet weak var tweetCountLabel: UILabel!
    @IBOutlet weak var tweetLabelButton: UIButton!
    
    var placeholderLabel : UILabel!
    
    var tweetColor = UIColor.white
    var overColor = UIColor.white
    
    weak var delegate: ComposeViewControllerDelegate?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        profileImageView.layer.cornerRadius = profileImageView.frame.width * 0.5
        profileImageView.layer.masksToBounds = true
        
        tweetLabelButton.layer.cornerRadius = tweetLabelButton.frame.width * 0.18
        tweetLabelButton.layer.masksToBounds = true
        
        let user = User.current!
        let url = URL(string: user.profilePicutreUrl)!
        profileImageView.af_setImage(withURL: url)
        
        // placeholder text
        textInputTextView.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = "What's happening?"
        placeholderLabel.sizeToFit()
        textInputTextView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (textInputTextView.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.darkGray
        placeholderLabel.isHidden = !textInputTextView.text.isEmpty
        
        tweetColor = tweetLabelButton.tintColor!
        overColor = tweetLabelButton.backgroundColor!

    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
        
        let text = textInputTextView.text as! String
        let count = 140 - text.characters.count
        
        if count < 0 || count == 140 {
            tweetLabelButton.backgroundColor = overColor
            tweetLabelButton.isEnabled = false
            
        } else {
            tweetLabelButton.backgroundColor = tweetColor
                tweetLabelButton.isEnabled = true

        }
        
        if count <= 20 {
            tweetCountLabel.textColor = UIColor.red
        } else {
            tweetCountLabel.textColor = UIColor.black
        }

        tweetCountLabel.text = String(count)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didHitCloseButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapPost(_ sender: Any) {
        APIManager.shared.composeTweet(with: textInputTextView.text) { (tweet, error) in
            if let error = error {
                print("Error composing Tweet: \(error.localizedDescription)")
            } else if let tweet = tweet {
                self.delegate?.did(post: tweet)
                print("Compose Tweet Success!")
            }
        }
        
        dismiss(animated: true, completion: nil)
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
