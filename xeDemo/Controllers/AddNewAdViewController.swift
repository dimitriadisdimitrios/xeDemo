//
//  AddNewAdViewController.swift
//  xeDemo
//
//  Created by Dimitrios Dimitriadis on 21/12/23.
//

import UIKit

class AddNewAdViewController: UIViewController {

    private var vm = AddNewAdViewModel()
    private let MAX_NUMBER_OF_TEXTFIELDS = AdCellType.allCases.count

    private var areRequirementsFullfilled: Bool {
        !(vm.title?.isEmpty ?? true) || vm.isLocationValid
    }

    private let titleLabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .boldSystemFont(ofSize: 17)
        view.textColor = .black
        view.numberOfLines = 0
        view.text = "New Property Classified"
        return view
    }()

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

        view.addSubview(titleLabel)
        view.addSubview(btnsContainer)
        view.addSubview(tableView)
        btnsContainer.addSubview(confirmBtn)
        btnsContainer.addSubview(clearBtn)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 20),

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
            self.vm.getSearchedLocation { result in
                print("")
            }
        }

        vm.price.bind { [weak self] value in
            guard let self else { return }
            tableView.beginUpdates()
            vm.isPriceValid ? vm.hideWarningFor(.price) : vm.showWarningFor(.price)
            tableView.endUpdates()
        }

        vm.warningsToShow.bind { [weak self] value in
            self?.tableView.reloadData()
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
        //FIXME: Open new vc to show the json
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

    func textFieldChanged(text: String, type: AdCellType) {
        switch type {
        case .title:
            vm.hideWarningFor(.title)
            vm.title = text
        case .location:
            vm.setLocation(text)
            if vm.isLocationValid {
                vm.hideWarningFor(.location)
            }
        case .price:
            vm.price.value = text
        case .description:
            vm.description = text
        }
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTextFieldsCell.identifier) as? CustomTextFieldsCell else { return UITableViewCell() }
        cell.backgroundColor = .brown
        let cellType = AdCellType.allCases[indexPath.row]
        cell.config(vm: vm, type: cellType, delegate: self)
        return cell
    }
}
