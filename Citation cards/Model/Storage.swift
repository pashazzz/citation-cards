//
//  Storage.swift
//  Citation cards
//
//  Created by Pavlo Malyshkin on 1.11.2023.
//

import UIKit

protocol StorageProtocol {
    func getAllCitations() -> [Citation]
    func saveCitation(_ item: (text: String, author: String?, source: String?)) -> Void
}

class Storage: StorageProtocol {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func getAllCitations() -> [Citation] {
        var items: [Citation] = []
        do {
            items = try context.fetch(Citation.fetchRequest())
        } catch {
            return []
        }
        return items
    }
    
    func saveCitation(_ item: (text: String, author: String?, source: String?)) {
        let citation = Citation(context: context)
        citation.text = item.text
        citation.author = item.author
        citation.source = item.source
        citation.createdAt = Date()
        citation.updatedAt = Date()
        do {
            try context.save()
        } catch {
            //
        }
    }
}
