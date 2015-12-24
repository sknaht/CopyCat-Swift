//
//  CoreUtil.swift
//  CopyCatSwift
//
//  Created by Baiqi Zhang on 12/19/15.
//  Copyright © 2015 Baiqi Zhang. All rights reserved.
//

import UIKit
import CoreData

class CCCoreUtil{
    // Retreive the managedObjectContext from AppDelegate
    static let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    private static var categoryList = NSMutableArray()
    
    static let fontSizeS = CGFloat((NSLocalizedString("FontSizeS", comment:"FontSizeS")as NSString).floatValue)
    
    static var hasInitialized = false
    
    static var categories : NSMutableArray{
        get{
            if CCCoreUtil.hasInitialized {
                hasInitialized = true
                let categoriesFetch = NSFetchRequest(entityName: "Category")
                
                do{
                    let list = try CCCoreUtil.managedObjectContext.executeFetchRequest(categoriesFetch) as NSArray
                    NSLog("categoryList:%@\ncount:%d", list, list.count)
                    self.categoryList = list.mutableCopy() as! NSMutableArray
                }catch{
                    NSLog("Not found")
                }
                return categoryList
            }
            return categoryList
        }
    }
    
    static func addCategory(category: CCCategory){
        CCCoreUtil.categoryList.addObject(category)
    }
    
    static func addCategory(name: String){
        let category = NSEntityDescription.insertNewObjectForEntityForName("Category",
            inManagedObjectContext: CCCoreUtil.managedObjectContext) as! CCCategory
        category.name = name
        category.photoCount = random() % 100
        CCCoreUtil.categoryList.addObject(category)
        
        do{
            try CCCoreUtil.managedObjectContext.save()
        }catch{
            NSLog("Save error!")
        }
    }
}