//
//  NewAdForSubmit.swift
//  xeDemo
//
//  Created by Dimitrios Dimitriadis on 23/12/23.
//

import Foundation

struct NewAdForSubmit: Codable {
    let title: String
    let placeId: String
    let price: Float?
    let description: String
}
