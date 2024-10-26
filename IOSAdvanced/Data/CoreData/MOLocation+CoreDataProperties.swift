//
//  MOLocation+CoreDataProperties.swift
//  IOSAdvanced
//
//  Created by José Antonio Aravena on 26-10-24.
//
//

import Foundation
import CoreData


extension MOLocation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MOLocation> {
        return NSFetchRequest<MOLocation>(entityName: "CDLocation")
    }

    @NSManaged public var date: String?
    @NSManaged public var identifier: String?
    @NSManaged public var latitude: String?
    @NSManaged public var longitude: String?
    @NSManaged public var hero: MOHero?

}

extension MOLocation : Identifiable {

}
