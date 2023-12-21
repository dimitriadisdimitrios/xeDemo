//
//  Resource.swift
//  xeDemo
//
//  Created by Dimitrios Dimitriadis on 21/12/23.
//
import Foundation

struct Resource<T: Codable> {
    var url: URL
    var httpMethod: HTTPMethod = .get
    var body: Data? = nil
}
