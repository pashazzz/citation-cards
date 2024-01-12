//
//  TagsHelper.swift
//  Citation cards
//
//  Created by Pavlo Malyshkin on 12.1.2024.
//

import Foundation

class TagsHelper {
    static func getOnlyActualCitationsFrom(_ tag: Tag) -> [Citation] {
        let citations = tag.tagToCitation?.allObjects as! [Citation]
        return citations.filter({$0.archivedAt == nil})
    }
    static func getOnlyArchivedCitationsFrom(_ tag: Tag) -> [Citation] {
        let citations = tag.tagToCitation?.allObjects as! [Citation]
        return citations.filter({$0.archivedAt != nil})
    }
}
