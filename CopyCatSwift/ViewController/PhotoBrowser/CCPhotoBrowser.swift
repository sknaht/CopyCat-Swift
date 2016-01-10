//
//  CCPhotoBrowser.swift
//  CopyCatSwift
//
//  Created by Baiqi Zhang on 12/27/15.
//  Copyright © 2015 Baiqi Zhang. All rights reserved.
//

import UIKit
import AssetsLibrary

@objc class CCPhotoBrowser: UIViewController {
    let toolbar = UIToolbar()
    let bgView = UIView()

    var browserCollectionView : UICollectionView?

    var photoDataSources : NSMutableArray?
    var currentIndex = 0
    
    let checkButton = UIButton()
    
    let cancelButton = UIButton()
    let deleteButton  = UIButton()
    let flipButton = UIButton()
    let saveButton = UIButton()
    let shareButton = UIButton()

    var delegate : UIViewController?
    var currentCell : CCBrowserCell?
    
    var category : CCCategory?
    
    // MARK: init
    convenience init(photos photosArray: NSMutableArray, currentIndex index: Int) {
        self.init()
        photoDataSources = photosArray
        currentIndex = index
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        browserCollectionView!.contentOffset = CGPointMake(browserCollectionView!.frame.size.width * CGFloat(currentIndex), 0)
    }
    
    func setupView() {
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.clipsToBounds = true
        
        // Layout
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .Horizontal
        
        // CollectionView
        browserCollectionView = UICollectionView(frame: CGRectMake(-10, 0, self.view.bounds.size.width + 20, self.view.bounds.size.height + 1), collectionViewLayout: layout)
        browserCollectionView!.backgroundColor = UIColor.blackColor()
        browserCollectionView!.registerClass(CCBrowserCell.self, forCellWithReuseIdentifier: NSStringFromClass(CCBrowserCell.self))
        browserCollectionView!.delegate = self
        browserCollectionView!.dataSource = self
        browserCollectionView!.pagingEnabled = true
        browserCollectionView!.showsHorizontalScrollIndicator = false
        browserCollectionView!.showsVerticalScrollIndicator = false
        self.view!.addSubview(browserCollectionView!)

        
        
        //Buttons
        if (delegate is CCProfileViewController) || (delegate is AVCamViewController) {
            bgView.frame = CGRectMake(0, view.frame.size.height - 70, view.frame.size.width, 70)
            bgView.backgroundColor = UIColor.blackColor()
            view!.addSubview(bgView)
            
            cancelButton.frame =  CGRectMake(8, view.frame.size.height - 65, 55, 55)
            cancelButton.addTarget(self, action: "cancelAction", forControlEvents: .TouchUpInside)
            cancelButton.setBackgroundImage(UIImage(named: "close.png"), forState: .Normal)
            cancelButton.setBackgroundImage(UIImage(named: "close_highlight.png"), forState: .Highlighted)
            view!.addSubview(cancelButton)
            
            saveButton.frame = CGRectMake(view.frame.size.width / 2 - 87, view.frame.size.height - 62, 50, 50)
            saveButton.setBackgroundImage(UIImage(named: "save2.png"), forState: .Normal)
            saveButton.setBackgroundImage(UIImage(named: "save2_highlight.png"), forState: .Highlighted)
            saveButton.addTarget(self, action: "saveAction", forControlEvents: .TouchUpInside)
            view!.addSubview(saveButton)
            
            shareButton.frame = CGRectMake(view.frame.size.width/2 - 22.5, view.frame.size.height - 60, 45, 45)
            shareButton.setBackgroundImage(UIImage(named: "sendto.png"), forState: .Normal)
            shareButton.setBackgroundImage(UIImage(named: "sendto_highlight.png"), forState: .Highlighted)
            shareButton.addTarget(self, action: "shareAction", forControlEvents: .TouchUpInside)
            view!.addSubview(shareButton)
            
            flipButton.frame = CGRectMake(view.frame.size.width / 2 + 40, view.frame.size.height - 59, 44, 44)
            flipButton.setBackgroundImage(UIImage(named: "flip2.png"), forState: .Normal)
            flipButton.setBackgroundImage(UIImage(named: "flip2_highlight.png"), forState: .Highlighted)
            flipButton.addTarget(self, action: "flipAction", forControlEvents: .TouchUpInside)
            view!.addSubview(flipButton)
            
            deleteButton.frame = CGRectMake(view.frame.size.width - 60, view.frame.size.height - 60, 45, 45)
            deleteButton.setBackgroundImage(UIImage(named: "delete.png"), forState: .Normal)
            deleteButton.setBackgroundImage(UIImage(named: "delete_highlight.png"), forState: .Highlighted)
            deleteButton.addTarget(self, action: "deleteAction", forControlEvents: .TouchUpInside)
            view!.addSubview(deleteButton)
            
        }
        if (delegate is CCGalleryViewController) {
            let bg: UIView = UIView(frame: CGRectMake(0, view.frame.size.height - 50, view.frame.size.width, 50))
            bg.backgroundColor = UIColor.blackColor()
            view!.addSubview(bg)
            
            //close
            let closeButton: UIButton = UIButton(frame: CGRectMake(view.frame.size.width / 4 - 23, view.frame.size.height - 50, 50, 50))
            closeButton.setBackgroundImage(UIImage(named: "close.png"), forState: .Normal)
            closeButton.setBackgroundImage(UIImage(named: "close_highlight.png"), forState: .Highlighted)
            closeButton.addTarget(self, action: "cancelAction", forControlEvents: .TouchUpInside)
            view!.addSubview(closeButton)
            
            //check
            let checkButton: UIButton = UIButton(frame: CGRectMake(3 * view.frame.size.width / 4 - 23, view.frame.size.height - 50, 50, 50))
            checkButton.setBackgroundImage(UIImage(named: "check.png"), forState: .Normal)
            checkButton.setBackgroundImage(UIImage(named: "check_highlight.png"), forState: .Highlighted)
            checkButton.addTarget(self, action: "checkAction", forControlEvents: .TouchUpInside)
            view!.addSubview(checkButton)
            let bar: UIView = UIView(frame: CGRectMake(view.frame.size.width / 2, view.frame.size.height - 37.5, 1, 25))
            bar.backgroundColor = UIColor(white: 0.13, alpha: 1)
            view!.addSubview(bar)
        }
    }
    
    //MARK: UI actions
    
    func saveAction() {
        UIImageWriteToSavedPhotosAlbum(currentCell!.image, self, "image:didFinishSavingWithError:contextInfo:", nil)
    }
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafePointer<Void>) {
        if error == nil {
            let notifyLabel: UILabel = UILabel(frame: CGRectMake(self.view.frame.size.width / 2 - 100, self.view.frame.size.height / 2 + 150, 200, 30))
            notifyLabel.text = "Photo saved"
            notifyLabel.textColor = UIColor.whiteColor()
            notifyLabel.backgroundColor = UIColor.blackColor()
            notifyLabel.alpha = 0
            self.view!.addSubview(notifyLabel)
            UIView.animateWithDuration(0.3, animations: {() -> Void in
                notifyLabel.alpha = 1
                }, completion: {(finished: Bool) -> Void in
                    UIView.animateWithDuration(0.3, delay: 1, options: .BeginFromCurrentState, animations: {() -> Void in
                        notifyLabel.alpha = 0
                        }, completion: {(finished: Bool) -> Void in
                            notifyLabel.removeFromSuperview()
                    })
            })
        } else {
            let ac = UIAlertController(title: "Save error", message: error?.localizedDescription, preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
        }
    }
    
    
    func checkAction() {
        self.dismissViewControllerAnimated(true, completion: {() -> Void in
            if (self.delegate is CCGalleryViewController) {
                NSLog("%@", self.currentCell!.image)
                let vc = self.delegate as! CCGalleryViewController
                vc.showOverlayViewWithImage(self.currentCell!.image, isNewImage: false)
            }
        })
    }
    
    func cancelAction() {
        self.dismissViewControllerAnimated(true, completion: { _ in })
    }
    
    func flipAction() {
        currentCell?.flip()
    }

    func deleteAction() {
        let index: Int = self.currentIndex
        if index > photoDataSources!.count - 1 {
            return
        }
        CCCoreUtil.removePhotoForCategory(CCCoreUtil.categories[0] as! CCCategory,
            photo: photoDataSources![index] as! CCPhoto)

        self.photoDataSources?.removeObjectAtIndex(index)
        if index == self.photoDataSources!.count {
            self.currentIndex--
        }
        self.browserCollectionView!.reloadData()
    }

    func shareAction() {
        CCNetUtil.newPost(currentCell!.image)
    }
    
    //MARK: Controls
    func setControlsHidden(hidden: Bool, animated: Bool) {
        if hidden {
            UIView.animateWithDuration(0.15, animations: {() -> Void in
                self.flipButton.alpha = 0
                self.cancelButton.alpha = 0
                self.deleteButton.alpha = 0
                self.saveButton.alpha = 0
                self.bgView.alpha = 0
            })
        }
        else {
            UIView.animateWithDuration(0.15, animations: {() -> Void in
                self.flipButton.alpha = 1
                self.cancelButton.alpha = 1
                self.deleteButton.alpha = 1
                self.saveButton.alpha = 1
                self.bgView.alpha = 1
            })
        }
    }
    
    func areControlsHidden() -> Bool {
        return (flipButton.alpha == 0)
    }
    
    func hideControls() {
        self.setControlsHidden(true, animated: true)
    }
    
    func toggleControls() {
        self.setControlsHidden(!self.areControlsHidden(), animated: true)
    }
}

//MARK: UIScrollViewDelegate

extension CCPhotoBrowser:UIScrollViewDelegate{
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let offsetX: CGFloat = scrollView.contentOffset.x
        let itemWidth: CGFloat = CGRectGetWidth(self.browserCollectionView!.frame)
        if offsetX >= 0 {
            let page = Int(offsetX / itemWidth)
            self.currentIndex = page
        }
    }
}

//MARK: UICollectionViewDataSource

extension CCPhotoBrowser:UICollectionViewDataSource{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (self.delegate is CCGalleryViewController) {
            return photoDataSources!.count - 1
        } else {
            return photoDataSources!.count
        }
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: CCBrowserCell = collectionView.dequeueReusableCellWithReuseIdentifier(NSStringFromClass(CCBrowserCell), forIndexPath: indexPath) as! CCBrowserCell
        var path: String
        if (self.delegate is CCGalleryViewController) {
            let photo = photoDataSources![indexPath.row + 1] as! CCPhoto
            path = photo.photoURI!
        }
        else {
            let photo = photoDataSources![indexPath.row] as! CCPhoto
            path = photo.photoURI!
//            path = "\(photo.photoURI).jpg"
        }
        cell.initWithImagePath(path, photoBrowser: self)

        return cell
    }
}

//MARK: UICollectionViewDelegateFlowLayout

extension CCPhotoBrowser:UICollectionViewDelegateFlowLayout{
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(self.view.bounds.size.width + 20, self.view.bounds.size.height)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 2.0
    }
}