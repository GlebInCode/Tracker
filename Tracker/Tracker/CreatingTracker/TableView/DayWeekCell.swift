//
//  DayWeekCell.swift
//  Tracker
//
//  Created by Глеб Хамин on 07.08.2024.
//

import UIKit

final class DayWeekCell: UITableViewCell {
    
    // MARK: - Private Properties
    
    private let botSeparator = UIView(frame: .zero)
    private let topSeparator = UIView(frame: .zero)
    
    // MARK: - UI Components
    
    lazy var lable: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        lable.textColor = .ypBlack
        return lable
    }()
    
    lazy var switchControl: UISwitch = {
        let switchControl = UISwitch()
        switchControl.onTintColor = .ypBlue
        return switchControl
    }()
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupSeparators()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func setup(hideTopSeparator: Bool, hideBotSeparator: Bool) {
        topSeparator.isHidden = hideTopSeparator
        botSeparator.isHidden = hideBotSeparator
    }
    
    // MARK: - View Layout
    
    private func setupViews() {
        selectionStyle = .none
        backgroundColor = .ypBackground
        contentView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        contentView.addSubview(switchControl)
        contentView.addSubview(lable)
        
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            switchControl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            switchControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            lable.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            lable.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        ])
    }
    
    private func setupSeparators() {
        separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        
        topSeparator.backgroundColor = .ypGray
        botSeparator.backgroundColor = .ypGray
        
        contentView.addSubview(topSeparator)
        contentView.addSubview(botSeparator)
        topSeparator.translatesAutoresizingMaskIntoConstraints = false
        botSeparator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topSeparator.topAnchor.constraint(equalTo: contentView.topAnchor),
            topSeparator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            topSeparator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            topSeparator.heightAnchor.constraint(equalToConstant: 0.5),
            
            botSeparator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            botSeparator.trailingAnchor.constraint(equalTo: topSeparator.trailingAnchor),
            botSeparator.leadingAnchor.constraint(equalTo: topSeparator.leadingAnchor),
            botSeparator.heightAnchor.constraint(equalTo: topSeparator.heightAnchor)
        ])
    }
    
    
}
