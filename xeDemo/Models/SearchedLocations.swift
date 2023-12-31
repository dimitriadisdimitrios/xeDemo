//
//  SearchedLocations.swift
//  xeDemo
//
//  Created by Dimitrios Dimitriadis on 22/12/23.
//

import Foundation

struct SearchedLocation: Codable {

    let placeId: String
    let mainText: String
    let secondaryText: String
    
    init() {
        placeId = ""
        mainText = ""
        secondaryText = ""
    }

    init(mainText: String) {
        placeId = ""
        self.mainText = mainText
        secondaryText = ""
    }

    init(placeId: String, mainText: String, secondaryText: String) {
        self.placeId = placeId
        self.mainText = mainText
        self.secondaryText = secondaryText
    }

    static func create(textToSearch: String, vm: AddNewAdViewModel) -> Resource<[SearchedLocation]> {

        guard let url = URL(string: "https://4ulq3vb3dogn4fatjw3uq7kqby0dweob.lambda-url.eu-central-1.on.aws/?input=\(textToSearch)") else {
            fatalError("Url is not correct")
        }

        var resource = Resource<[SearchedLocation]>(url: url)
        resource.httpMethod = .get
        return resource
    }
}
