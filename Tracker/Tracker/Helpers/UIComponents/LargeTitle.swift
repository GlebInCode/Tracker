//
//  LargeTitle.swift
//  Tracker
//
//  Created by Глеб Хамин on 19.09.2024.
//

import UIKit

final class LargeTitle: UILabel {
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
        font = UIFont.systemFont(ofSize: 34, weight: .bold)
        textColor = .ypBlack
    }
}
