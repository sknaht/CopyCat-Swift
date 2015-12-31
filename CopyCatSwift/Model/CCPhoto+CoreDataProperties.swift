//
//  CCPhoto+CoreDataProperties.swift
//  CopyCatSwift
//
//  Created by Baiqi Zhang on 12/29/15.
//  Copyright © 2015 Baiqi Zhang. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension CCPhoto {

    @NSManaged var id: NSNumber?
    @NSManaged var photoURI: String?
    @NSManaged var refPhotoURI: String?

}
