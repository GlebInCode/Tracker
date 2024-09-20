//
//  StaticticsViewController.swift
//  Tracker
//
//  Created by Глеб Хамин on 25.07.2024.
//

import UIKit

final class StaticticsViewController: UIViewController {
    
    private var completed: String?
    
    // MARK: - UI Components
    
    private lazy var titleLable: UILabel = {
        let lable = LargeTitle()
        lable.translatesAutoresizingMaskIntoConstraints = false
        let emptyStateText = NSLocalizedString("statistic.title", comment: "Трекеры")
        lable.text = emptyStateText
        return lable
    }()
    
    private lazy var noDataView: NoDataView = {
        let view = NoDataView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let emptyStateText = NSLocalizedString("statistic.placeholder", comment: "Анализировать пока нечего")
        view.text = emptyStateText
        view.image = UIImage(named: "StatisticError")
        return view
    }()
    
    private lazy var completedView: StatisticElementView = {
        let view = StatisticElementView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        setupConstraints()
        configView()
        
        if  completed != nil {
            layoutCompletedView()
        } else {
            loadDefaultImage()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configView()
        
        if  completed != nil {
            noDataView.removeFromSuperview()
            layoutCompletedView()
        } else {
            completedView.removeFromSuperview()
            loadDefaultImage()
        }
    }
    
    private func getStatistic() {
        guard let count = UserDefaults.standard.string(
            forKey: Constants.staticticCompleted
        ) else { return }
        completed = count == "0" ? nil : count
    }
    
    private func configView(){
        getStatistic()
        
        if let completed {
            let emptyStateText = NSLocalizedString("statistic.completed", comment: "Трекеров завершено")
            completedView.configView(completed, emptyStateText)
        }
        
    }
    
    // MARK: - View Layout
    
    private func setupConstraints() {
        view.addSubview(titleLable)
        
        NSLayoutConstraint.activate([
            titleLable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),
            titleLable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            titleLable.heightAnchor.constraint(equalToConstant: 41)
        ])
    }
    
    private func layoutCompletedView() {
        view.addSubview(completedView)
        
        NSLayoutConstraint.activate([
            
            completedView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 164),
            completedView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            completedView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func loadDefaultImage() {
        view.addSubview(noDataView)
        
        NSLayoutConstraint.activate([
            noDataView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            noDataView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            noDataView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            noDataView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
