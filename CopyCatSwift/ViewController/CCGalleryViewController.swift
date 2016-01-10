//
//  GalleryViewController.swift
//  CopyCatSwift
//
//  Created by Baiqi Zhang on 12/18/15.
//  Copyright © 2015 Baiqi Zhang. All rights reserved.
//

import UIKit
import AssetsLibrary

@objc class CCGalleryViewController: UIViewController {
    
    internal var category : CCCategory?
    
    private let closeButton = UIButton()
    private let cancelButton = UIButton()
    private let deleteButton = UIButton()
    private let flowLayout = UICollectionViewFlowLayout()
    private var collectionView : CCCollectionView?
    
    //Delete
    private var deleting = false
    private var cellsToDelete = NSMutableArray()
    
    //Wait
    var waitingAssetsCount: Int?
    var waitingAssetsCountTotal: Int?
    let alert = UIAlertController(title: "Alert", message: "Please Wait...", preferredStyle: UIAlertControllerStyle.Alert)
    
    convenience init(category : CCCategory){
        self.init()
        self.category = category
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    func closeAction() {
        self.dismissViewControllerAnimated(true, completion: { _ in })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let photoList = category?.photoList?.array
        NSLog("list:%@", photoList!)
        
        //background color
        let backgroundView: UIView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 40))
        backgroundView.backgroundColor = UIColor(white: 0.13, alpha: 0.8)
        self.view!.addSubview(backgroundView)
        
        let backgroundView2: UIView = UIView(frame: CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height - 40))
        backgroundView2.backgroundColor = UIColor.blackColor()
        self.view!.addSubview(backgroundView2)
        
        //Title
        let titleLabel: CCLabel = CCLabel(frame: CGRectMake(50, -1, self.view.frame.size.width - 100, 40))
        titleLabel.text = category?.name
        titleLabel.font = UIFont(name: NSLocalizedString("Font", comment : "Georgia"), size: 20.0)
        titleLabel.textColor = .whiteColor()
        titleLabel.textAlignment = .Center
        self.view!.addSubview(titleLabel)
        
        //Close
        closeButton.frame = CGRectMake(0, 1, 40, 40)
        closeButton.setBackgroundImage(UIImage(named: "back.png"), forState: .Normal)
        closeButton.setBackgroundImage(UIImage(named: "back_highlight.png"), forState: .Highlighted)
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
        
        //Collection
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 2
        collectionView = CCCollectionView(frame: CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height - 40), collectionViewLayout: self.flowLayout)
        collectionView!.registerClass(CCCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView!.backgroundColor = .clearColor()
        collectionView!.delegate = self
        collectionView!.dataSource = self
        self.view!.addSubview(self.collectionView!)

        let swipe: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "closeAction")
        swipe.direction = .Right
        self.view!.addGestureRecognizer(swipe)
    }
    
    // MARK: Add Image
    
    func addFromGallery() {
        if let count = waitingAssetsCount{
            if count != 0{
                return
            }
        }
        let imagePicker: DNImagePickerController = DNImagePickerController()
        imagePicker.imagePickerDelegate = self
        self.presentViewController(imagePicker, animated: true, completion: { _ in })
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
    
    // MARK: Show overlay
    
    func showOverlayViewWithImage(image: UIImage, isNewImage: Bool) {
        let frame: CGRect = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height)
        let overlayView = CCOverlayView(frame: frame, image: image)

        let AVCVC: AVCamViewController = AVCamViewController(overlayView: overlayView)
        overlayView.delegate = AVCVC
        self.presentViewController(AVCVC, animated: true, completion: { _ in })
    }
}

//MARK: DNImagePickerControllerDelegate

extension CCGalleryViewController : DNImagePickerControllerDelegate{
    func dnImagePickerController(imagePicker: DNImagePickerController!, sendImages imageAssets: [AnyObject]!, isFullImage fullImage: Bool) {
        waitingAssetsCount = imageAssets.count
        waitingAssetsCountTotal = self.waitingAssetsCount
        self.presentViewController(alert, animated: true, completion: nil)
        
        for item in imageAssets{
            let dnasset = item as! DNAsset
            let lib: ALAssetsLibrary = ALAssetsLibrary()
            lib.assetForURL(dnasset.url, resultBlock: { (asset : ALAsset!) -> Void in
                    let assetRep: ALAssetRepresentation = asset.defaultRepresentation()
                    let iref = assetRep.fullResolutionImage().takeUnretainedValue()
                    let image = UIImage(CGImage: iref).fixOrientation()
                
                    CCCoreUtil.addPhotoForCategory(self.category!, image: image)
                
                    self.waitingAssetsCount = self.waitingAssetsCount! - 1
                    
                    if self.waitingAssetsCount == 0 {
                        self.collectionView!.reloadData()
                        self.alert.dismissViewControllerAnimated(true, completion: nil)
                    }
                }, failureBlock: { (error:NSError!) -> Void in
                    NSLog("%@",error)
                })
        }
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func dnImagePickerControllerDidCancel(imagePicker: DNImagePickerController) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
    }
}


// MARK: UICollectionViewDataSource

extension CCGalleryViewController:UICollectionViewDataSource{
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

extension CCGalleryViewController:UICollectionViewDelegate{
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if !self.deleting{
            if indexPath.row == 0 {
                self.addFromGallery()
            } else {
                let browser = CCPhotoBrowser(photos: ((category?.mutableOrderedSetValueForKey("photoList").array)! as NSArray).mutableCopy() as! NSMutableArray, currentIndex: indexPath.row - 1)
                browser.delegate = self
                browser.category = category
                browser.modalTransitionStyle = .CrossDissolve
                self.presentViewController(browser, animated: false, completion: { _ in })
            }
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

extension CCGalleryViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(2, 0, 0, 0);
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let len=(self.view.frame.size.width-6)/4.0;
        let retval = CGSizeMake(len, len);
        return retval;
    }
}