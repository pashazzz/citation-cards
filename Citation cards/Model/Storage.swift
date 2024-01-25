//
//  Storage.swift
//  Citation cards
//
//  Created by Pavlo Malyshkin on 1.11.2023.
//

import UIKit
import CoreData

protocol TagForSaveProtocol {
    var tag: String {get set}
}

struct TagForSave: TagForSaveProtocol {
    var tag: String = ""
}

protocol StorageProtocol {
    func getAllCitations(inOrder: SortOrder) -> [Citation]
    func getFavouriteCitations(inOrder: SortOrder) -> [Citation]
    func getArchivedCitations() -> [Citation]
    func getRandomCitation(onlyFavourites: Bool, withTags: [Tag]) -> Citation?
    func prepareCitation() -> Citation
    func saveCitation(_ item: Citation) -> Void
    func editCitation(_ item: Citation, needToModifyDate: Bool) -> Void
    func archiveCitation(_ item: Citation) -> Void
    func restoreCitation(_ item: Citation) -> Void
    func deleteCitation(_ item: Citation) -> Void
    func clearArchivedCitations() -> Void
    
    func getAllTags() -> [Tag]
    func createTag(_ item: TagForSaveProtocol) -> Void
    func editTag(_ item: Tag) -> Void
    func deleteTag(_ item: Tag) -> Void
}

class Storage: StorageProtocol {
    let context: NSManagedObjectContext = Persistent.context

    let notArchivedPredicate = NSPredicate(format: "archivedAt == NULL")

    // MARK: Citations
    func getAllCitations(inOrder: SortOrder) -> [Citation] {
        var items: [Citation] = []
        let fetchRequest: NSFetchRequest<Citation> = Citation.fetchRequest()
        let updatedAtSortDescriptor = NSSortDescriptor(key: "updatedAt", ascending: inOrder == SortOrder.newestFirst ? false : true)
        fetchRequest.predicate = notArchivedPredicate
        fetchRequest.sortDescriptors = [updatedAtSortDescriptor]
        do {
            items = try context.fetch(fetchRequest)
        } catch {
            print("Cannot get all citations")
            print(error)
            return []
        }
        return items
    }
    
    func getFavouriteCitations(inOrder: SortOrder) -> [Citation] {
        var items: [Citation] = []
        let fetchRequest: NSFetchRequest<Citation> = Citation.fetchRequest()
        let updatedAtSortDescriptor = NSSortDescriptor(key: "updatedAt", ascending: inOrder == SortOrder.newestFirst ? false : true)
        let isFavouritePredicate = NSPredicate(format: "isFavourite == 1")
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            isFavouritePredicate,
            notArchivedPredicate
        ])
        fetchRequest.sortDescriptors = [updatedAtSortDescriptor]
        do {
            items = try context.fetch(fetchRequest)
        } catch {
            print("Cannot get favourites citations")
            print(error)
            return []
        }
        return items
    }
    
    func getArchivedCitations() -> [Citation] {
        var items: [Citation] = []
        let fetchRequest: NSFetchRequest<Citation> = Citation.fetchRequest()
        let archivedAtSortDescriptor = NSSortDescriptor(key: "archivedAt", ascending: false)
        let isArchivedPredicate = NSPredicate(format: "archivedAt != nil")
        fetchRequest.predicate = isArchivedPredicate
        fetchRequest.sortDescriptors = [archivedAtSortDescriptor]
        do {
            items = try context.fetch(fetchRequest)
        } catch {
            print("Cannot get archived citations")
            print(error)
            return []
        }
        return items
    }
    
    func getRandomCitation(
        onlyFavourites: Bool,
        withTags: [Tag]
    ) -> Citation? {
        let fetchRequest: NSFetchRequest<Citation> = Citation.fetchRequest()
        var predicates: [NSPredicate] = [notArchivedPredicate]
        if onlyFavourites {
            let isFavouritePredicate = NSPredicate(format: "isFavourite == 1")
            predicates.append(isFavouritePredicate)
        }
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        
        // find out how many items are there
        let totalResults = try! context.count(for: fetchRequest)
        guard totalResults > 0 else { return nil }

        var res = try! context.fetch(fetchRequest)
        if withTags.count > 0 {
            res = onlyWithTags(citations: res, withTags: withTags)
            guard res.count == 0 else { return nil }
        }

        // randomlize offset
        let randomIndex = Int.random(in: 0 ..< res.count)
        
        return res[randomIndex]
    }
    
    private func onlyWithTags(citations: [Citation], withTags: [Tag]) -> [Citation] {
        let result: [Citation] = citations.filter { citation in
            for tag in withTags {
                let isContains = citation.citationToTag?.contains(tag)
                if isContains != nil && isContains != false {
                    return true
                }
            }
            return false
        }
        
        return result
    }
    
    func prepareCitation() -> Citation {
        let preparedCitation = NSEntityDescription.insertNewObject(forEntityName: "Citation", into: context) as! Citation
        
        return preparedCitation
    }
    
    func saveCitation(_ citation: Citation) {
        let date = Date()
        citation.createdAt = date
        citation.updatedAt = date
        do {
            try context.save()
        } catch {
            print("Cannot save citation")
            print(error)
        }
    }
    
    func editCitation(_ item: Citation, needToModifyDate: Bool = true) {
        if needToModifyDate {
            item.updatedAt = Date()
        }
        do {
            try context.save()
        } catch {
            print("Cannot edit item: \(String(describing: item.id)), \(String(describing: item.text))")
            print(error)
        }
    }
    
    func archiveCitation(_ item: Citation) {
        item.archivedAt = Date()
        do {
            try context.save()
        } catch {
            print("Cannot archive item: \(item.id), \(String(describing: item.text))")
            print(error)
        }
    }
    
    func restoreCitation(_ item: Citation) {
        item.archivedAt = nil
        do {
            try context.save()
        } catch {
            print("Cannot archive item: \(item.id), \(String(describing: item.text))")
            print(error)
        }
    }
    
    func deleteCitation(_ item: Citation) {
        context.delete(item)
        do {
            try context.save()
        } catch {
            print("Cannot delete item: \(item.id), \(String(describing: item.text))")
            print(error)
        }
    }
    
    func clearArchivedCitations() {
        var items: [Citation] = []
        let fetchRequest: NSFetchRequest<Citation> = Citation.fetchRequest()
        let isArchivedPredicate = NSPredicate(format: "archivedAt != nil")
        fetchRequest.predicate = isArchivedPredicate
        do {
            items = try context.fetch(fetchRequest)
            for item in items {
                context.delete(item)
            }
            try context.save()
        } catch {
            print("Cannot clear archived citations")
            print(error)
        }
    }
    
    // MARK: Tags
    func getAllTags() -> [Tag] {
        var items: [Tag] = []
        let fetchRequest: NSFetchRequest<Tag> = Tag.fetchRequest()
        do {
            items = try context.fetch(fetchRequest)
        } catch {
            print("Cannot get all tags")
            print(error)
            return []
        }
        return items
    }
    
    func createTag(_ item: TagForSaveProtocol) {
        let tag = Tag(context: context)
        tag.tag = item.tag
        tag.createdAt = Date()
        do {
            try context.save()
        } catch {
            print("Cannot save tag")
            print(error)
        }
    }
    
    func editTag(_ item: Tag) {
        do {
            try context.save()
        } catch {
            print("Cannot edit tag: \(String(describing: item.id)), \(String(describing: item.tag))")
            print(error)
        }
    }
    
    func deleteTag(_ item: Tag) {
        context.delete(item)
        do {
            try context.save()
        } catch {
            print("Cannot delete tag: \(item.id), \(String(describing: item.tag))")
            print(error)
        }
    }
}
