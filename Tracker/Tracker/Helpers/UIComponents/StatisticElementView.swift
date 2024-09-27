//
//  StatisticElementView.swift
//  Tracker
//
//  Created by Глеб Хамин on 20.09.2024.
//

import UIKit

final class StatisticElementView: GradientBorderView {
    lazy var view: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var titleNumber: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textColor = .ypBlack
        return label
    }()
    
    lazy var subTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .ypBlack
        return label
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .none
        layer.cornerRadius = 16
        layer.borderWidth = 1
        layer.masksToBounds = true
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configView(_ titleNumber: String, _ subTitle: String) {
        self.titleNumber.text = titleNumber
        self.subTitle.text = subTitle
    }
    
    
    // MARK: - View Layout
    
    private func setupConstraints() {
        addSubview(view)
        view.addSubview(titleNumber)
        view.addSubview(subTitle)
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            
            titleNumber.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleNumber.topAnchor.constraint(equalTo: view.topAnchor),
            titleNumber.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleNumber.heightAnchor.constraint(equalToConstant: 41),
            
            subTitle.topAnchor.constraint(equalTo: titleNumber.bottomAnchor, constant: 7),
            subTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            subTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            subTitle.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            subTitle.heightAnchor.constraint(equalToConstant: 18),
        ])
    }
}
