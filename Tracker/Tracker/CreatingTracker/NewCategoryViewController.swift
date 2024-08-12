//
//  NewCategoryViewController.swift
//  Tracker
//
//  Created by Глеб Хамин on 08.08.2024.
//

import UIKit

protocol NewCategoryViewControllerDelegate: AnyObject {
    func updateView(_ indexPath: IndexPath)
    func updateTable()
}

final class NewCategoryViewController: UIViewController {
    
    weak var delegate: NewCategoryViewControllerDelegate?
    
    private lazy var titleView: UILabel = {
        let lable = CustomTitle()
        lable.text = "Категория"
        return lable
    }()
    
    private lazy var categoryNameField: CustomTextFiel = {
        let textField = CustomTextFiel(placeholder: "Введите название категории")
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return textField
    }()
    
    private lazy var readyButton: UIButton = {
        let button = CustomBlakButton()
        button.backgroundColor = .ypGray
        button.isEnabled = false
        button.setTitle("Готово", for: .normal)
        button.addTarget(self, action: #selector(ready), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupLayout()
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text, !text.isEmpty {
            readyButton.isEnabled = true
            readyButton.backgroundColor = .ypBlack
        } else {
            readyButton.isEnabled = false
            readyButton.backgroundColor = .ypGray
        }
    }
    
    @IBAction private func ready() {
        guard let nameNewCategory = categoryNameField.text,
              nameNewCategory.count > 0,
              let delegate = delegate
        else {
            return
        }
        let newCategory = TrackerCategory(title: nameNewCategory, tracker: [])
        var row: Int?
        let completion: (Int) -> Void = { numberCategories in
            row = numberCategories
        }
        let notification = Notification(name: .addCategory, object: newCategory, userInfo: ["completion": completion])
        NotificationCenter.default.post(notification)
        if let row = row {
            let indexPath = IndexPath(row: row, section: 0)
            delegate.updateView(indexPath)
        }
        dismiss(animated: false) {
            self.delegate?.updateTable()
        }
    }
    
    private func setupLayout() {
        view.addSubview(titleView)
        view.addSubview(readyButton)
        view.addSubview(categoryNameField)
        
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: view.topAnchor),
            titleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            categoryNameField.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 24),
            categoryNameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            categoryNameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoryNameField.heightAnchor.constraint(equalToConstant: 75),
            
            readyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            readyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            readyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
        ])
    }
}

extension NewCategoryViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 38
    }
}
