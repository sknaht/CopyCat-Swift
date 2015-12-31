//
//  CoreUtil.swift
//  CopyCatSwift
//
//  Created by Baiqi Zhang on 12/19/15.
//  Copyright © 2015 Baiqi Zhang. All rights reserved.
//

import UIKit
import CoreData

@objc class CCCoreUtil:NSObject{
    //Persistance
    static let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    static let userDefault = NSUserDefaults.standardUserDefaults()
    
    //Settings
    static var isUsingBackgrondMode : Int {
        set{
            self.userDefault.setInteger(Int(newValue), forKey: "isUsingBackgrondMode")
        }
        get{
            return self.userDefault.integerForKey("isUsingBackgrondMode")
        }
    }
    static var isSaveToCameraRoll : Int {
        set{
            self.userDefault.setInteger(Int(newValue), forKey: "isSaveToCameraRoll")
        }
        get{
            return self.userDefault.integerForKey("isSaveToCameraRoll")
        }
    }
    static var isPreviewAfterPhotoTaken : Int {
        set{
            self.userDefault.setInteger(Int(newValue), forKey: "isPreviewAfterPhotoTaken")
        }
        get{
            return self.userDefault.integerForKey("isPreviewAfterPhotoTaken")
        }
    }

    // Constants
    static let fontSizeS = CGFloat((NSLocalizedString("FontSizeS", comment:"FontSizeS")as NSString).floatValue)
    static var categories =  NSMutableArray()
    static var categoryCount : Int{
        set{
            self.userDefault.setInteger(Int(newValue), forKey: "categoryCount")
        }
        get{
            return self.userDefault.integerForKey("categoryCount")
        }
    }
    
    
    static func prepare(){
        if let _ = userDefault.stringForKey("initialized"){
            //Creating entries
            let categoriesFetch = NSFetchRequest(entityName: "Category")
            
            do{
                let list = try CCCoreUtil.managedObjectContext.executeFetchRequest(categoriesFetch) as NSArray
                NSLog("categoryList:%@\ncount:%d", list, list.count)
                self.categories = list.mutableCopy() as! NSMutableArray
            }catch{
                NSLog("Not found")
            }
        } else {
            userDefault.setObject(true, forKey: "initialized")
            
            userDefault.setInteger(Int(1), forKey: "isUsingBackgrondMode")
            userDefault.setInteger(Int(0), forKey: "isSaveToCameraRoll")
            userDefault.setInteger(Int(1), forKey: "isPreviewAfterPhotoTaken")
            
            userDefault.setInteger(Int(0), forKey: "categoryCount")
            var category : CCCategory
            category = CCCoreUtil.addCategory("_User",bannerURI:"_User")

            category = CCCoreUtil.addCategory("People",bannerURI:"banner0.png")
            CCCoreUtil.addPhotoForCategory(category, photoURI: "AddNew.png")
            CCCoreUtil.addPhotoForCategory(category, photoURI: "0_0.jpg")
            CCCoreUtil.addPhotoForCategory(category, photoURI: "0_1.jpg")

            category = CCCoreUtil.addCategory("Nature",bannerURI:"banner1.png")
            CCCoreUtil.addPhotoForCategory(category, photoURI: "AddNew.png")
            CCCoreUtil.addPhotoForCategory(category, photoURI: "1_0.jpg")
        }
    }
    
    // Create
    
    static func addCategory(name: String, bannerURI : String) -> CCCategory{
        let category = NSEntityDescription.insertNewObjectForEntityForName("Category",
            inManagedObjectContext: CCCoreUtil.managedObjectContext) as! CCCategory
        categoryCount = categoryCount + 1
        category.name = name
        category.photoCount = 0
        category.id = categoryCount
        category.bannerURI = bannerURI
        CCCoreUtil.categories.addObject(category)
        
        do{
            try CCCoreUtil.managedObjectContext.save()
        }catch{
            NSLog("Save error!")
        }
        return category
    }
    
    static func addPhotoForCategory(category: CCCategory, image : UIImage) -> CCPhoto {
        let count = category.photoCount!.integerValue + 1
        let uri = "\(category.id!)_\(count)"
        let path = "\(NSHomeDirectory())/Documents/\(uri).jpg"
        let tmpath = "\(NSHomeDirectory())/Documents/\(uri)_tm.jpg"
        let imgData: NSData = UIImageJPEGRepresentation(image, 0)!
        imgData.writeToFile(path, atomically: true)
        do {
            try NSFileManager.defaultManager().removeItemAtPath(tmpath)
            //TODO: create thumbnail
        }catch{
            
        }
        return addPhotoForCategory(category, photoURI:uri)
    }
    
    static func addPhotoForCategory(category: CCCategory, photoURI: String) -> CCPhoto {
        let photo = NSEntityDescription.insertNewObjectForEntityForName("Photo",
            inManagedObjectContext: CCCoreUtil.managedObjectContext) as! CCPhoto
        photo.photoURI = photoURI

        category.photoCount = category.photoCount!.integerValue + 1
        category.mutableOrderedSetValueForKey("photoList").addObject(photo)
        
        do{
            try CCCoreUtil.managedObjectContext.save()
        }catch{
            NSLog("Save error!")
        }
        return photo
    }
    
    static func addUserPhoto(image: UIImage, refImage:UIImage){
        let photo = addPhotoForCategory(categories[0] as! CCCategory, image: image)
        
        let uri =  photo.photoURI! + "_ref"
        let path = "\(NSHomeDirectory())/Documents/\(uri).jpg"
        let imgData: NSData = UIImageJPEGRepresentation(refImage, 0)!
        imgData.writeToFile(path, atomically: true)
        
        photo.refPhotoURI = uri
        do{
            try CCCoreUtil.managedObjectContext.save()
        }catch{
            NSLog("Save error!")
        }

    }
    
    // Delete
    static func removePhotoForCategory(category: CCCategory, photo: CCPhoto){
        category.mutableOrderedSetValueForKey("photoList").removeObject(photo)
        CCCoreUtil.managedObjectContext.deleteObject(photo)
        do{
            try CCCoreUtil.managedObjectContext.save()
        }catch{
            NSLog("Save error!")
        }
    }
}