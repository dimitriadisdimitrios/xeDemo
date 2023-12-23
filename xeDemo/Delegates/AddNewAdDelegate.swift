//
//  AddNewAddDelegate.swift
//  xeDemo
//
//  Created by Dimitrios Dimitriadis on 21/12/23.
//

import Foundation

protocol AddNewAdDelegate: AnyObject {

    func textFieldChanged(text: String, type: AdCellType)
    func clearButtonTapped()
}
