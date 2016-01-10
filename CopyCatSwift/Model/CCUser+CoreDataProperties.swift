//
//  CCUser+CoreDataProperties.swift
//  CopyCatSwift
//
//  Created by Baiqi Zhang on 1/5/16.
//  Copyright © 2016 Baiqi Zhang. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension CCUser {

    @NSManaged var name: String?
    @NSManaged var token: String?

}
