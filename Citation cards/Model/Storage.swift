//
//  Storage.swift
//  Citation cards
//
//  Created by Pavlo Malyshkin on 1.11.2023.
//

import UIKit
import CoreData

protocol CitationForSaveProtocol {
    var text: String {get set}
    var author: String {get set}
    var source: String {get set}
    var isFavourite: Bool {get set}
}

struct CitationForSave: CitationForSaveProtocol {
    var text: String = ""
    var author: String = ""
    var source: String = ""
    var isFavourite: Bool = false
}

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
    func saveCitation(_ item: CitationForSaveProtocol) -> Void
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
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
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
    
    func saveCitation(_ item: CitationForSaveProtocol) {
        let date = Date()
        let citation = Citation(context: context)
        citation.text = item.text
        citation.author = item.author
        citation.source = item.source
        citation.isFavourite = item.isFavourite
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
