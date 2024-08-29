//
//  ColorCollectionViewHeader.swift
//  Tracker
//
//  Created by Глеб Хамин on 15.08.2024.
//

import UIKit

final class ColorCollectionViewHeader: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private lazy var colorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        
        view.layer.masksToBounds = true
        return view
    }()
    private lazy var content: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.alpha = 0.3
        return view
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
    
    func configCell(color: String, select: Bool) {
        guard let color = UIColor(hex: color) else {
            print("Неверный цвет")
            return
        }
        colorView.backgroundColor = color
        if select {
            content.layer.borderColor = color.cgColor
            content.layer.borderWidth = 3
        } else {
            content.layer.borderWidth = 0
        }
    }
    
    // MARK: - View Layout
    
    private func setupConstraints() {
        contentView.addSubview(content)
        contentView.addSubview(colorView)
        
        NSLayoutConstraint.activate([
            colorView.heightAnchor.constraint(equalToConstant: contentView.frame.height - 12),
            colorView.widthAnchor.constraint(equalTo: colorView.heightAnchor),
            colorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            content.heightAnchor.constraint(equalTo: colorView.heightAnchor, constant: 10),
            content.widthAnchor.constraint(equalTo: content.heightAnchor),
            content.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            content.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
