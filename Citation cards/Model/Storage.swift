//
//  Storage.swift
//  Citation cards
//
//  Created by Pavlo Malyshkin on 1.11.2023.
//

import UIKit

protocol CitationForSaveProtocol {
    var text: String {get}
    var author: String {get}
    var source: String {get}
    var isFavourite: Bool {get}
}

class CitationForSave: CitationForSaveProtocol {
    var text: String
    var author: String
    var source: String
    var isFavourite: Bool
    init(text: String, author: String = "", source: String = "", isFavourite: Bool = false) {
        self.text = text
        self.author = author
        self.source = source
        self.isFavourite = isFavourite
    }
}

protocol StorageProtocol {
    func getAllCitations() -> [Citation]
    func saveCitation(_ item: CitationForSaveProtocol) -> Void
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
    
    func saveCitation(_ item: CitationForSaveProtocol) {
        let citation = Citation(context: context)
        citation.text = item.text
        citation.author = item.author
        citation.source = item.source
        citation.isFavourite = item.isFavourite
        citation.createdAt = Date()
        citation.updatedAt = Date()
        do {
            try context.save()
        } catch {
            //
        }
    }
}
