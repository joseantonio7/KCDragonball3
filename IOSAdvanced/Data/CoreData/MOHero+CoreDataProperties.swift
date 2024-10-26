//
//  MOHero+CoreDataProperties.swift
//  IOSAdvanced
//
//  Created by José Antonio Aravena on 26-10-24.
//
//

import Foundation
import CoreData


extension MOHero {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MOHero> {
        return NSFetchRequest<MOHero>(entityName: "CDHero")
    }

    @NSManaged public var favorite: Bool
    @NSManaged public var identifier: String?
    @NSManaged public var info: String?
    @NSManaged public var name: String?
    @NSManaged public var photo: String?
    @NSManaged public var locations: MOLocation?
    @NSManaged public var transformations: MOTransformation?

}

extension MOHero : Identifiable {

}
