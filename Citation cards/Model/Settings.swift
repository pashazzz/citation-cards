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
    func getOnlyFavourites() -> Bool
    func setOnlyFavourites(_: Bool) -> Void
    func getWidgetUpdateInterval() -> TimeInterval
    func setWidgetUpdateInterval(interval: TimeInterval) -> Void
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
    
    public func getOnlyFavourites() -> Bool {
        var onlyFavourites = storage.value(forKey: "displayOnlyFavourites") as? Bool
        if onlyFavourites == nil {
            onlyFavourites = false
            setOnlyFavourites(false)
        }
        return onlyFavourites!
    }
    public func setOnlyFavourites(_ isTrue: Bool) {
        storage.setValue(isTrue, forKey: "displayOnlyFavourites")
    }
    
    public func getWidgetUpdateInterval() -> TimeInterval {
        let val = storage.double(forKey: "widgetUpdateInterval")
        if val == 0 {
            setWidgetUpdateInterval(interval: 43200.0)
            return TimeInterval(floatLiteral: 43200.0)
        }
        return val
    }
    public func setWidgetUpdateInterval(interval: TimeInterval) -> Void {
        storage.setValue(interval, forKey: "widgetUpdateInterval")
    }
}
