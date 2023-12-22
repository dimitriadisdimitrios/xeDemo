//
//  DynamicVar.swift
//  xeDemo
//
//  Created by Dimitrios Dimitriadis on 22/12/23.
//

import Foundation

class DynamicVar<T> {

    private var listener: ((T) -> Void)?
    var value: T {
        didSet {
            listener?(value)
        }
    }

    init(_ value: T) {
        self.value = value
    }

    func bind(callback: @escaping ((T) -> Void)) {
        listener = callback
    }
    
}
