//
//  CCSettingsViewController.swift
//  CopyCatSwift
//
//  Created by Baiqi Zhang on 12/24/15.
//  Copyright © 2015 Baiqi Zhang. All rights reserved.
//

import UIKit

class CCSettingsViewController: UIViewController {
    private let strUsingBackgrondMode = NSLocalizedString("OVERLAY MODE: BACKGROUND",comment: "")
    private let strUsingHoverMode = NSLocalizedString("OVERLAY MODE: HOVER",comment: "")
    private let strSaveToCameraRoll = NSLocalizedString("AUTOSAVE TO CAMERA ROLL: ON",comment: "")
    private let strNotSaveToCameraRoll = NSLocalizedString("AUTOSAVE TO CAMERA ROLL: OFF",comment: "")
    private let strPreviewAfterPhotoTaken = NSLocalizedString("PREVIEW AFTER PHOTO TAKEN: ON",comment: "")
    private let strNotPreviewAfterPhotoTaken = NSLocalizedString("PREVIEW AFTER PHOTO TAKEN: OFF",comment: "")

    private let titleLabel = CCLabel()
    
    private let closeButton = UIButton()
    private let overlayModeButton = CCFramedButton()
    private let autoSaveButton = CCFramedButton()
    private let previewButton = CCFramedButton()
    private let feedbackButton = CCFramedButton()
    private let rateButton = CCFramedButton()
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let backgroundImage = UIImage(named: "LaunchImage_2x_faded.png")!.resizeWithFactor(0.3).applyBlurWithRadius(5, tintColor: UIColor(white: 0, alpha: 0.3), saturationDeltaFactor: 1.8, maskImage: nil)
        let backgroundImageView: UIImageView = UIImageView(frame: self.view.frame)
        backgroundImageView.image = backgroundImage
        self.view!.addSubview(backgroundImageView)
        let backgroundView: UIView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 40))
        backgroundView.backgroundColor = UIColor(white: 0.13, alpha: 0.8)
        self.view!.addSubview(backgroundView)

        //Title
        titleLabel.frame = CGRectMake(50, -1, self.view.frame.size.width - 100, 40)
        titleLabel.text = NSLocalizedString("SETTINGS", comment: "SETTINGS")
        titleLabel.font = UIFont(name: NSLocalizedString("Font", comment: "Georgia"), size: 20.0)
        titleLabel.textColor = .whiteColor()
        titleLabel.textAlignment = .Center
        self.view!.addSubview(titleLabel)
        
        // Buttons
        closeButton.frame = CGRectMake(0, 1, 40, 40)
        closeButton.setBackgroundImage(UIImage(named: "close.png"), forState: .Normal)
        closeButton.addTarget(self, action: "closeAction", forControlEvents: .TouchUpInside)
        self.view!.addSubview(self.closeButton)
        
        // Items
        let height: CGFloat = 50
        let spacing: CGFloat = height + 40
        
        // item: overlay mode
        overlayModeButton.frame = CGRectMake(-1, 90, self.view.frame.size.width + 2, height)
        if CCCoreUtil.isUsingBackgrondMode == 1 {
            overlayModeButton.setTitle(strUsingBackgrondMode, forState: .Normal)
        }
        else {
            overlayModeButton.setTitle(strUsingHoverMode, forState: .Normal)
        }
        self.view!.addSubview(overlayModeButton)
        overlayModeButton.addTarget(self, action: "overlayAction:", forControlEvents: .TouchUpInside)
        overlayModeButton.titleLabel?.font = UIFont.systemFontOfSize(CCCoreUtil.fontSizeS)
        
        // item: autosave
        autoSaveButton.frame = CGRectMake(-1, 90 + height - 0.5, self.view.frame.size.width + 2, height)
        if CCCoreUtil.isSaveToCameraRoll == 1 {
            autoSaveButton.setTitle(strSaveToCameraRoll, forState: .Normal)
        }
        else {
            autoSaveButton.setTitle(strNotSaveToCameraRoll, forState: .Normal)
        }
        self.view!.addSubview(autoSaveButton)
        autoSaveButton.addTarget(self, action: "autosaveAction:", forControlEvents: .TouchUpInside)
        autoSaveButton.titleLabel?.font = UIFont.systemFontOfSize(CCCoreUtil.fontSizeS)
        
        // item: preview
        previewButton.frame = CGRectMake(-1, 90 + 2 * height - 1, self.view.frame.size.width + 2, height)
        if CCCoreUtil.isPreviewAfterPhotoTaken == 1 {
            previewButton.setTitle(strPreviewAfterPhotoTaken, forState: .Normal)
        }
        else {
            previewButton.setTitle(strNotPreviewAfterPhotoTaken, forState: .Normal)
        }
        self.view!.addSubview(previewButton)
        previewButton.addTarget(self, action: "previewAction:", forControlEvents: .TouchUpInside)
        previewButton.titleLabel?.font = UIFont.systemFontOfSize(CCCoreUtil.fontSizeS)


        // item: feedback
        feedbackButton.frame = CGRectMake(-1, 90 + 2 * height + spacing, self.view.frame.size.width + 2, height)
        feedbackButton.setTitle(NSLocalizedString("SEND FEEDBACK", comment: "SEND FEEDBACK"), forState: .Normal)
        self.view!.addSubview(feedbackButton)
        feedbackButton.addTarget(self, action: "feedbackAction", forControlEvents: .TouchUpInside)
        feedbackButton.titleLabel?.font = UIFont.systemFontOfSize(CCCoreUtil.fontSizeS)

        // item: rate
        rateButton.frame = CGRectMake(-1, 90 + 2 * height + spacing + height - 0.5, self.view.frame.size.width + 2, height)
        rateButton.setTitle("RATE THE APP", forState: .Normal)
        rateButton.titleLabel?.font = UIFont.systemFontOfSize(CCCoreUtil.fontSizeS)
    }
    
    //MARK: Actions
    func overlayAction(button: UIButton) {
        if CCCoreUtil.isUsingBackgrondMode == 1 {
            button.setTitle(strUsingHoverMode, forState: .Normal)
            CCCoreUtil.isUsingBackgrondMode = 0
        }
        else {
            button.setTitle(strUsingBackgrondMode, forState: .Normal)
            CCCoreUtil.isUsingBackgrondMode = 1
        }
    }
    
    func autosaveAction(button: UIButton) {
        if CCCoreUtil.isSaveToCameraRoll == 1 {
            button.setTitle(strNotSaveToCameraRoll, forState: .Normal)
            CCCoreUtil.isSaveToCameraRoll = 0
        }
        else {
            button.setTitle(strSaveToCameraRoll, forState: .Normal)
            CCCoreUtil.isSaveToCameraRoll = 1
        }
    }
    
    func previewAction(button: UIButton) {
        if CCCoreUtil.isPreviewAfterPhotoTaken == 1 {
            button.setTitle(strNotPreviewAfterPhotoTaken, forState: .Normal)
            CCCoreUtil.isPreviewAfterPhotoTaken = 0
        }
        else {
            button.setTitle(strPreviewAfterPhotoTaken, forState: .Normal)
            CCCoreUtil.isPreviewAfterPhotoTaken = 1
        }
    }
    
    func closeAction() {
        self.dismissViewControllerAnimated(true, completion: { _ in })
    }
    
    func feedbackAction() {
        // NOTE: maxCount = 0 to hide count
        let popupTextView = YIPopupTextView(placeHolder: NSLocalizedString("The developer values your feedback.", comment: "Feedback"), maxCount: 1000, buttonStyle: YIPopupTextViewButtonStyle.RightCancelAndDone)
        popupTextView.delegate = self
        popupTextView.caretShiftGestureEnabled = true
        // default = NO
        popupTextView.text = ""
        popupTextView.showInViewController(self)
    }
    
}

extension CCSettingsViewController : YIPopupTextViewDelegate{
    func popupTextView(textView: YIPopupTextView, willDismissWithText text: String, cancelled: Bool) {
        if !cancelled {
            let url: NSURL = NSURL(string: "http://1.copykat.sinaapp.com/upload_quote.php")!
            let request: NSMutableURLRequest = NSMutableURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy, timeoutInterval: 10)
            request.HTTPMethod = "POST"
            var str: String = "UID=0&Text="
            str = str.stringByAppendingString(textView.text!)
            let data: NSData = str.dataUsingEncoding(NSUTF8StringEncoding)!
            request.HTTPBody = data
            do{
                let received: NSData = try NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
                let str1 = String(data: received, encoding: NSUTF8StringEncoding)
                NSLog("http:%@", str1!)
            }catch{
                
            }
        }
        self.setNeedsStatusBarAppearanceUpdate()
    }
}