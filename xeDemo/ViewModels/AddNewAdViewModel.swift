//
//  AddNewAdViewModel.swift
//  xeDemo
//
//  Created by Dimitrios Dimitriadis on 21/12/23.
//

import Foundation

class AddNewAdViewModel {
    
    var title: String?
    var location = DynamicVar("")
    var price: Float?
    var description: String?

    func getSearchedLocation(callback: @escaping([SearchedLocation]) -> Void) {
        guard location.value.count > 2 else {
            return
        }
        WebService().load(resource: SearchedLocation.create(textToSearch: location.value, vm: self)) { result in
            switch result {
            case .success(let locations):
                callback(locations)
            case .failure(let error):
                print(error)
            }
        }
    }
}
