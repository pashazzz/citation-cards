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
    func getWidgetTags() -> [Tag]
    func addWidgetTag(_: Tag)
    func removeWidgetTag(_: Tag)
    func getWidgetOnlyFavourites() -> Bool
    func setWidgetOnlyFavourites(val: Bool)
}

class Settings: SettingsProtocol {
    let storage = Storage()

    let standardStorage = UserDefaults.standard
    let widgetStorage = UserDefaults(suiteName: "group.com.sky-labs.Citation-cards")
    
    // MARK: Home page Sort order
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
    
    // MARK: Home page Only favourites
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
    
    // MARK: Widget Update interval
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
    
    // MARK: Widget Tags
    public func getWidgetTags() -> [Tag] {
        let tagsStringArr = (widgetStorage?.string(forKey: "widgetTags") ?? "")
            .split(separator: ";")
            .map(String.init)
        let allTags = storage.getAllTags()
        let included: [Tag] = allTags.filter {tag in
            tagsStringArr.contains(tag.tag!)
        }
        
        return included
    }
    public func addWidgetTag(_ tag: Tag) {
        var tagsStringArr = (widgetStorage?.string(forKey: "widgetTags") ?? "")
            .split(separator: ";")
            .map(String.init)
        tagsStringArr.append(tag.tag!)
        widgetStorage?.setValue(tagsStringArr.joined(separator: ";"), forKey: "widgetTags")
    }
    public func removeWidgetTag(_ tag: Tag) {
        let tagsStringArr = (widgetStorage?.string(forKey: "widgetTags") ?? "")
            .split(separator: ";")
            .map(String.init)
        let updTagsStringArr = tagsStringArr.filter {t in
            t != tag.tag
        }
        widgetStorage?.setValue(updTagsStringArr.joined(separator: ";"), forKey: "widgetTags")
    }
    
    // MARK: Widget Only favourites
    public func getWidgetOnlyFavourites() -> Bool {
        return widgetStorage?.bool(forKey: "widgetOnlyFavourites") ?? false
    }
    public func setWidgetOnlyFavourites(val: Bool) {
        widgetStorage?.setValue(val, forKey: "widgetOnlyFavourites")
    }
    
}
