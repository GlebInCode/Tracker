//
//  EmojiCollectionViewCell.swift
//  Tracker
//
//  Created by Глеб Хамин on 15.08.2024.
//

import UIKit

final class EmojiCollectionViewCell: UICollectionViewCell {
    
    private var selectColor: UIColor = .ypLightGray
    
    // MARK: - UI Components
    
    private lazy var emojiView: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.textAlignment = .center
        lable.text = "A"
        lable.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        return lable
    }()
    private lazy var selectionView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
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
    
    func configCell(emoji: String, select: Bool) {
        emojiView.text = emoji
        selectionView.backgroundColor = select ? selectColor : .none
    }
    
    // MARK: - View Layout
    
    private func setupConstraints() {
        contentView.addSubview(selectionView)
        contentView.addSubview(emojiView)
        
        NSLayoutConstraint.activate([
            selectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            selectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            selectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            selectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            emojiView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emojiView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
