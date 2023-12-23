//
//  CustomTextFieldsCell.swift
//  xeDemo
//
//  Created by Dimitrios Dimitriadis on 21/12/23.
//

import UIKit

class CustomTextFieldsCell: UITableViewCell {

    weak var delegate: AddNewAdDelegate?
    static let identifier = "CustomTextFields"
    private var cellType: AdCellType!

    var isFieldEmpty: Bool {
        fieldTextField.text == "" || fieldTextField.text == nil
    }

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

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {

        contentView.addSubview(titleLabel)
        contentView.addSubview(textFieldBackground)
        contentView.addSubview(fieldTextField)
        contentView.addSubview(warningLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 20),

            fieldTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            fieldTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            fieldTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            fieldTextField.heightAnchor.constraint(greaterThanOrEqualToConstant: 20),
            fieldTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30),

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

    func config(vm: AddNewAdViewModel, type: AdCellType, delegate: AddNewAdDelegate) {
        titleLabel.text = type.tilte
        fieldTextField.keyboardType = type == .price ? .decimalPad : .default
        self.delegate = delegate
        cellType = type
        setTextInTextfield(vm)
        setWarningMsg(viewModel: vm)
    }

    private func setTextInTextfield(_ viewModel: AddNewAdViewModel) {
        let textValue: String
        switch cellType {
        case .title:
            textValue = viewModel.title ?? ""
        case .location:
            textValue = viewModel.location.value.mainText
        case .price:
            textValue = "\(viewModel.price.value)"
        case .description:
            textValue = viewModel.description ?? ""
        case .none:
            return
        }
        fieldTextField.text = textValue
    }

    func setWarningMsg(viewModel: AddNewAdViewModel) {
        warningLabel.isHidden = !viewModel.isWarningActivateFor(cellType) || fieldTextField.text == ""
        warningLabel.text = cellType.warningMessage
    }
}

extension CustomTextFieldsCell: UITextFieldDelegate {

    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }
        delegate?.textFieldChanged(text: text, type: cellType)
    }
}
