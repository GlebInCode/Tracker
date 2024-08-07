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
        register(CustomCell.self, forCellReuseIdentifier: "CustomCell")
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 16
        clipsToBounds = true
        backgroundColor = .ypBackground
    }
}
