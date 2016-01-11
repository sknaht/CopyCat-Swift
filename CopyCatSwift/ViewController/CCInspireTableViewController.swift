//
//  CCInspireTableViewController.swift
//  CopyCatSwift
//
//  Created by Baiqi Zhang on 1/2/16.
//  Copyright © 2016 Baiqi Zhang. All rights reserved.
//

import UIKit

class CCInspireTableViewController : SKStatefulTableViewController {
    private var postList = [CCPost]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Style
        view.backgroundColor = .blackColor()
        tableView.separatorStyle = .None
        tableView.backgroundColor = .blackColor()
        tableView.registerClass(CCInspireTableViewCell.self, forCellReuseIdentifier: "cell")

        tableView.allowsSelection = false
        // Load data
        triggerInitialLoad()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell"/*+String(indexPath.row % 5)*/, forIndexPath: indexPath) as! CCInspireTableViewCell
        
        let post = postList[indexPath.row]
        
        let uri = CCNetUtil.host + post.photoURI!
        
        cell.username = "Anonymous"
        cell.delegate = self
        cell.myImageURI = uri
        
        cell.pinCount = post.pinCount?.integerValue ?? 0
        cell.likeCount = post.likeCount?.integerValue ?? 0
        
        cell.timestamp = post.timestamp!
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postList.count
    }
    
    
    override func statefulTableViewControllerWillBeginInitialLoad(tvc: SKStatefulTableViewController!, completion: ((Bool, NSError!) -> Void)!) {
            CCNetUtil.getFeedForCurrentUser { (posts) -> Void in
                for post in posts{
                    NSLog("uri:" + post.photoURI!);
                }
                self.postList += posts
                NSLog("postlist:%@\npostList.count:%d", self.postList, self.postList.count)
                
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    tvc.tableView.reloadData()
                    completion(self.postList.count == 0, nil)
                })
            }
    }
    
    override func statefulTableViewControllerWillBeginLoadingFromPullToRefresh(tvc: SKStatefulTableViewController!, completion: ((Bool, NSError!) -> Void)!) {
        CCNetUtil.refreshFeedForCurrentUser { (posts) -> Void in
            for post in posts{
                NSLog("uri:" + post.photoURI!);
            }
            self.postList = posts + self.postList
            NSLog("postlist:%@\npostList.count:%d", self.postList, self.postList.count)
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                tvc.tableView.reloadData()
                completion(self.postList.count == 0, nil)
            })
        }
    }
    
    override func statefulTableViewControllerWillBeginLoadingMore(tvc: SKStatefulTableViewController!, completion: ((Bool, NSError!, Bool) -> Void)!) {
        CCNetUtil.loadMoreFeedForCurrentUser(postList.last?.timestamp) { (posts) -> Void in
            var indexArray = [NSIndexPath]()
            var i = self.postList.count
            
            for post in posts{
                NSLog("uri:" + post.photoURI!);
                indexArray.append(NSIndexPath(forRow: i, inSection: 0))
                i++
            }
            self.postList += posts
            NSLog("postlist:%@\npostList.count:%d", self.postList, self.postList.count)
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                tvc.tableView.beginUpdates()
                tvc.tableView.insertRowsAtIndexPaths(indexArray, withRowAnimation: UITableViewRowAnimation.Fade)
                tvc.tableView.endUpdates()
                completion(posts.count != 0, nil,false)
            })
        }
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        guard
            let height = postList[indexPath.row].photoHeight,
            let width = postList[indexPath.row].photoWidth
            where height > 0 && width > 0
            else {
                return 200.0
            }        
        let viewWidth = tableView.frame.width
        let newHeight : CGFloat = CGFloat(height) / CGFloat(width) * viewWidth
        return newHeight
    }
    
    // MARK: UI Action
    func pinAction(){
        let alertVC = CCAlertViewController()
        alertVC.modalPresentationStyle = .OverCurrentContext
        alertVC.modalTransitionStyle = .CrossDissolve
        presentViewController(alertVC, animated: true, completion: nil)
    }
    
    func likeAction(){
    }

}
