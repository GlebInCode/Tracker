//
//  CustomBlakButton.swift
//  Tracker
//
//  Created by Глеб Хамин on 05.08.2024.
//

import UIKit

final class CustomBlakButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                backgroundColor = .ypBlack
                setTitleColor(.ypWhite, for: .normal)
            } else {
                backgroundColor = .ypGray
                if traitCollection.userInterfaceStyle == .dark {
                    setTitleColor(.ypBlack, for: .normal)
                }
            }
        }
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
