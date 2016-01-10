//
//  CCNetUtil.swift
//  CopyCatSwift
//
//  Created by Baiqi Zhang on 12/31/15.
//  Copyright © 2015 Baiqi Zhang. All rights reserved.
//

import CoreData


@objc class CCNetUtil:NSObject{
    
//    private static let host = "http://10.0.18.24:8080" //school
//    static let host = "http://10.0.0.8:8080" //home
    static let host = "http://ec2-52-21-52-152.compute-1.amazonaws.com:8080"
    
    // MARK: User Feed
    static func parsePostFromJson(json:JSON) -> [CCPost]{
        var result = [CCPost]()
        for (_, subJson) in json {
            if let uri = subJson["photoURI"].string {
                let postEntity = NSEntityDescription.entityForName("Post", inManagedObjectContext: CCCoreUtil.managedObjectContext)
                let post = NSManagedObject.init(entity: postEntity!, insertIntoManagedObjectContext: nil) as! CCPost
                
                post.photoURI = uri
                post.likeCount = subJson["likeCount"].int ?? 0
                post.pinCount = subJson["likeCount"].int ?? 0
                post.photoWidth = subJson["photoWidth"].int ?? 0
                post.photoHeight = subJson["photoHeight"].int ?? 0
                
                let date = subJson["timestamp"].string ?? ""
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"//this your string date format
                dateFormatter.timeZone = NSTimeZone(name: "UTC")
                post.timestamp = dateFormatter.dateFromString(date)
                
                result.append(post)
            }
        }

        return result
    }
    
    static func getFeedForCurrentUser(completion:(posts:[CCPost]) -> Void) -> Void{
        CCNetUtil.getJSONFromURL(host+"/api/post") { (json:JSON) -> Void in
//            var result = [CCPost]()
//            for (_, subJson) in json {
//                if let uri = subJson["photoURI"].string {
//                    let postEntity = NSEntityDescription.entityForName("Post", inManagedObjectContext: CCCoreUtil.managedObjectContext)
//                    let post = NSManagedObject.init(entity: postEntity!, insertIntoManagedObjectContext: nil) as! CCPost
//                    
//                    post.photoURI = uri
//                    post.likeCount = subJson["likeCount"].int ?? 0
//                    post.pinCount = subJson["likeCount"].int ?? 0
//                    post.photoWidth = subJson["photoWidth"].int ?? 0
//                    post.photoHeight = subJson["photoHeight"].int ?? 0
//                    
//                    let date = subJson["timestamp"].string ?? ""
//                    let dateFormatter = NSDateFormatter()
//                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"//this your string date format
//                    dateFormatter.timeZone = NSTimeZone(name: "UTC")
//                    post.timestamp = dateFormatter.dateFromString(date)
//                    
//                    result.append(post)
//                }
//            }
            let result = parsePostFromJson(json)
            completion(posts: result)
        }
    }
    
    
    static func refreshFeedForCurrentUser(completion:(posts:[CCPost]) -> Void) -> Void{
        let timestamp = String(NSDate())
        let url = host+"/api/post/before/" + timestamp
        let encodedUrl = url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        CCNetUtil.getJSONFromURL(encodedUrl!) { (json:JSON) -> Void in
            let result = parsePostFromJson(json)
            completion(posts: result)
        }
    }
    
    static func loadMoreFeedForCurrentUser(timestamp:NSDate?, completion:(posts:[CCPost]) -> Void) -> Void{
        var url:String
        if let ts = timestamp {
            url = host+"/api/post/after/" + String(ts)
        } else {
            url = host+"/api/post/after/" + String(NSDate())
        }
        let encodedUrl = url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        CCNetUtil.getJSONFromURL(encodedUrl!) { (json:JSON) -> Void in
            let result = parsePostFromJson(json)
            completion(posts: result)
        }
    }
    
    // new post
    static func newPost(image:UIImage){
        let imageData = UIImageJPEGRepresentation(image,0.8)//.resizeWithFactor(0.01), 0.8)
        let base64String = imageData!.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)

        var json = [String: AnyObject]()
        let timestamp = String(NSDate())
        json["photoURI"] = base64String
        json["photoWidth"] = image.size.width
        json["photoHeight"] = image.size.height
        json["timestamp"] = timestamp
        

        do{
            let data = try NSJSONSerialization.dataWithJSONObject(json, options: NSJSONWritingOptions())
            HTTPPostJSON(host + "/api/post", data: data, callback: { (response, error) -> Void in
                NSLog("response:%@", response!)
            })
        } catch{
            
        }
    }


    //MARK: Get Helpers
    
    static func getJSONFromURL(url: String,completion:(json:JSON) -> Void){
        loadDataFromURL(NSURL(string: url)!, completion:{(data: NSData?, error: NSError?) -> Void in
            if let urlData = data {
                let json = JSON(data: urlData)
                NSLog("received json:%@",json.rawString()!)
                completion(json: json)
            }
        })
    }
    
    
    static func loadDataFromURL(url: NSURL, completion:(response: NSData?, error: NSError?) -> Void) {
        let session = NSURLSession.sharedSession()
        
        // Use NSURLSession to get data from an NSURL
        let loadDataTask = session.dataTaskWithURL(url) { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            if let responseError = error {
                completion(response: nil, error: responseError)
            } else if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    let statusError = NSError(domain:"com.copycat", code:httpResponse.statusCode, userInfo:[NSLocalizedDescriptionKey : "HTTP status code has unexpected value."])
                    completion(response: nil, error: statusError)
                } else {
                    completion(response: data, error: nil)
                }
            }
        }
        loadDataTask.resume()
    }
    
    //MARK: Post Helpers

    static func HTTPsendRequest(request: NSMutableURLRequest, callback: (response:NSData?, error:NSError?) -> Void) {
        let task = NSURLSession.sharedSession()
            .dataTaskWithRequest(request) {
                (data, response, error) -> Void in
                if (error != nil) {
                    callback(response: nil, error: error)
                } else {
                    callback(response: data!, error:nil)
                }
        }
        task.resume()
    }
    
    static func HTTPPostJSON(url: String, data: NSData, callback: (response:NSData?, error:NSError?) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        
        request.HTTPMethod = "Post"
        request.addValue("application/json",forHTTPHeaderField: "Content-Type")
        request.addValue("application/json",forHTTPHeaderField: "Accept")
        request.HTTPBody = data
        HTTPsendRequest(request, callback: callback)
    }

}
