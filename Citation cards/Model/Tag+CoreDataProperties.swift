//
//  Tag+CoreDataProperties.swift
//  Citation cards
//
//  Created by Pavlo Malyshkin on 1.11.2023.
//
//

import Foundation
import CoreData


extension Tag {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tag> {
        return NSFetchRequest<Tag>(entityName: "Tag")
    }

    @NSManaged public var tag: String?
    @NSManaged public var color: String?
    @NSManaged public var tagToCitation: NSSet?

}

// MARK: Generated accessors for tagToCitation
extension Tag {

    @objc(addTagToCitationObject:)
    @NSManaged public func addToTagToCitation(_ value: Citation)

    @objc(removeTagToCitationObject:)
    @NSManaged public func removeFromTagToCitation(_ value: Citation)

    @objc(addTagToCitation:)
    @NSManaged public func addToTagToCitation(_ values: NSSet)

    @objc(removeTagToCitation:)
    @NSManaged public func removeFromTagToCitation(_ values: NSSet)

}

extension Tag : Identifiable {

}
