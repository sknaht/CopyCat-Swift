//
//  CCInspireTableViewCell.swift
//  CopyCatSwift
//
//  Created by Baiqi Zhang on 1/2/16.
//  Copyright © 2016 Baiqi Zhang. All rights reserved.
//

import UIKit

class CCInspireTableViewCell : UITableViewCell {
    // Image
    private var count = 0
    let myImageView = UIImageView()
    var myImageURI : String{
        set{
            self.myImageView.image = nil
            self.myImageView.alpha = 0
            count++
            myImageView.frame=CGRectMake(0,0, self.frame.size.width, self.frame.size.height - 40);
            myImageView.contentMode = .ScaleAspectFill
            myImageView.clipsToBounds = true
            
            dispatch_async(dispatch_get_global_queue(0, 0)) { () -> Void in
                if let image = UIImage(named: newValue){
                    self.myImageView.image = image
                } else {
                    guard
                        let url = NSURL(string: newValue)
                        else {return}
                    NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, _, error) -> Void in
                        guard
                            let data = data where error == nil,
                            var image = UIImage(data: data)
                            else { return }
                        image = image.resizeWithFactor(0.3)
                        dispatch_async(dispatch_get_main_queue()) { () -> Void in
                            self.count--
                            if self.count != 0 {
                                return
                            }
                            self.myImageView.image = image
                            UIView.animateWithDuration(0.5, animations: { () -> Void in
                                self.myImageView.alpha = 1
                            })
                            
                        }
                    }).resume()
                }
            }
        }
        get{
            return self.myImageURI
        }
    }
    
    // Username
    private let usernameLabel = UILabel()
    var username : String{
        set{
            usernameLabel.frame=CGRectMake(40,self.frame.size.height - 35, self.frame.size.width, 15)
            usernameLabel.text = newValue
            usernameLabel.textColor = .whiteColor()
            usernameLabel.font = UIFont.systemFontOfSize(10.5)
            usernameLabel.textAlignment = .Left
        }
        get{
            return self.username
        }
    }
    
    
    // Timestamp
    private let timestampLabel = UILabel()
    var timestamp : NSDate{
        set{
            let now = Int(NSDate().timeIntervalSinceDate(newValue))
            
            timestampLabel.frame=CGRectMake(40,self.frame.size.height - 20, self.frame.size.width, 15)
            
            if now<60{
                timestampLabel.text = String(now) + "s ago"
            } else if now < 60*60{
                timestampLabel.text = String(now/60) + "m ago"
            } else if now < 60*60*24{
                timestampLabel.text = String(now/60/60) + "h ago"
            } else if now < 60*60*24/365{
                timestampLabel.text = String(now/60/60/24) + "days ago"
            } else {
                timestampLabel.text = String(now/60/60/24/365/12) + "months ago"
            }
            
            timestampLabel.textColor = UIColor(colorLiteralRed: 1, green: 1, blue: 1, alpha: 0.75)
            timestampLabel.textAlignment = .Left
            timestampLabel.font = UIFont.systemFontOfSize(10.5)
        }
        get{
            return self.timestamp
        }
    }

    // Counts
    private let likeCountLabel = UILabel()
    var likeCount : Int{
        set{
            likeCountLabel.text = String(newValue)
        }
        get{
            return self.likeCount
        }
    }
    
    private let pinCountLabel = UILabel()
    var pinCount : Int{
        set{
            pinCountLabel.text = String(newValue)
        }
        get{
            return self.pinCount
        }
    }

    
    private let userImageView = UIImageView()
    private let likeButton = UIButton()
    private let pinButton = UIButton()
    
    var delegate : CCInspireTableViewController?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .blackColor()
        
        myImageView.alpha = 0.0
        self.addSubview(usernameLabel)
        self.addSubview(myImageView)
        self.addSubview(timestampLabel)
        
        // User ImageView
        let padding : CGFloat = -7.0
        let image = UIImage(named: "AppIcon.png")?.imageWithAlignmentRectInsets(UIEdgeInsetsMake(padding, padding, padding, padding))
        userImageView.image = image
        userImageView.layer.borderWidth = 1.0
        userImageView.layer.masksToBounds = false
        userImageView.layer.borderColor = UIColor.whiteColor().CGColor
        userImageView.layer.cornerRadius = 20 + padding
        userImageView.clipsToBounds = true
        userImageView.backgroundColor = UIColor.blackColor()
        self.addSubview(userImageView)

        // Button Inset
        let buttonPadding : CGFloat = -10.0
        let inset = UIEdgeInsetsMake(buttonPadding, buttonPadding, buttonPadding, buttonPadding)
        
        // Like button
        likeButton.setBackgroundImage(UIImage(named: "like2.png")?.imageWithAlignmentRectInsets(inset), forState: .Normal)
        likeButton.setBackgroundImage(UIImage(named: "like2_highlight.png"), forState: .Highlighted)
        likeButton.addTarget(self, action: "likeAction", forControlEvents: .TouchUpInside)
        self.addSubview(likeButton)

        // Pin button
        pinButton.setBackgroundImage(UIImage(named: "pin.png")?.imageWithAlignmentRectInsets(inset), forState: .Normal)
        pinButton.setBackgroundImage(UIImage(named: "pin_highlight.png"), forState: .Highlighted)
        pinButton.addTarget(self, action: "pinAction", forControlEvents: .TouchUpInside)
        self.addSubview(pinButton)
        
        // Like count
        likeCountLabel.textColor = .whiteColor()
        likeCountLabel.textAlignment = .Left
        self.addSubview(likeCountLabel)
        
        // Pin count
        pinCountLabel.textColor = .whiteColor()
        pinCountLabel.textAlignment = .Left
        self.addSubview(pinCountLabel)

        
        // Like button constraint
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: likeButton, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -40))
    
        addConstraint(NSLayoutConstraint(item: likeButton, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0))
        
        addConstraint(NSLayoutConstraint(item: likeButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 40))
        
        addConstraint(NSLayoutConstraint(item: likeButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 40))
        
        // Like Count Label constraint
        likeCountLabel.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: likeCountLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: likeButton, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0))
        
        addConstraint(NSLayoutConstraint(item: likeCountLabel, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0))
        
        addConstraint(NSLayoutConstraint(item: likeCountLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 40))
        
        addConstraint(NSLayoutConstraint(item: likeCountLabel, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 40))

        // Pin button constraint
        pinButton.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: pinButton, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: likeButton, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: -30))
        
        addConstraint(NSLayoutConstraint(item: pinButton, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0))
        
        addConstraint(NSLayoutConstraint(item: pinButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 40))
        
        addConstraint(NSLayoutConstraint(item: pinButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 40))
        
        // Pin Count Label constraint
        pinCountLabel.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: pinCountLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: pinButton, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0))
        
        addConstraint(NSLayoutConstraint(item: pinCountLabel, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0))
        
        addConstraint(NSLayoutConstraint(item: pinCountLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 40))
        
        addConstraint(NSLayoutConstraint(item: pinCountLabel, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 40))
        
        // User Image constraint
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: userImageView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0))
        
        addConstraint(NSLayoutConstraint(item: userImageView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0))
        
        addConstraint(NSLayoutConstraint(item: userImageView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 40))
        
        addConstraint(NSLayoutConstraint(item: userImageView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 40))

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UI Action
    func pinAction(){
        delegate?.pinAction()
    }

    func likeAction(){
        delegate?.likeAction()
    }

}