//
//  UIImageView+Download.swift
//  CopyCatSwift
//
//  Created by Baiqi Zhang on 1/3/16.
//  Copyright © 2016 Baiqi Zhang. All rights reserved.
//

import Foundation

extension UIImageView {
    func downloadedFrom(link link:String) {
        guard
            let url = NSURL(string: link)
            else {return}
        NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, _, error) -> Void in
            guard
                let data = data where error == nil,
                var image = UIImage(data: data)
                else { return }
            image = image.resizeWithFactor(0.3)
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.image = image
//                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.alpha = 1
//                })

            }
        }).resume()
    }
}