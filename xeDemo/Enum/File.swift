//
//  File.swift
//  xeDemo
//
//  Created by Dimitrios Dimitriadis on 23/12/23.
//

import Foundation

enum AdCellType: CaseIterable {

    case title
    case location
    case price
    case description

    var warningMessage: String {
        switch self {
        case .title:
            return "Title is mandatory field. It can be empty"
        case .location:
            return "You must pick one location from the drop down dialog to be valid that field"
        case .price:
            return "Invalid price (ex: 12,34)"
        case .description:
            return ""
        }
    }

    var tilte: String {
        switch self {
        case .title:
            return "Title"
        case .location:
            return "Location"
        case .price:
            return "Price (€)"
        case .description:
            return "Description"
        }

    }
}
