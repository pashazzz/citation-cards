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
    let standardStorage = UserDefaults.standard
    let widgetStorage = UserDefaults(suiteName: "group.com.sky-labs.Citation-cards")
    
    // by default use 'newestFirst'
    public func getSortOrder() -> SortOrder {
        var order = standardStorage.string(forKey: "order")
        if order == nil {
            order = "newestFirst"
            setSortOrder(order: SortOrder(rawValue: order!)!)
        }
        return SortOrder(rawValue: order!)!
    }
    
    public func setSortOrder(order: SortOrder) {
        standardStorage.setValue(order.rawValue, forKey: "order")
    }
    
    public func getOnlyFavourites() -> Bool {
        var onlyFavourites = standardStorage.value(forKey: "displayOnlyFavourites") as? Bool
        if onlyFavourites == nil {
            onlyFavourites = false
            setOnlyFavourites(false)
        }
        return onlyFavourites!
    }
    public func setOnlyFavourites(_ isTrue: Bool) {
        standardStorage.setValue(isTrue, forKey: "displayOnlyFavourites")
    }
    
    public func getWidgetUpdateInterval() -> TimeInterval {
        let val = widgetStorage?.double(forKey: "widgetUpdateInterval")
        if val == nil || val == 0 {
            setWidgetUpdateInterval(interval: 43200.0)
            return TimeInterval(floatLiteral: 43200.0)
        }
        
        return val!
    }
    public func setWidgetUpdateInterval(interval: TimeInterval) -> Void {
        widgetStorage?.setValue(interval, forKey: "widgetUpdateInterval")
    }
}
