//
//  CategoryTrackerViewController.swift
//  Tracker
//
//  Created by Глеб Хамин on 08.08.2024.
//

import UIKit

// MARK: - Protocol: CategoryTrackerViewControllerDelegate

protocol CategoryTrackerViewControllerDelegate: AnyObject {
    func updateСurrentCategory()
}

final class CategoryTrackerViewController: UIViewController {
    
    // MARK: - Public Properties

    weak var delegate: CategoryTrackerViewControllerDelegate?
    
    // MARK: - Private Properties
    
    private var viewModel = CategoryTrackerViewModel()
    
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

        setupTable()
        setupLayout()
        
        if viewModel.categories.count > 0 {
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
        viewModel.countCategory()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TypseTrackerCell", for: indexPath)
        
        guard let typseTrackerCell = cell as? TypseTrackerCell else {
            return UITableViewCell()
        }

        let title = viewModel.titleCell(indexPath.row)
        let selected = viewModel.selectedCell(title)
        
        typseTrackerCell.configCell(title, selected)
        
        self.tableView.roundingVorners(cell: typseTrackerCell, tableView: tableView, indexPath: indexPath)
        
        typseTrackerCell.setup(hideTopSeparator: indexPath.row == 0,
                               hideBotSeparator: indexPath.row == viewModel.countCategory() - 1)
        
        return typseTrackerCell
    }
}

// MARK: - Extension: UITableViewDelegate

extension CategoryTrackerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? TypseTrackerCell {
            guard let title = cell.lable.text else {
                return print("Выбрана пустая ячейка")
            }
            viewModel.didSelectCategory(title)
            delegate?.updateСurrentCategory()
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
        viewModel.didSelectCategory(title)
        delegate?.updateСurrentCategory()
        dismiss(animated: true, completion: nil)
    }
}
