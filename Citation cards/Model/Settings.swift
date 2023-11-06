//
//  Settings.swift
//  Citation cards
//
//  Created by Pavlo Malyshkin on 6.11.2023.
//

import Foundation

enum SortOrder: String {
    case newestFirst
    case oldestFirst
}

protocol SettingsProtocol {
    func getSortOrder() -> SortOrder
    func setSortOrder(order: SortOrder) -> Void
}

class Settings: SettingsProtocol {
    let storage = UserDefaults.standard
    
    // by default use 'newestFirst'
    public func getSortOrder() -> SortOrder {
        var order = storage.string(forKey: "order")
        if order == nil {
            order = "newestFirst"
            setSortOrder(order: SortOrder(rawValue: order!)!)
        }
        return SortOrder(rawValue: order!)!
    }
    
    public func setSortOrder(order: SortOrder) {
        storage.setValue(order.rawValue, forKey: "order")
    }
}
