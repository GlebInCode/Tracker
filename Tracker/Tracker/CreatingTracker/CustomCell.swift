//
//  CustomCell.swift
//  Tracker
//
//  Created by Глеб Хамин on 06.08.2024.
//

import UIKit

final class CustomCell: UITableViewCell {
    lazy var lable: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        lable.text = "sldfjlskjdf"
        lable.textColor = .ypBlack
        return lable
    }()
    
    lazy var subLable: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        lable.textColor = .ypGray
        return lable
    }()
    
    private lazy var stackLable: UIStackView = {
        let stackVIew = UIStackView()
        stackVIew.translatesAutoresizingMaskIntoConstraints = false
        stackVIew.axis = .vertical
        stackVIew.alignment = .leading
        return stackVIew
    }()
    
    private lazy var arrowImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "ArrorRight")
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        selectionStyle = .none
        contentView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        contentView.addSubview(arrowImage)
        contentView.addSubview(stackLable)
        stackLable.addArrangedSubview(lable)
        if let text = subLable.text, !text.isEmpty {
            stackLable.addArrangedSubview(subLable)
        }
        
        NSLayoutConstraint.activate([
            arrowImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            arrowImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            stackLable.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stackLable.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        ])
    }
}



