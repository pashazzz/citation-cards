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

protocol StorageProtocol {
    func getAllCitations(inOrder: SortOrder) -> [Citation]
    func getFavouriteCitations(inOrder: SortOrder) -> [Citation]
    func getArchivedCitations() -> [Citation]
    func saveCitation(_ item: CitationForSaveProtocol) -> Void
    func editCitation(_ item: Citation, needToModifyDate: Bool) -> Void
    func archiveCitation(_ item: Citation) -> Void
    func restoreCitation(_ item: Citation) -> Void
    func removeCitation(_ item: Citation) -> Void
    func clearArchivedCitations() -> Void
}

class Storage: StorageProtocol {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let notArchivedPredicate = NSPredicate(format: "archivedAt == NULL")
    
    func getAllCitations(inOrder: SortOrder) -> [Citation] {
        var items: [Citation] = []
        let fetchRequest: NSFetchRequest<Citation> = Citation.fetchRequest()
        let createdAtSortDescriptor = NSSortDescriptor(key: "updatedAt", ascending: inOrder == SortOrder.newestFirst ? false : true)
        fetchRequest.predicate = notArchivedPredicate
        fetchRequest.sortDescriptors = [createdAtSortDescriptor]
        do {
            items = try context.fetch(fetchRequest)
        } catch {
            return []
        }
        return items
    }
    
    func getFavouriteCitations(inOrder: SortOrder) -> [Citation] {
        var items: [Citation] = []
        let fetchRequest: NSFetchRequest<Citation> = Citation.fetchRequest()
        let createdAtSortDescriptor = NSSortDescriptor(key: "updatedAt", ascending: inOrder == SortOrder.newestFirst ? false : true)
        let isFavouritePredicate = NSPredicate(format: "isFavourite == 1")
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            isFavouritePredicate,
            notArchivedPredicate
        ])
        fetchRequest.sortDescriptors = [createdAtSortDescriptor]
        do {
            items = try context.fetch(fetchRequest)
        } catch {
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
            //
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
    
    func removeCitation(_ item: Citation) {
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
}
