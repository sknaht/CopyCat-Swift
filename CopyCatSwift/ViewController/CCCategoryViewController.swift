//
//  CategoryViewController.swift
//  CopyCatSwift
//
//  Created by Baiqi Zhang on 12/18/15.
//  Copyright © 2015 Baiqi Zhang. All rights reserved.
//

import UIKit

class CCCategoryViewController: UIViewController {
    
    private var scrollView = UIScrollView()
    private var titleLabel = CCLabel()
    private let closeButton = UIButton()
    
    func closeAction() {
        self.dismissViewControllerAnimated(true, completion: { _ in })
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func categoryButtonPressedWithID(button: UIButton) {
        let buttonID: Int = button.tag
        let currentCategory = CCCoreUtil.categories[buttonID+1] as! CCCategory
        
        let galleryVC = CCGalleryViewController(category: currentCategory)
        galleryVC.modalTransitionStyle = .CrossDissolve
        self.presentViewController(galleryVC, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view!.backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0.13, alpha: 1)
        let swipe = UISwipeGestureRecognizer(target: self, action: "closeAction")
        swipe.direction = .Right
        self.view!.addGestureRecognizer(swipe)
        
        //Title
        titleLabel.frame = CGRectMake(50, -1, self.view.frame.size.width - 100, 40)
        titleLabel.text = NSLocalizedString("CATEGORY", comment: "CATEGORY")
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
    
    override func viewWillAppear(animated: Bool) {
        let list = CCCoreUtil.categories
        NSLog("%@", list)

        //Scroll
        let width = self.view.frame.size.width
        let height = width * 0.45
        if scrollView.isDescendantOfView(self.view) {
            scrollView.removeFromSuperview()
        }
        scrollView = UIScrollView(frame: CGRectMake(0, 40, width, self.view.frame.size.height - 40))
        scrollView.backgroundColor = UIColor.blackColor()
        self.view.addSubview(scrollView)

        
        for k in 0...list.count-2 {
            let category = list[k+1] as! CCCategory
            let uri: String = category.bannerURI!//"banner\(k).png"
            
            let item = UIButton(frame: CGRectMake(0, CGFloat(k) * height, width, height))
            item.tag = Int(k)
            item.setBackgroundImage(UIImage(named: uri), forState: .Normal)
            item.addTarget(self, action: "categoryButtonPressedWithID:", forControlEvents: .TouchUpInside)
            self.scrollView.addSubview(item)
            
            let name = category.name!
            let nameLabel: CCLabel = CCLabel(frame: CGRectMake(0, CGFloat(k) * height + height / 2 - 25, width, 20))
            nameLabel.text = name
            nameLabel.textColor = UIColor.whiteColor()
            nameLabel.font = UIFont(name: NSLocalizedString("Font", comment: "Georgia"), size: 17.0)
            self.scrollView.addSubview(nameLabel)
            
            let count = "- \(category.photoList!.count - 1) -"
            let countLabel: CCLabel = CCLabel(frame: CGRectMake(0, CGFloat(k) * height + height / 2 - 2, width, 20))
            countLabel.text = count
            countLabel.textColor = UIColor.whiteColor()
            countLabel.font = UIFont(name: "Georgia", size: 17.0)
            self.scrollView.addSubview(countLabel)
        }
        self.scrollView.contentSize = CGSizeMake(width, height * CGFloat(list.count))
        self.scrollView.scrollEnabled = true
    }
    
}
