//
//  DateTimeHelper.swift
//  Citation cards
//
//  Created by Pavlo Malyshkin on 7.11.2023.
//

import Foundation

class DateTimeHelper {
    static func getDateTimeString(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY.MM.dd HH:mm"
        
        return dateFormatter.string(from: date)
    }
}
