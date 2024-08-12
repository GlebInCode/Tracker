//
//  ParameterTable.swift
//  Tracker
//
//  Created by Глеб Хамин on 06.08.2024.
//

import UIKit

final class ParameterTable: UITableView {
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setupTableView()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTableView()
    }
    
    private func setupTableView() {
        register(TypseTrackerCell.self, forCellReuseIdentifier: "TypseTrackerCell")
        register(DayWeekCell.self, forCellReuseIdentifier: "DayWeekCell")
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func roundingVorners(cell: UITableViewCell, tableView: UITableView, indexPath: IndexPath) {
        if tableView.numberOfRows(inSection: indexPath.section) == 1 {
            cell.layer.cornerRadius = 16
            cell.layer.masksToBounds = true
        } else if indexPath.row == 0 {
            cell.layer.cornerRadius = 16
            cell.layer.masksToBounds = true
            cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            cell.layer.cornerRadius = 16
            cell.layer.masksToBounds = true
            cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } 
    }
}
