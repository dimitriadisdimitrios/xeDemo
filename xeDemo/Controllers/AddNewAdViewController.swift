//
//  AddNewAdViewController.swift
//  xeDemo
//
//  Created by Dimitrios Dimitriadis on 21/12/23.
//

import UIKit

class AddNewAdViewController: UIViewController {

    private let titleLabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .boldSystemFont(ofSize: 17)
        view.textColor = .black
        view.numberOfLines = 0
        view.text = "New Property Classified"
        return view
    }()

    private let confirmBtn = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGreen
        view.setTitleColor(.white, for: .normal)
        view.setTitle("Submit", for: .normal)
        view.titleLabel?.font = .boldSystemFont(ofSize: 12)
        view.layer.cornerRadius = 8
        return view
    }()

    private let clearBtn = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemRed
        view.setTitleColor(.white, for: .normal)
        view.setTitle("Clear", for: .normal)
        view.titleLabel?.font = .boldSystemFont(ofSize: 12)
        view.layer.cornerRadius = 8
        return view
    }()

    private let titleTextField = {
        let view = CustomTextFields()
        view.config(title: "Title")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let locationTextField = {
        let view = CustomTextFields()
        view.config(title: "Location")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let priceTextField = {
        let view = CustomTextFields()
        view.config(title: "Price")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let descriptionTextField = {
        let view = CustomTextFields()
        view.config(title: "Description")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {

        view.backgroundColor = .white.withAlphaComponent(0.9)

        view.addSubview(titleLabel)
        view.addSubview(confirmBtn)
        view.addSubview(clearBtn)
        view.addSubview(titleTextField)
        view.addSubview(locationTextField)
        view.addSubview(priceTextField)
        view.addSubview(descriptionTextField)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 20),

            confirmBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5),
            confirmBtn.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25),
            confirmBtn.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -12.5),
            confirmBtn.heightAnchor.constraint(equalToConstant: 40),

            clearBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5),
            clearBtn.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 12.5),
            clearBtn.heightAnchor.constraint(equalToConstant: 40),
            clearBtn.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25),

            titleTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            titleTextField.heightAnchor.constraint(equalToConstant: 80),

            locationTextField.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 15),
            locationTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            locationTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            locationTextField.heightAnchor.constraint(equalToConstant: 80),

            priceTextField.topAnchor.constraint(equalTo: locationTextField.bottomAnchor, constant: 15),
            priceTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            priceTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            priceTextField.heightAnchor.constraint(equalToConstant: 80),

            descriptionTextField.topAnchor.constraint(equalTo: priceTextField.bottomAnchor, constant: 15),
            descriptionTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            descriptionTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            descriptionTextField.heightAnchor.constraint(equalToConstant: 80)
        ])
    }

    @objc private func clearTapped() {
    }

    @objc private func submitTapped() {
    }
}
