//
//  TrackerCollectionViewCell.swift
//  Tracker
//
//  Created by Глеб Хамин on 02.08.2024.
//

import Foundation
import UIKit

final class TrackerCollectionViewCell: UICollectionViewCell {
    
    lazy var namedTrackerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.backgroundColor = .ypBlack
        return view
    }()
    
    lazy var smail: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.layer.cornerRadius = 12
        lable.layer.masksToBounds = true
        lable.backgroundColor = .ypBackground
        lable.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        lable.text = "❤️"
        return lable
    }()
    
    lazy var nameLable: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.textColor = .ypWhite
        lable.text = "ksjdf"
        lable.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        return lable
    }()
    
    lazy var counterLable: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.textColor = .ypBlack
        lable.text = "1 day"
        lable.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        return lable
    }()
    
    lazy var addButtonCell: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = 17
        button.layer.masksToBounds = true
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.addTarget(self, action: #selector(addTracker), for: .touchUpInside)
        return button
    }()
    
    lazy var stackCounterTracker: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [counterLable, addButtonCell])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(namedTrackerView)
        namedTrackerView.addSubview(smail)
        namedTrackerView.addSubview(nameLable)
        contentView.addSubview(stackCounterTracker)
        

        
        NSLayoutConstraint.activate([
            namedTrackerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            namedTrackerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            namedTrackerView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            namedTrackerView.heightAnchor.constraint(equalToConstant: 90),
            namedTrackerView.widthAnchor.constraint(equalToConstant: 167),
            
            smail.leadingAnchor.constraint(equalTo: namedTrackerView.leadingAnchor, constant: 12),
            smail.topAnchor.constraint(equalTo: namedTrackerView.topAnchor, constant: 12),
            smail.heightAnchor.constraint(equalToConstant: 24),
            smail.widthAnchor.constraint(equalToConstant: 24),
            
            nameLable.leadingAnchor.constraint(equalTo: namedTrackerView.leadingAnchor, constant: 12),
            nameLable.topAnchor.constraint(equalTo: namedTrackerView.topAnchor, constant: 8),
            nameLable.heightAnchor.constraint(equalToConstant: 34),
            nameLable.widthAnchor.constraint(equalToConstant: 143),
            
            stackCounterTracker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            stackCounterTracker.topAnchor.constraint(equalTo: namedTrackerView.bottomAnchor, constant: 8),
            stackCounterTracker.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 12),
            stackCounterTracker.heightAnchor.constraint(equalToConstant: 34),
            stackCounterTracker.widthAnchor.constraint(equalToConstant: 143)

        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @IBAction private func addTracker() {
        
    }
}
