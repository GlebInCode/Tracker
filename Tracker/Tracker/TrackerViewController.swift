//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Глеб Хамин on 25.07.2024.
//

import Foundation
import UIKit

final class TrackerViewController: UIViewController {
    
    var categories: [TrackerCategory] = []
    
    lazy var addTrecarButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "AddTracker"), for: .normal)
        button.addTarget(self, action: #selector(addTracker), for: .touchUpInside)
        return button
    }()
    
    lazy var titleLable: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.text = "Трекеры"
        lable.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        return lable
    }()
    
    lazy var serchLine: UITextField = {
        let textField = UITextField()
        textField.textColor = UIColor(named: "Gray")
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField.placeholder = "Поиск"
        textField.backgroundColor = UIColor(named: "Background")
        textField.layer.cornerRadius = 9
        textField.layer.masksToBounds = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        
        let imageView = UIImageView(image: UIImage(named: "MagnifyingGlass"))
        containerView.addSubview(imageView)
        imageView.center = containerView.center
        textField.leftView = containerView
        textField.leftViewMode = .always
        
        return textField
    }()
    
    lazy var imageNoContent: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "NoContent")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var lableNoContent: UILabel = {
        let lable = UILabel()
        lable.text = "Что будем отслеживать?"
        lable.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    
    lazy var stackNoContent: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [imageNoContent, lableNoContent])
        stack.axis = .vertical
        stack.spacing = 10
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraints()
    }
    
    @IBAction private func addTracker() {
        
    }
    
    private func setupConstraints() {
        view.addSubview(addTrecarButton)
        view.addSubview(titleLable)
        view.addSubview(serchLine)
        view.addSubview(stackNoContent)
        
        NSLayoutConstraint.activate([
            addTrecarButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 6),
            addTrecarButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            addTrecarButton.widthAnchor.constraint(equalToConstant: 42),
            addTrecarButton.heightAnchor.constraint(equalToConstant: 42),
            
            titleLable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLable.topAnchor.constraint(equalTo: addTrecarButton.bottomAnchor),
            
            serchLine.topAnchor.constraint(equalTo: titleLable.bottomAnchor, constant: 7),
            serchLine.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            serchLine.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            serchLine.heightAnchor.constraint(equalToConstant: 36),
            
            stackNoContent.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackNoContent.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: 69)
        ])
    }
    
    
}
