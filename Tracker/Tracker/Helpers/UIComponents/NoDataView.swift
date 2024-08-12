//
//  NoDataView.swift
//  Tracker
//
//  Created by Глеб Хамин on 08.08.2024.
//

import UIKit

final class NoDataView: UIView {
    private lazy var noDataView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var imageNoContent: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "NoContent")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var lableNoContent: UILabel = {
        let label = UILabel()
        let text = "Что будем отслеживать?"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        
        let attributedText = NSMutableAttributedString(string: text)

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4 // увеличьте расстояние между строками
        attributedText.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: text.count))

        label.attributedText = attributedText
        label.textAlignment = .center
        return label
    }()
    
    private lazy var stackNoContent: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [imageNoContent, lableNoContent])
        stack.axis = .vertical
        stack.spacing = 10
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    var image: UIImage? {
        didSet {
            imageNoContent.image = image
        }
    }
    var text: String? {
        didSet {
            lableNoContent.text = text
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        addSubview(noDataView)
        noDataView.addSubview(stackNoContent)
        
        NSLayoutConstraint.activate([
            noDataView.topAnchor.constraint(equalTo: topAnchor),
            noDataView.bottomAnchor.constraint(equalTo: bottomAnchor),
            noDataView.trailingAnchor.constraint(equalTo: trailingAnchor),
            noDataView.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            stackNoContent.centerXAnchor.constraint(equalTo: noDataView.centerXAnchor),
            stackNoContent.centerYAnchor.constraint(equalTo: noDataView.centerYAnchor)
        ])
    }
}
