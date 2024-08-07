//
//  CustomTitle.swift
//  Tracker
//
//  Created by Глеб Хамин on 05.08.2024.
//

import UIKit

final class CustomTitle: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLable()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLable()
    }
    
    private func setupLable() {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 63).isActive = true
        textColor = .ypBlack
        font = UIFont.systemFont(ofSize: 16, weight: .medium)
    }
}
