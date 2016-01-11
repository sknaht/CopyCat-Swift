//
//  CCInspireViewController.swift
//  CopyCatSwift
//
//  Created by Baiqi Zhang on 12/31/15.
//  Copyright © 2015 Baiqi Zhang. All rights reserved.
//

import UIKit

class CCInspireViewController : UIViewController {
    private var titleLabel = CCLabel()
    private let closeButton = UIButton()
    private let tableViewController = CCInspireTableViewController()
    
    func closeAction() {
        self.dismissViewControllerAnimated(true, completion: { _ in })
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view!.backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0.13, alpha: 1)
        let swipe = UISwipeGestureRecognizer(target: self, action: "closeAction")
        swipe.direction = .Right
        self.view!.addGestureRecognizer(swipe)

        //Child VC
        addChildViewController(tableViewController)
        tableViewController.view.frame = CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height-40);
        view.addSubview(tableViewController.view)
        tableViewController.didMoveToParentViewController(self)
        
        //Title
        titleLabel.frame = CGRectMake(50, -1, self.view.frame.size.width - 100, 40)
        titleLabel.text = NSLocalizedString("GALLERY", comment: "INSPIRE")
        titleLabel.font = UIFont(name: NSLocalizedString("Font", comment: "Georgia"), size: 20)
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.textAlignment = .Center
        self.view!.addSubview(titleLabel)
        
        //Close
        closeButton.frame = CGRectMake(0, 1, 40, 40)
        closeButton.setBackgroundImage(UIImage(named: "back.png"), forState: .Normal)
        closeButton.setBackgroundImage(UIImage(named: "back_highlight.png"), forState: .Highlighted)
        closeButton.addTarget(self, action: "closeAction", forControlEvents: .TouchUpInside)
        self.view!.addSubview(closeButton)
    }
}