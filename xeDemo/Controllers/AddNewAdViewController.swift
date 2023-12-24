//
//  AddNewAdViewController.swift
//  xeDemo
//
//  Created by Dimitrios Dimitriadis on 21/12/23.
//

import UIKit

class AddNewAdViewController: UIViewController {

    private var vm = AddNewAdViewModel()
    private let HEADER_CELLS_NUMBER = 1
    private lazy var MAX_NUMBER_OF_TEXTFIELDS = AdCellType.allCases.count + HEADER_CELLS_NUMBER //Header

    private var areRequirementsFullfilled: Bool {
        !(vm.title?.isEmpty ?? true) || vm.isLocationValid
    }    

    private let btnsContainer = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()

    private lazy var confirmBtn = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGreen
        view.setTitleColor(.white, for: .normal)
        view.setTitle("Submit", for: .normal)
        view.titleLabel?.font = .boldSystemFont(ofSize: 12)
        view.layer.cornerRadius = 8
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(submitTapped)))
        return view
    }()

    private lazy var clearBtn = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemRed
        view.setTitleColor(.white, for: .normal)
        view.setTitle("Clear", for: .normal)
        view.titleLabel?.font = .boldSystemFont(ofSize: 12)
        view.layer.cornerRadius = 8
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clearTapped)))
        return view
    }()


    private lazy var tableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(CustomTextFieldsCell.self, forCellReuseIdentifier: CustomTextFieldsCell.identifier)
        view.register(HeaderCell.self, forCellReuseIdentifier: HeaderCell.identifier)
        view.bounces = false
        view.separatorStyle = .none
        view.dataSource = self
        view.delegate = self
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBinding()
    }

    private func setupUI() {

        view.backgroundColor = .white.withAlphaComponent(0.9)

        view.addSubview(btnsContainer)
        view.addSubview(tableView)
        btnsContainer.addSubview(confirmBtn)
        btnsContainer.addSubview(clearBtn)

        NSLayoutConstraint.activate([
            btnsContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            btnsContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            btnsContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            btnsContainer.heightAnchor.constraint(equalToConstant: 50),

            confirmBtn.bottomAnchor.constraint(equalTo: btnsContainer.bottomAnchor, constant: -5),
            confirmBtn.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25),
            confirmBtn.trailingAnchor.constraint(equalTo: btnsContainer.centerXAnchor, constant: -12.5),
            confirmBtn.heightAnchor.constraint(equalToConstant: 40),

            clearBtn.bottomAnchor.constraint(equalTo: btnsContainer.bottomAnchor, constant: -5),
            clearBtn.leadingAnchor.constraint(equalTo: btnsContainer.centerXAnchor, constant: 12.5),
            clearBtn.heightAnchor.constraint(equalToConstant: 40),
            clearBtn.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25),

            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: btnsContainer.topAnchor),
        ])
    }

    private func setupBinding() {
        
        vm.delegate = self

        vm.location.bind { [weak self] value in
            guard let self else { return }
            self.vm.getSearchedLocation {  _ in
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    reloadCell(cellType: .location)
                }
            }
        }

        vm.warningsToShow.bind { [weak self] value in
            guard let self else { return }
            let indexesToUpdate = value.compactMap { AdCellType.allCases.firstIndex(of: $0) }.map {Int($0)}
            reloadCell(indexesToUpdate: indexesToUpdate)
        }
    }

    func reloadCell(cellType: AdCellType) {
        guard let index = AdCellType.allCases.firstIndex(of: cellType) else { return }
        reloadCell(indexesToUpdate: [index])
    }

    func reloadCell(indexesToUpdate: [Int]) {

        var rowOfFirstResponder: Int?
        var IndexPathsToReload: [IndexPath] = []

        indexesToUpdate.forEach {
            let indexPath = IndexPath(row: $0 + HEADER_CELLS_NUMBER, section: 0)
            IndexPathsToReload.append(indexPath)
            if let cell = tableView.cellForRow(at: indexPath) as? CustomTextFieldsCell, cell.isFieldFirstResponder {
                rowOfFirstResponder = $0
            }
        }
        tableView.beginUpdates()
        tableView.reloadRows(at: IndexPathsToReload, with: .none)
        tableView.endUpdates()

        if let rowOfFirstResponder, let cellOfFirstResponder = tableView.cellForRow(at: IndexPath(row: rowOfFirstResponder + HEADER_CELLS_NUMBER, section: 0)) as? CustomTextFieldsCell {
            cellOfFirstResponder.makeViewFirstResponder(type: cellOfFirstResponder.typeOfCell)
        }
    }

    @objc private func clearTapped() {
        vm.clearData()
    }

    @objc private func submitTapped() {
        guard areRequirementsFullfilled else {
            showWarningMessages()
            return
        }
        vm.submitForm { body in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                let navigation = UIAlertController(title: body, message: nil, preferredStyle: .alert)
                navigation.addAction(UIAlertAction(title: "ok", style: .default))
                present(navigation, animated: true, completion: nil)
            }
        }
        vm.clearData()
    }

    private func showWarningMessages() {

        if vm.title?.isEmpty ?? true {
            vm.showWarningFor(.title)
        }

        if !vm.isLocationValid {
            vm.showWarningFor(.location)
        }
    }
}

extension AddNewAdViewController: AddNewAdDelegate {
    
    func locationSelected(location: SearchedLocation) {
        vm.byPassGetResults = true
        vm.location.value = location
    }
    

    func textFieldChanged(text: String, type: AdCellType) {
        switch type {
        case .title:
            vm.hideWarningFor(.title)
            vm.title = text
        case .location:
            vm.location.value = SearchedLocation(mainText: text)
            if vm.isLocationValid {
                vm.hideWarningFor(.location)
            }
        case .price:
            vm.price = text
            vm.isPriceValid || text.isEmpty ? vm.hideWarningFor(.price) : vm.showWarningFor(.price)
        case .description:
            vm.description = text
        }
        reloadCell(cellType: type)
    }

    func clearButtonTapped() {
        tableView.reloadData()
    }
}

extension AddNewAdViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        MAX_NUMBER_OF_TEXTFIELDS
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row != 0 else {
            return tableView.dequeueReusableCell(withIdentifier: HeaderCell.identifier) ?? UITableViewCell()
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTextFieldsCell.identifier) as? CustomTextFieldsCell else { return UITableViewCell() }
        let cellType = AdCellType.allCases[indexPath.row - HEADER_CELLS_NUMBER]
        cell.config(vm: vm, type: cellType, delegate: self)
        return cell
    }
}
