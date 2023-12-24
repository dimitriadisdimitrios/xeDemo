//
//  CustomTextFieldsCell.swift
//  xeDemo
//
//  Created by Dimitrios Dimitriadis on 21/12/23.
//

import UIKit
import DropDown

class CustomTextFieldsCell: UITableViewCell {

    weak var delegate: AddNewAdDelegate?
    static let identifier = "CustomTextFields"
    private var cellType: AdCellType!
    private var needToShowResult = false
    private var resultsPanelIsOpen = false
    private var locationsDataSource: [(String , SearchedLocation)] = []
    private lazy var fieldTextViewHeightConstraint = fieldTextField.heightAnchor.constraint(equalToConstant: 20)

    var isFieldEmpty: Bool {
        fieldTextField.text.isEmpty || fieldTextField.text == nil
    }

    var isFieldFirstResponder: Bool {
        fieldTextField.isFirstResponder
    }

    var typeOfCell: AdCellType {
        cellType
    }

    private let titleLabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .boldSystemFont(ofSize: 15)
        view.textColor = .black
        return view
    }()

    private lazy var fieldTextField = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 13)
        view.backgroundColor = .clear
        view.isEditable = true
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

    private let emptyView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var dropDownView = {
        let view = DropDown(anchorView: warningLabel)
        view.dismissMode = .manual
        view.selectionAction = { [weak self] index, item in
            guard let self else { return }
            resultsPanelIsOpen = false
            fieldTextField.text = item
            guard let location = locationsDataSource.first(where: { $0.0 == item }) else { return }
            delegate?.locationSelected(location: location.1)
        }
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

        contentView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(titleLabel)
        contentView.addSubview(emptyView)
        contentView.addSubview(textFieldBackground)
        contentView.addSubview(fieldTextField)
        contentView.addSubview(warningLabel)

        NSLayoutConstraint.activate([

            emptyView.topAnchor.constraint(equalTo: textFieldBackground.topAnchor),
            emptyView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            emptyView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 20),

            fieldTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            fieldTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            fieldTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
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

        self.delegate = delegate
        cellType = type

        titleLabel.text = type.tilte
        fieldTextField.keyboardType = type == .price ? .decimalPad : .default
        fieldTextField.isScrollEnabled = type == .description
        fieldTextField.textContainer.maximumNumberOfLines = type == .description ? 0 : 1
        setTextInTextfield(vm)
        setWarningMsg(viewModel: vm)
        setFieldsHeight(viewModel: vm)
        needToShowResult = vm.needToShowResult(cellType)
        if needToShowResult {
            locationsDataSource = vm.getLocationsForPanel()
            dropDownView.dataSource = locationsDataSource.map { $0.0 }
            showResultsPanel()
        }
    }

    private func setFieldsHeight(viewModel: AddNewAdViewModel) {
        guard viewModel.isFieldWithDyncamicHeight(cellType) else {
            fieldTextViewHeightConstraint.constant = viewModel.heightForTextfield(cellType)
            fieldTextViewHeightConstraint.isActive = true
            return
        }
        let heightToCoverText = calculateNumberOfLines() * 15.6
        fieldTextViewHeightConstraint.constant = heightToCoverText > viewModel.heightForTextfield(cellType) ? heightToCoverText : viewModel.heightForTextfield(cellType)
        fieldTextViewHeightConstraint.isActive = true

    }

    private func setTextInTextfield(_ viewModel: AddNewAdViewModel) {
        let textValue: String
        switch cellType {
        case .title:
            textValue = viewModel.title ?? ""
        case .location:
            textValue = viewModel.locationText
        case .price:
            textValue = "\(viewModel.price)"
        case .description:
            textValue = viewModel.description ?? ""
        case .none:
            return
        }
        fieldTextField.text = textValue
        if textValue.isEmpty {
            addPlaceholder()
        }
    }

    func setWarningMsg(viewModel: AddNewAdViewModel) {
        warningLabel.isHidden = !viewModel.isWarningActivateFor(cellType) || fieldTextField.text.isEmpty
        warningLabel.text = cellType.warningMessage
    }

    func makeViewFirstResponder(type: AdCellType) {
        guard type == cellType else { return }
        fieldTextField.becomeFirstResponder()
    }

    private func calculateNumberOfLines() -> CGFloat {
        fieldTextField.layoutIfNeeded()
        let maxSize = CGSize(width: fieldTextField.bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let sizeThatFits = fieldTextField.sizeThatFits(maxSize)

        let lineHeight = fieldTextField.font?.lineHeight ?? 0
        let numberOfLines = Int(sizeThatFits.height / lineHeight)

        return CGFloat(numberOfLines)
    }

    private func showResultsPanel() {
        guard needToShowResult, !resultsPanelIsOpen, dropDownView.dataSource.count > 0 else {
            if dropDownView.dataSource.count == 0 {
                resultsPanelIsOpen = false
            }
            if fieldTextField.text.count < 2 {
                hideResultsPanel()
            }
            return
        }
        resultsPanelIsOpen = true
        dropDownView.show()
    }

    private func hideResultsPanel() {
        guard needToShowResult else { return }
        resultsPanelIsOpen = false
        dropDownView.hide()
    }
}

extension CustomTextFieldsCell: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        guard let text = textView.text else { return }
        delegate?.textFieldChanged(text: text, type: cellType)
        showResultsPanel()
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            addPlaceholder()
            hideResultsPanel()
        }
    }

    private func addPlaceholder() {
        fieldTextField.text = "Type something..."
        fieldTextField.textColor = UIColor.lightGray
    }
}
