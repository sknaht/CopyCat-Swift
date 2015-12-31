//
//  ViewController.swift
//  CopyCatSwift
//
//  Created by Baiqi Zhang on 12/16/15.
//  Copyright © 2015 Baiqi Zhang. All rights reserved.
//

import UIKit
//import CoreData


class CCWelcomeViewController: UIViewController {
    private var backgroundImageView = UIImageView()
    private var placeHolderImageView = UIImageView()
    private var categoryButton = UIButton()
    private var inspireButton = UIButton()
    private var settingsButton = UIButton()

    func openGallery(){
        let controller = CCCategoryViewController()
        controller.modalTransitionStyle = .CrossDissolve
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    func openSettings() {
        let vc = CCSettingsViewController()
        vc.modalTransitionStyle = .CrossDissolve
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func openProfile() {
        let list = CCCoreUtil.categories
        let vc = CCProfileViewController(category: list[0] as! CCCategory)
        vc.modalTransitionStyle = .CrossDissolve
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Init offset and ImageView
        var offset : CGFloat = 0.0

        //Background
        self.backgroundImageView.frame = self.view.frame
        if self.view.frame.size.height == 568 {
            self.backgroundImageView.image = UIImage(named: "LaunchImage_2x_faded.png")
        } else {
            self.backgroundImageView.image = UIImage(named: "LaunchImage_1x_faded.png")
            offset = 75
        }
        self.view!.addSubview(self.backgroundImageView)
        self.backgroundImageView.alpha = 0
        
        //Buttons
        categoryButton.frame = CGRectMake(80, 340.0 - offset, 50, 50)
        categoryButton.setBackgroundImage(UIImage(named: "photo.png"), forState: .Normal)
        categoryButton.setBackgroundImage(UIImage(named: "photo_highlight.png"), forState: .Highlighted)
        categoryButton.addTarget(self, action: "openGallery", forControlEvents: .TouchUpInside)
        self.view!.addSubview(categoryButton)
        
        inspireButton.frame = CGRectMake(self.view.frame.size.width - 115, 340 - offset, 50, 50)
        inspireButton.setBackgroundImage(UIImage(named: "gallery.png"), forState: .Normal)
        inspireButton.setBackgroundImage(UIImage(named: "gallery_highlight.png"), forState: .Highlighted)
        inspireButton.addTarget(self, action: "openProfile", forControlEvents: .TouchUpInside)
        self.view!.addSubview(inspireButton)

        //Placeholder for Fading
        self.placeHolderImageView.frame = self.view.frame
        if self.view.frame.size.height == 568 {
            self.placeHolderImageView.image = UIImage(named: "LaunchImage_2x.png")
        } else {
            self.placeHolderImageView.image = UIImage(named: "LaunchImage_1x.png")
        }
        self.view!.addSubview(self.placeHolderImageView)

        //Button Labels
        let cameraLabel: UILabel = UILabel(frame: CGRectMake(75, 393 - offset, 60, 15))
        cameraLabel.textAlignment = .Center
        cameraLabel.text = NSLocalizedString("CAMERA", comment: "CAMERA")
        cameraLabel.font = UIFont.systemFontOfSize(CCCoreUtil.fontSizeS)
        self.view!.addSubview(cameraLabel)
        
        let libraryLabel: UILabel = UILabel(frame: CGRectMake(self.view.frame.size.width - 119.5, 393 - offset, 60, 15))
        libraryLabel.textAlignment = .Center
        libraryLabel.text = NSLocalizedString("GALLERY", comment:"GALLERY")
        libraryLabel.font = UIFont.systemFontOfSize(CCCoreUtil.fontSizeS)
        self.view!.addSubview(libraryLabel)
        
        //Settings
        settingsButton = UIButton(frame: CGRectMake(0, 0, 40, 40))
        settingsButton.setBackgroundImage(UIImage(named: "settings2.png"), forState: .Normal)
        settingsButton.setBackgroundImage(UIImage(named: "settings2_highlight.png"), forState: .Highlighted)
        settingsButton.addTarget(self, action: "openSettings", forControlEvents: .TouchUpInside)
        view!.addSubview(self.settingsButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //Fading
    override func viewDidAppear(animated: Bool) {
        UIView.animateWithDuration(0.1) { () -> Void in
            self.placeHolderImageView.alpha = 0;
            self.backgroundImageView.alpha = 1;
        }
    }
    
}





