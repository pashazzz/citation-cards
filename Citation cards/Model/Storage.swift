//
//  Storage.swift
//  Citation cards
//
//  Created by Pavlo Malyshkin on 1.11.2023.
//

import UIKit

protocol StorageProtocol {
    func getAllCitations() -> [Citation]
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
}
