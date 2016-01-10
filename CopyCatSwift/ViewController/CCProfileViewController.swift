//
//  CCProfileViewController.swift
//  CopyCatSwift
//
//  Created by Baiqi Zhang on 12/28/15.
//  Copyright © 2015 Baiqi Zhang. All rights reserved.
//

import UIKit

class CCProfileViewController: UIViewController {
    internal var category : CCCategory?
    private let closeButton = UIButton()
    private let cancelButton = UIButton()
    private let deleteButton = UIButton()
    private let flowLayout = UICollectionViewFlowLayout()
    private var collectionView : CCCollectionView?
    private var deleting = false
    private var cellsToDelete = NSMutableArray()

    //Delete
    private var settingsButton = UIButton()

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func closeAction() {
        self.dismissViewControllerAnimated(true, completion: { _ in })
    }

    func openSettings() {
        let vc = CCSettingsViewController()
        vc.modalTransitionStyle = .CrossDissolve
        presentViewController(vc, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Background
        view!.backgroundColor = .blackColor()
        let backgroundView: UIView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 40))
        backgroundView.backgroundColor = UIColor(white: 0.13, alpha: 0.8)
        view!.addSubview(backgroundView)
        
        //Blocks
        let lineWidth:CGFloat = 1
        let height:CGFloat = 80.0
        
        let block1: UIView = UIView(frame: CGRectMake(0, 40 + 2 * lineWidth, self.view.frame.size.width/2 - lineWidth, height))
        block1.backgroundColor = UIColor(white: 0.13, alpha: 0.8)
        view!.addSubview(block1)

        let block2: UIView = UIView(frame: CGRectMake(self.view.frame.size.width/2 + lineWidth, 40 + 2 * lineWidth, self.view.frame.size.width/2 - lineWidth, height))
        block2.backgroundColor = UIColor(white: 0.13, alpha: 0.8)
        view!.addSubview(block2)
        
        //Collection
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 2
        collectionView = CCCollectionView(frame: CGRectMake(0, 40 + 2 * lineWidth + height, self.view.frame.size.width, self.view.frame.size.height - 40), collectionViewLayout: self.flowLayout)
        collectionView!.registerClass(CCCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView!.backgroundColor = .clearColor()
        collectionView!.delegate = self
        collectionView!.dataSource = self
        self.view!.addSubview(self.collectionView!)
        
        let swipe: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "closeAction")
        swipe.direction = .Right
        self.view!.addGestureRecognizer(swipe)

        
        // User ImageView
        let size:CGFloat = 70.0
        let image = UIImage(named: "AppIcon.png")
        let imageView = UIImageView(frame: CGRectMake(self.view.frame.size.width/2 - size/2, 40 + height/2, size, size))
        imageView.image = image
        imageView.layer.borderWidth = 1.0
        imageView.layer.masksToBounds = false
        imageView.layer.borderColor = UIColor.whiteColor().CGColor
        imageView.layer.cornerRadius = imageView.frame.size.width/2
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor.blackColor()
        view!.addSubview(imageView)

        // User Info
        let labelHeight : CGFloat = 11
        let offset : CGFloat = -2
        
        let likes = UILabel(frame:  CGRectMake(0, 40 + 2 * lineWidth + height/2 - labelHeight + offset, view.frame.size.width/2 - lineWidth, labelHeight))
        likes.text = "0"
        likes.textColor = .whiteColor()
        view.addSubview(likes)
        
        let likesLabel = UILabel(frame:  CGRectMake(0, 40 + 2 * lineWidth + height/2 + labelHeight + offset, view.frame.size.width/2 - lineWidth, labelHeight))
        likesLabel.text = "Likes"
        likesLabel.textColor = .whiteColor()
        view.addSubview(likesLabel)

        let pins = UILabel(frame:  CGRectMake(view.frame.size.width/2 + lineWidth, 40 + 2 * lineWidth + height/2 - labelHeight + offset, view.frame.size.width/2 - lineWidth, labelHeight))
        pins.text = "0"
        pins.textColor = .whiteColor()
        view.addSubview(pins)
        
        let pinsLabel = UILabel(frame:  CGRectMake(view.frame.size.width/2 + lineWidth, 40 + 2 * lineWidth + height/2 + labelHeight + offset, view.frame.size.width/2 - lineWidth, labelHeight))
        pinsLabel.text = "Pins"
        pinsLabel.textColor = .whiteColor()
        view.addSubview(pinsLabel)
        
        
        //Settings
        settingsButton = UIButton(frame: CGRectMake(0, 0, 40, 40))
        settingsButton.setBackgroundImage(UIImage(named: "settings2.png"), forState: .Normal)
        settingsButton.setBackgroundImage(UIImage(named: "settings2_highlight.png"), forState: .Highlighted)
        settingsButton.addTarget(self, action: "openSettings", forControlEvents: .TouchUpInside)
        view.addSubview(self.settingsButton)
        
        //Title
        let titleLabel: CCLabel = CCLabel(frame: CGRectMake(50, -1, self.view.frame.size.width - 100, 40))
        titleLabel.text = "User Gallery"//category?.name
        titleLabel.font = UIFont(name: NSLocalizedString("Font", comment : "Georgia"), size: 20.0)
        titleLabel.textColor = .whiteColor()
        titleLabel.textAlignment = .Center
        self.view!.addSubview(titleLabel)
        
        //Close
        closeButton.frame = CGRectMake(view.frame.size.width - 45, 0, 40, 40)
        closeButton.setBackgroundImage(UIImage(named: "close.png"), forState: .Normal)
        closeButton.setBackgroundImage(UIImage(named: "close_highlight.png"), forState: .Highlighted)
        closeButton.addTarget(self, action: "closeAction", forControlEvents: .TouchUpInside)
        view!.addSubview(closeButton)
        
        //Deleting
        cancelButton.frame = CGRectMake(0, -5, 50, 50)
        cancelButton.setBackgroundImage(UIImage(named: "close.png"), forState: .Normal)
        cancelButton.setBackgroundImage(UIImage(named: "close_highlight.png"), forState: .Highlighted)
        cancelButton.addTarget(self, action: "cancelDelete", forControlEvents: .TouchUpInside)
        view!.addSubview(cancelButton)
        
        deleteButton.frame = CGRectMake(view.frame.size.width - 45, 0, 40, 40)
        deleteButton.setBackgroundImage(UIImage(named: "delete.png"), forState: .Normal)
        deleteButton.setBackgroundImage(UIImage(named: "delete_highlight.png"), forState: .Highlighted)
        deleteButton.addTarget(self, action: "performDelete", forControlEvents: .TouchUpInside)
        view!.addSubview(deleteButton)
        
        cancelButton.alpha = 0
        deleteButton.alpha = 0
    }
    
    override func viewWillAppear(animated: Bool) {
        category = CCCoreUtil.categories[0] as? CCCategory
        collectionView?.reloadData()
    }
    
    // MARK: Delete
    func prepareDelete() {
        UIView.animateWithDuration(0.2, animations: {() -> Void in
            self.cancelButton.alpha = 1
            self.deleteButton.alpha = 1
            self.closeButton.alpha = 0
        })
        self.deleting = true
        self.cellsToDelete = NSMutableArray()
    }
    
    func cancelDelete() {
        UIView.animateWithDuration(0.2, animations: {() -> Void in
            self.cancelButton.alpha = 0
            self.deleteButton.alpha = 0
            self.closeButton.alpha = 1
        })
        self.deleting = false
        for item in self.cellsToDelete {
            let cell = item as! CCCollectionViewCell
            cell.flip()
        }
    }
    
    func performDelete() {
        for item in self.cellsToDelete {
            let cell = item as! CCCollectionViewCell
            let photo = cell.coreData as! CCPhoto
            CCCoreUtil.removePhotoForCategory(category!, photo: photo)
        }
        collectionView!.reloadData()
        cancelDelete()
    }
    
    func prepareDeleteCell(cell: CCCollectionViewCell) {
        cellsToDelete.addObject(cell)
    }
    
    func cancelDeleteCell(cell: CCCollectionViewCell) {
        cellsToDelete.removeObject(cell)
    }
}



// MARK: UICollectionViewDataSource

extension CCProfileViewController:UICollectionViewDataSource{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = category?.photoList?.count{
            return count
        } else {
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CCCollectionViewCell
        let photo = category!.photoList![indexPath.row] as! CCPhoto
        
        cell.backgroundColor = .whiteColor()
        cell.initWithImagePath(photo.photoURI)
        cell.delegate = self
        cell.coreData = photo
        
        return cell
    }
}

// MARK: UICollectionViewDelegate

extension CCProfileViewController:UICollectionViewDelegate{
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if !self.deleting{
            let browser = CCPhotoBrowser(photos: ((category?.mutableOrderedSetValueForKey("photoList").array)! as NSArray).mutableCopy() as! NSMutableArray, currentIndex: indexPath.row) //difference : without "-1"
            browser.delegate = self
            browser.category = category
            browser.modalTransitionStyle = .CrossDissolve
            self.presentViewController(browser, animated: false, completion: { _ in })
        } else {
            let cell = collectionView.cellForItemAtIndexPath(indexPath) as! CCCollectionViewCell
            if cell.flip(){
                prepareDeleteCell(cell)
            } else {
                cancelDeleteCell(cell)
            }
        }
    }
}

// MARK: UICollectionViewDelegateFlowLayout

extension CCProfileViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(2, 0, 0, 0);
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let len=(self.view.frame.size.width-6)/4.0;
        let retval = CGSizeMake(len, len);
        return retval;
    }
}
