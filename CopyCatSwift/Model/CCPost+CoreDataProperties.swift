//
//  CCPost+CoreDataProperties.swift
//  CopyCatSwift
//
//  Created by Baiqi Zhang on 12/22/15.
//  Copyright © 2015 Baiqi Zhang. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension CCPost {

    @NSManaged var likeCount: NSNumber?
    @NSManaged var liked: NSNumber?
    @NSManaged var photoURI: String?
    @NSManaged var pinCount: NSNumber?
    @NSManaged var postId: NSNumber?
    @NSManaged var photo: CCPhoto?
    @NSManaged var user: CCUser?

}
