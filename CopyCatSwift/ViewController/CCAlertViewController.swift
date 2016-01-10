//
//  CCAlertViewController.swift
//  CopyCatSwift
//
//  Created by Baiqi Zhang on 1/9/16.
//  Copyright © 2016 Baiqi Zhang. All rights reserved.
//

import UIKit

class CCAlertViewController : UIViewController {
    let tableView = UITableView()
    
    func closeAction() {
        self.dismissViewControllerAnimated(true, completion: { _ in })
    }

    override func viewDidLoad() {
        view.backgroundColor = .clearColor()
        
        let background = UIButton(frame: view.frame)
        background.backgroundColor = .blackColor()
        background.alpha = 0.5
        background.addTarget(self, action: "closeAction", forControlEvents: .AllTouchEvents)
        view.addSubview(background)
        
        tableView.backgroundColor = .blackColor()
        tableView.separatorStyle = .None
        view.addSubview(tableView)
        
        tableView.registerClass(CCInspireTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.allowsSelection = false

        
        // User Image constraint
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraint(NSLayoutConstraint(item: tableView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        
        self.view.addConstraint(NSLayoutConstraint(item: tableView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0))
        
        self.view.addConstraint(NSLayoutConstraint(item: tableView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: view.frame.width/2))
        
        self.view.addConstraint(NSLayoutConstraint(item: tableView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: view.frame.height/2))
    }
    
    
}