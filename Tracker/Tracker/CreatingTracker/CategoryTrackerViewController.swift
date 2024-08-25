//
//  CategoryTrackerViewController.swift
//  Tracker
//
//  Created by Глеб Хамин on 08.08.2024.
//

import UIKit

// MARK: - Protocol: CategoryTrackerViewControllerDelegate

protocol CategoryTrackerViewControllerDelegate: AnyObject {
    func updateСurrentCategory(_ nameCategory: String)
}

final class CategoryTrackerViewController: UIViewController {
    
    // MARK: - Public Properties

    weak var delegate: CategoryTrackerViewControllerDelegate?
    var categories: [TrackerCategory] = []
    var selectedCategory: String?
    
    private let store = Store()
    
    // MARK: - UI Components

    private lazy var titleView: UILabel = {
        let lable = CustomTitle()
        lable.text = "Категория"
        return lable
    }()
    
    private lazy var noDataView: NoDataView = {
        let view = NoDataView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Привычки и события можно\nобъединить по смыслу"
        view.image = UIImage(named: "NoContent")
        return view
    }()
            
    private lazy var addCategoryButton: UIButton = {
        let button = CustomBlakButton()
        button.setTitle("Добавить категорию", for: .normal)
        button.addTarget(self, action: #selector(addCategory), for: .touchUpInside)
        return button
    }()
    
    private let tableView = ParameterTable(frame: .zero, style: .plain)
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        updateCategory()
        setupTable()
        setupLayout()
        if categories.count > 0 {
            layoutTable()
        } else {
            loadDefaultImage()
        }
    }
    
    // MARK: - IBActions

    @IBAction private func addCategory() {
        let newCategoryViewController = NewCategoryViewController()
        newCategoryViewController.delegate = self
        self.present(newCategoryViewController, animated: true, completion: nil)
    }
    
    // MARK: - Private Methods

    private func setupTable() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func updateCategory() {
        do {
            categories = try store.getCategory()
        } catch {
            print("Данные не доступны")
        }
    }
    
    // MARK: - View Layout

    private func setupLayout() {
        view.addSubview(titleView)
        view.addSubview(addCategoryButton)
        
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: view.topAnchor),
            titleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            addCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
        ])
    }
    
    private func layoutTable() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: addCategoryButton.topAnchor, constant: -16)
        ])
    }
    
    private func loadDefaultImage() {
        view.addSubview(noDataView)
        NSLayoutConstraint.activate([
            noDataView.topAnchor.constraint(equalTo: titleView.bottomAnchor),
            noDataView.bottomAnchor.constraint(equalTo: addCategoryButton.topAnchor),
            noDataView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            noDataView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

// MARK: - Extension: UITableViewDataSource

extension CategoryTrackerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TypseTrackerCell", for: indexPath)
        
        guard let typseTrackerCell = cell as? TypseTrackerCell else {
            return UITableViewCell()
        }
        if categories[indexPath.row].title == selectedCategory {
            typseTrackerCell.image.image = UIImage(systemName: "checkmark")
        } else {
            typseTrackerCell.image.image = .none
        }
        typseTrackerCell.lable.text = categories[indexPath.row].title
        self.tableView.roundingVorners(cell: typseTrackerCell, tableView: tableView, indexPath: indexPath)
        
        typseTrackerCell.setup(hideTopSeparator: indexPath.row == 0,
                               hideBotSeparator: indexPath.row == categories.count - 1)
        
        return typseTrackerCell
    }
}

// MARK: - Extension: UITableViewDelegate

extension CategoryTrackerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? TypseTrackerCell {
            cell.image.image = UIImage(systemName: "checkmark")
            selectedCategory = cell.lable.text
            guard let nameCategory = cell.lable.text else {
                return print("Выбрана пустая ячейка")
            }
            
            if let delegate = delegate {
                delegate.updateСurrentCategory(nameCategory)
            }
            dismiss(animated: true, completion: nil)
        }
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? TypseTrackerCell {
            cell.image.image = .none
        }
    }
}

// MARK: - Extension: NewCategoryViewControllerDelegate

extension CategoryTrackerViewController: NewCategoryViewControllerDelegate {
    func updateCategory(_ title: String) {
        if let delegate = delegate {
            delegate.updateСurrentCategory(title)
        }
        dismiss(animated: true, completion: nil)
    }
}
