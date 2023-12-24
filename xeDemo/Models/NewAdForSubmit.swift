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
    let price: String
    let description: String

    init(vm: AddNewAdViewModel) {
        title = vm.title ?? ""
        placeId = vm.location.value.placeId
        price = vm.price
        description = vm.description ?? ""
    }

    static func createForSubmit(vm: AddNewAdViewModel) -> Resource<[SearchedLocation]> {

        let objForSubmit = NewAdForSubmit(vm: vm)

        guard let url = URL(string: "https://4ulq3vb3dogn4fatjw3uq7kqby0dweob.lambda-url.eu-central-1.on.aws") else {
            fatalError("Url is not correct")
        }

        guard let data = try? JSONEncoder().encode(objForSubmit) else {
            fatalError("Sometrhing went wrong with encoding")
        }

        var resource = Resource<[SearchedLocation]>(url: url)
        resource.httpMethod = .post
        resource.body = data
        return resource
    }
}
