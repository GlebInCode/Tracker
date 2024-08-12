//
//  CustomTextFiel.swift
//  Tracker
//
//  Created by Глеб Хамин on 08.08.2024.
//

import UIKit

final class CustomTextFiel: UITextField {
    
    //MARK: - Private Property
    private let padding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    
    //MARK: - Initializers
    init(placeholder: String) {
        super.init(frame: .zero)
        setupTextField(placeholder: placeholder)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: - Override Methods
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    private lazy var textFieldNameTracker: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    //MARK: - Private Methods
    private func setupTextField(placeholder: String) {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 16
        layer.masksToBounds = true
        backgroundColor = .ypBackground
        self.placeholder = placeholder
    }
}
