//
//  Citation+CoreDataProperties.swift
//  Citation cards
//
//  Created by Pavlo Malyshkin on 1.11.2023.
//
//

import Foundation
import CoreData


extension Citation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Citation> {
        return NSFetchRequest<Citation>(entityName: "Citation")
    }

    @NSManaged public var text: String?
    @NSManaged public var author: String?
    @NSManaged public var source: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var isFavourite: Bool
    @NSManaged public var citationToTag: NSSet?

}

// MARK: Generated accessors for citationToTag
extension Citation {

    @objc(addCitationToTagObject:)
    @NSManaged public func addToCitationToTag(_ value: Tag)

    @objc(removeCitationToTagObject:)
    @NSManaged public func removeFromCitationToTag(_ value: Tag)

    @objc(addCitationToTag:)
    @NSManaged public func addToCitationToTag(_ values: NSSet)

    @objc(removeCitationToTag:)
    @NSManaged public func removeFromCitationToTag(_ values: NSSet)

}

extension Citation : Identifiable {

}
