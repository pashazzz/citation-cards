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
    func saveCitation(_ item: CitationForSaveProtocol) -> Void
    func editCitation(_ item: Citation) -> Void
    func removeCitation(_ item: Citation) -> Void
}

class Storage: StorageProtocol {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func getAllCitations(inOrder: SortOrder) -> [Citation] {
        var items: [Citation] = []
        let fetchRequest: NSFetchRequest<Citation> = Citation.fetchRequest()
        let createdAtSortDescriptor = NSSortDescriptor(key: "createdAt", ascending: inOrder == SortOrder.newestFirst ? false : true)
        fetchRequest.sortDescriptors = [createdAtSortDescriptor]
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
    
    func editCitation(_ item: Citation) {
        item.updatedAt = Date()
        do {
            try context.save()
        } catch {
            print("Cannot edit item: \(String(describing: item.id)), \(String(describing: item.text))")
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
}
