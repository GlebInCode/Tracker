//
//  CustomBlakButton.swift
//  Tracker
//
//  Created by Глеб Хамин on 05.08.2024.
//

import Foundation
import UIKit

final class CustomBlakButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    private func setupButton() {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 60).isActive = true
        setTitleColor(.ypWhite, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        backgroundColor = .ypBlack
        layer.cornerRadius = 16
        layer.masksToBounds = true
    }
}
