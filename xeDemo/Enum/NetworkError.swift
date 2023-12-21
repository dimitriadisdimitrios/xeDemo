//
//  NetworkError.swift
//  xeDemo
//
//  Created by Dimitrios Dimitriadis on 21/12/23.
//

import Foundation

enum NetworkError: Error {
    case decodingError
    case domainError
    case urlError
}
