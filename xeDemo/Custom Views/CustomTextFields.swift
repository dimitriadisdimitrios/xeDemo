//
//  CustomTextFields.swift
//  xeDemo
//
//  Created by Dimitrios Dimitriadis on 21/12/23.
//

import UIKit

class CustomTextFields: UIView {

    weak var delegate: AddNewAdDelegate?

    private let titleLabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .boldSystemFont(ofSize: 15)
        view.textColor = .black
        return view
    }()

    private lazy var fieldTextField = {
        let view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.placeholder = "Type something"
        view.font = .systemFont(ofSize: 13)
        view.backgroundColor = .clear
        view.delegate = self
        return view
    }()

    private let textFieldBackground = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.backgroundColor = .lightGray.withAlphaComponent(0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let warningLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 8)
        view.textColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {

        addSubview(titleLabel)
        addSubview(textFieldBackground)
        addSubview(fieldTextField)
        addSubview(warningLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 20),

            fieldTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            fieldTextField.leadingAnchor.constraint(equalTo: leadingAnchor),
            fieldTextField.trailingAnchor.constraint(equalTo: trailingAnchor),
            fieldTextField.heightAnchor.constraint(greaterThanOrEqualToConstant: 20),

            textFieldBackground.topAnchor.constraint(equalTo: fieldTextField.topAnchor, constant: -5),
            textFieldBackground.bottomAnchor.constraint(equalTo: fieldTextField.bottomAnchor, constant: 10),
            textFieldBackground.leadingAnchor.constraint(equalTo: fieldTextField.leadingAnchor, constant: -10),
            textFieldBackground.trailingAnchor.constraint(equalTo: fieldTextField.trailingAnchor, constant: 5),

            warningLabel.topAnchor.constraint(equalTo: textFieldBackground.bottomAnchor, constant: 5),
            warningLabel.leadingAnchor.constraint(equalTo: textFieldBackground.leadingAnchor),
            warningLabel.trailingAnchor.constraint(equalTo: textFieldBackground.trailingAnchor),
            warningLabel.heightAnchor.constraint(equalToConstant: 12)
        ])
    }

    func config(title: String, numPad: Bool = false) {
        titleLabel.text = title
        fieldTextField.keyboardType = numPad ? .decimalPad : .default
    }

    func config(value: String) {
        fieldTextField.text = value
    }

    func setWarningMsg(text: String, visible: Bool) {
        warningLabel.isHidden = !visible || fieldTextField.text == ""
        warningLabel.text = text
    }
}

extension CustomTextFields: UITextFieldDelegate {

    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }
        delegate?.textFieldChanged(text: text,vc: self)
    }
}
