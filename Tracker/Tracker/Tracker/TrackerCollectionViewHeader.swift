//
//  TrackerCollectionViewHeader.swift
//  Tracker
//
//  Created by Глеб Хамин on 10.08.2024.
//

import UIKit

final class TrackerCollectionViewHeader: UICollectionReusableView {
    
    // MARK: - UI Components
    
    lazy var textLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .natural
        label.frame = bounds
        label.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(textLabel)
        
        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            textLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            textLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
