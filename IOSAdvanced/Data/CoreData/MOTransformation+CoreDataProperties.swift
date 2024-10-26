//
//  MOTransformation+CoreDataProperties.swift
//  IOSAdvanced
//
//  Created by José Antonio Aravena on 26-10-24.
//
//

import Foundation
import CoreData


extension MOTransformation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MOTransformation> {
        return NSFetchRequest<MOTransformation>(entityName: "CDTransformation")
    }

    @NSManaged public var identifier: String?
    @NSManaged public var info: String?
    @NSManaged public var name: String?
    @NSManaged public var photo: String?
    @NSManaged public var hero: MOHero?

}

extension MOTransformation : Identifiable {

}
