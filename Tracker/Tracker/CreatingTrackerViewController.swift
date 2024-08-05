//
//  CreatingTrackerViewController.swift
//  Tracker
//
//  Created by Глеб Хамин on 05.08.2024.
//

import Foundation
import UIKit

final class CreatingTrackerViewController: UIViewController {
    
    lazy var createHabitButton: UIButton = {
        let button = CustomBlakButton()
        button.setTitle("Привычка", for: .normal)
        button.addTarget(self, action: #selector(createHabit), for: .touchUpInside)
        return button
    }()
    
    lazy var createEventButton: UIButton = {
        let button = CustomBlakButton()
        button.setTitle("Нерегулярное событие", for: .normal)
        button.addTarget(self, action: #selector(createEvent), for: .touchUpInside)
        return button
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [createEventButton, createHabitButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    lazy var titleView: UILabel = {
        let lable = CustomTitle()
        lable.text = "Создание трекера"
        return lable
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setupLayout()
    }
    
    @IBAction private func createHabit() {
//        self.present(, animated: true, completion: nil)
    }
    
    @IBAction private func createEvent() {
//        self.present(, animated: true, completion: nil)
    }
    
    private func setupLayout() {
        view.addSubview(titleView)
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: view.topAnchor),
            titleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 30)
        ])
    }
}
