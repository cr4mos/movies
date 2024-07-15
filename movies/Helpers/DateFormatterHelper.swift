//
//  DateFormatterHelper.swift
//  movies
//
//  Created by Carlos Ramos on 15/07/24.
//

import Foundation

struct DateFormatterHelper {
    static func formattedDate(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateStyle = .medium
            return dateFormatter.string(from: date)
        }
        return dateString
    }
}
