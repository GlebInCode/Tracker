//
//  SettingHabitViewController.swift
//  Tracker
//
//  Created by Глеб Хамин on 05.08.2024.
//

import Foundation
import UIKit

final class SettingHabitViewController: UIViewController {
    
    var trackerType: TrackerType?
    
    var cellsTable: [String] = []
    
    private lazy var titleView: UILabel = {
        let lable = CustomTitle()
        if let trackerType = trackerType {
            switch trackerType {
            case .habit:
                lable.text = "Новая привычка"
            case .event:
                lable.text = "Новое нерегулярное событие"
            }
        }
        return lable
    }()
    
    private lazy var createButton: UIButton = {
        let button = UIButton()
        button.setTitle("Создать", for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.backgroundColor = .ypGray
        button.addTarget(self, action: #selector(create), for: .touchUpInside)
        return button
    }()
    
    private lazy var cancellationButton: UIButton = {
        let button = UIButton()
        button.setTitle("Отменить", for: .normal)
        button.setTitleColor(.ypRed, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.backgroundColor = .none
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.ypRed.cgColor
        button.addTarget(self, action: #selector(cancellation), for: .touchUpInside)
        return button
    }()
    
    private lazy var stackButton: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [cancellationButton, createButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var viewTextField: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .ypBackground
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var textFieldNameTracker: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField.placeholder = "Введите название трекера"
        textField.clearButtonMode = .whileEditing
        textField.delegate = self
        return textField
    }()
    
    let table = ParameterTable(frame: .zero, style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        defineCellsTable()
        setupTable()
        setupLayout()
    }
    
    @IBAction private func create() {
//        let settingHabitViewController = SettingHabitViewController()
//        let segue = UIStoryboardSegue(identifier: "showSettingHabitViewController", source: self, destination: settingHabitViewController)
//        settingHabitViewController.trackerType = .habit
//        self.present(settingHabitViewController, animated: true, completion: nil)
    }
    
    @IBAction private func cancellation() {
        dismiss(animated: true, completion: nil)
    }
    
    private func defineCellsTable(){
            switch trackerType {
            case .habit:
                return cellsTable = ["Категория", "Расписание"]
            case .event:
                return cellsTable = ["Категория"]
            case .none:
                return cellsTable = []
            }
    }
    
    private func setupTable() {
        table.dataSource = self
        table.delegate = self
        
    }
    
    private func setupLayout() {
        view.addSubview(titleView)
        view.addSubview(stackButton)
        view.addSubview(viewTextField)
        view.addSubview(table)
        viewTextField.addSubview(textFieldNameTracker)
        
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: view.topAnchor),
            titleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            viewTextField.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 24),
            viewTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            viewTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            viewTextField.heightAnchor.constraint(equalToConstant: 75),
            
            textFieldNameTracker.centerYAnchor.constraint(equalTo: viewTextField.centerYAnchor),
            textFieldNameTracker.trailingAnchor.constraint(equalTo: viewTextField.trailingAnchor, constant: -16),
            textFieldNameTracker.leadingAnchor.constraint(equalTo: viewTextField.leadingAnchor, constant: 16),
            
            table.topAnchor.constraint(equalTo: viewTextField.bottomAnchor, constant: 24),
            table.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            table.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            table.heightAnchor.constraint(equalToConstant: CGFloat(75 * cellsTable.count)),
            
            stackButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stackButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}

extension SettingHabitViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 38
    }
}

extension SettingHabitViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellsTable.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath)
        
        guard let customCell = cell as? CustomCell else {
            return UITableViewCell()
        }
        customCell.backgroundColor = .clear
        customCell.lable.text = cellsTable[indexPath.row]
        return customCell
    }
    
    
}

extension SettingHabitViewController: UITableViewDelegate {

}
