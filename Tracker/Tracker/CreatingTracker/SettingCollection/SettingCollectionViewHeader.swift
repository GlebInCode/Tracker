//
//  SettingCollectionViewHeader.swift
//  Tracker
//
//  Created by Глеб Хамин on 15.08.2024.
//

import UIKit

final class SettingCollectionViewHeader: UICollectionReusableView {
    
    // MARK: - UI Components
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.frame = bounds
        label.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        return label
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func configHeader(title: String) {
        textLabel.text = title
    }
    
    // MARK: - View Layout
    
    private func setupConstraints() {
        addSubview(textLabel)
        
        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            textLabel.topAnchor.constraint(equalTo: topAnchor, constant: 32),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            textLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
}

