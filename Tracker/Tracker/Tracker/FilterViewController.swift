//
//  FilterViewController.swift
//  Tracker
//
//  Created by Глеб Хамин on 16.09.2024.
//

import UIKit

// MARK: - Protocol: CategoryTrackerViewControllerDelegate

protocol FilterViewControllerDelegate: AnyObject {
    func updateFilter(_ selectFilter: Filter)
}

final class FilterViewController: UIViewController {
    
    // MARK: - Public Properties

    weak var delegate: FilterViewControllerDelegate?
    var selectedFilter: Filter?
    
    // MARK: - Private Properties
    
    private let filter: [Filter] = [.all, .today, .completed, .unfinished]
    
    // MARK: - UI Components

    private lazy var titleView: UILabel = {
        let lable = CustomTitle()
        let emptyStateText = NSLocalizedString("main.filters", comment: "Фильтры")
        lable.text = emptyStateText
        return lable
    }()
    
    private let tableView = ParameterTable(frame: .zero, style: .plain)
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupTable()
        setupLayout()
    }
    
    // MARK: - Private Methods

    private func setupTable() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: - View Layout

    private func setupLayout() {
        view.addSubview(titleView)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: view.topAnchor),
            titleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
        ])
    }
}

// MARK: - Extension: UITableViewDataSource

extension FilterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TypseTrackerCell", for: indexPath)
        
        guard let typseTrackerCell = cell as? TypseTrackerCell else {
            return UITableViewCell()
        }

        let selected: Bool = {
            selectedFilter == filter[indexPath.row]
        }()
        
        let title: String = {
            switch filter[indexPath.row] {
            case .all:
                NSLocalizedString("main.filters.all", comment: "Все трекеры")
            case .completed:
                NSLocalizedString("main.filters.completed", comment: "Завершенные")
            case .today:
                NSLocalizedString("main.filters.today", comment: "Трекеры на сегодня")
            case .unfinished:
                NSLocalizedString("main.filters.unfinished", comment: "Не завершенные")
            }
        }()
        
        typseTrackerCell.configCell(title, selected)
        
        self.tableView.roundingVorners(cell: typseTrackerCell, tableView: tableView, indexPath: indexPath)
        
        typseTrackerCell.setup(hideTopSeparator: indexPath.row == 0,
                               hideBotSeparator: indexPath.row == filter.count - 1)
        
        return typseTrackerCell
    }
}

// MARK: - Extension: UITableViewDelegate

extension FilterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let select: Filter = filter[indexPath.row]
        if select == selectedFilter {
            selectedFilter = nil
            tableView.reloadData()
            delegate?.updateFilter(.all)
        } else {
            selectedFilter = select
            delegate?.updateFilter(select)
            tableView.reloadData()
            dismiss(animated: true, completion: nil)
        }
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? TypseTrackerCell {
            cell.image.image = .none
        }
    }
}
