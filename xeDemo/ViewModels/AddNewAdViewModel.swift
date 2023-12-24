//
//  AddNewAdViewModel.swift
//  xeDemo
//
//  Created by Dimitrios Dimitriadis on 21/12/23.
//

import Foundation

class AddNewAdViewModel {

    var title: String?
    var location: DynamicVar<SearchedLocation> = DynamicVar(SearchedLocation())
    var price: String = ""
    var description: String?
    var warningsToShow: DynamicVar<[AdCellType]> = DynamicVar([])

    weak var delegate: AddNewAdDelegate?

    lazy var isWarningActivateFor: (AdCellType) -> Bool = { [weak self] type in
        guard let self else { return false }
        return warningsToShow.value.contains(where: { $0 == type })
    }

    var isLocationValid:  Bool {
        location.value.mainText != "" && location.value.placeId != ""
    }

    var isPriceValid: Bool {
        guard let regex = try? NSRegularExpression(pattern: "^\\d+((\\.|,)\\d+){0,1}$", options: []) else { return false }
        let matches = regex.matches(in: "\(price)", options: [], range: NSRange(location: 0, length: "\(price)".utf16.count))
        return !matches.isEmpty
    }

    var isFieldWithDyncamicHeight: (AdCellType)->Bool = { type in
        type == .description
    }

    var heightForTextfield: (AdCellType)->CGFloat = { type in
        type == .description ? 80 : 30
    }

    func getSearchedLocation(callback: @escaping([SearchedLocation]) -> Void) {
        guard location.value.mainText.count > 2 else {
            return
        }
        WebService.load(resource: SearchedLocation.create(textToSearch: location.value.mainText, vm: self)) { result in
            switch result {
            case .success(let locations):
                callback(locations)
            case .failure(let error):
                print(error)
            }
        }
    }

    func clearData() {
        title = ""
        location.value = SearchedLocation()
        price = ""
        description = ""
        warningsToShow.value = []
        delegate?.clearButtonTapped()
    }


    func setLocation(_ text: String) {
        //FIXME: Set the right location instead of this
        //FIXME: Add locationObject in vm
        location.value = SearchedLocation(mainText: text)
    }

    func showWarningFor(_ type: AdCellType) {
        guard !warningsToShow.value.contains(where: { $0 == type}) else { return }
        warningsToShow.value.append(type)
    }

    func hideWarningFor(_ type: AdCellType) {
        warningsToShow.value.removeAll(where: { $0 == type})
    }

    func hideAllWarnings() {
        warningsToShow.value.removeAll()
    }
}
