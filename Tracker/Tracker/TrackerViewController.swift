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
    
    private let cellIdentifier = "cell"
    
    lazy var addTrecarButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "AddTracker"), for: .normal)
        button.addTarget(self, action: #selector(addTracker), for: .touchUpInside)
        return button
    }()
    
    lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.layer.cornerRadius = 8
        datePicker.layer.masksToBounds = true
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ru_RU")
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        return datePicker
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
        textField.backgroundColor = .ypBackground
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
    
    lazy var trackerArea: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        
        view.backgroundColor = .ypWhite
        setupConstraints()
    }
    
    @IBAction private func addTracker() {
        self.present(CreatingTrackerViewController(), animated: true, completion: nil)
        
//        collectionView.performBatchUpdates {
//            collectionView.insertItems(at: [IndexPath(item: count, section: 0)])
//        }
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let formattedDate = dateFormatter.string(from: selectedDate)
        print("Выбранная дата: \(formattedDate)")
    }
    
    private func setupConstraints() {
        view.addSubview(addTrecarButton)
        view.addSubview(datePicker)
        view.addSubview(titleLable)
        view.addSubview(serchLine)
        view.addSubview(trackerArea)
//        trackerArea.addSubview(stackNoContent)
        trackerArea.addSubview(collectionView)
        
        
        NSLayoutConstraint.activate([
            addTrecarButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 6),
            addTrecarButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            addTrecarButton.widthAnchor.constraint(equalToConstant: 42),
            addTrecarButton.heightAnchor.constraint(equalToConstant: 42),
            
            datePicker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            datePicker.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            
            titleLable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLable.topAnchor.constraint(equalTo: addTrecarButton.bottomAnchor),
            
            serchLine.topAnchor.constraint(equalTo: titleLable.bottomAnchor, constant: 7),
            serchLine.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            serchLine.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            serchLine.heightAnchor.constraint(equalToConstant: 36),
            
            trackerArea.topAnchor.constraint(equalTo: serchLine.bottomAnchor, constant: 10),
            trackerArea.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            trackerArea.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trackerArea.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
//            stackNoContent.centerXAnchor.constraint(equalTo: trackerArea.centerXAnchor),
//            stackNoContent.centerYAnchor.constraint(equalTo: trackerArea.centerYAnchor),
            
            collectionView.topAnchor.constraint(equalTo: trackerArea.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: trackerArea.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: trackerArea.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trackerArea.trailingAnchor)
        ])
    }

}

extension TrackerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? TrackerCollectionViewCell
        
        //cell?.titleLabel.text = show[indexPath.row]
        return cell!
    }
}

extension TrackerViewController: UICollectionViewDelegateFlowLayout {}
