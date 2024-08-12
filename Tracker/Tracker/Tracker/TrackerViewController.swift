//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Глеб Хамин on 25.07.2024.
//

import Foundation
import UIKit

final class TrackerViewController: UIViewController {
    
    let calendar = Calendar(identifier: .gregorian)
    
    var categories: [TrackerCategory] = []
    
    var completedTrackers: [TrackerRecord] = []
    var executedTrackerIds: Set<UUID> = []
    var selectedDate = Date()
    
    var targetDayTrackers: [TrackerCategory] = []
    
    private let cellIdentifier = "cell"
    
    private lazy var addTrecarButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "AddTracker"), for: .normal)
        button.addTarget(self, action: #selector(addTracker), for: .touchUpInside)
        return button
    }()
    
    private lazy var datePicker: UIDatePicker = {
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
    
    private lazy var titleLable: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.text = "Трекеры"
        lable.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        return lable
    }()
    
    private lazy var serchLine: UITextField = {
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
    
    private lazy var noDataView: NoDataView = {
        let view = NoDataView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Что будем отслеживать?"
        view.image = UIImage(named: "NoContent")
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.register(
            TrackerCollectionViewHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "TrackerCollectionViewHeader")
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        
        setupConstraints()
        updateExecutedTrackerIds()
        updateCollectionTrackerDate(selectedDate)
        showContentOrPlaceholder()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .addCategory, object: nil)
    }
    
    @IBAction private func addTracker() {
        NotificationCenter.default.removeObserver(self, name: .addCategory, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addCategory(_:)), name: .addCategory, object: nil)
        let creatingTrackerVC = CreatingTrackerViewController()
        creatingTrackerVC.delegate = self
        self.present(creatingTrackerVC, animated: true, completion: nil)
    }
    
    @objc private func addCategory(_ notification: Notification) {
        if let newCategory = notification.object as? TrackerCategory {
            if let index = categories.firstIndex(where: { $0.title == newCategory.title }) {
                categories.remove(at: index)
            }
            categories.append(newCategory)
            updateCollectionTrackerDate(selectedDate)
            showContentOrPlaceholder()
            collectionView.reloadData()
            
            NotificationCenter.default.post(name: .updateCategory, object: categories)
            
            if let completion = notification.userInfo?["completion"] as? (Int) -> Void {
                let numberCategories = categories.count - 1
                completion(numberCategories)
            }
        }
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        selectedDate = sender.date
        updateCollectionTrackerDate(selectedDate)
    }
    
    private func showContentOrPlaceholder() {
        if targetDayTrackers.count > 0 {
            layoutCollection()
            
            noDataView.removeFromSuperview()
        } else {
            loadDefaultImage()
            
        }
    }
    
    private func updateCollectionTrackerDate(_ date: Date) {
        
        let dayOfWeek = calendar.component(.weekday, from: date)
        var selectDayWeek: DayOfWeek?
        
        switch dayOfWeek {
        case 1:
            selectDayWeek = .sunday
        case 2:
            selectDayWeek = .monday
        case 3:
            selectDayWeek = .tuesday
        case 4:
            selectDayWeek = .wednesday
        case 5:
            selectDayWeek = .thursday
        case 6:
            selectDayWeek = .friday
        case 7:
            selectDayWeek = .saturday
        default:
            print("Неизвестный день недели")
        }
        targetDayTrackers = []
        
        guard let selectDayWeek else { return }
        for category in categories {
            if !category.tracker.isEmpty {
                var treckers: [Tracker] = []
                for tracker in category.tracker{
                    if tracker.schedule.isEmpty {
                        if executedTrackerIds.contains(tracker.id) {
                            guard let index = completedTrackers.firstIndex(where: { $0.idTracker == tracker.id }) else {
                                print("Нет трекера в выполненныех")
                                return
                            }
                            let date1Components = Calendar.current.dateComponents([.day, .month, .year], from: completedTrackers[index].date[0])
                            let date2Components = Calendar.current.dateComponents([.day, .month, .year], from: date)
                            if date1Components == date2Components{
                                treckers.append(tracker)
                                continue
                            }
                            continue
                        } else {
                            treckers.append(tracker)
                        }
                    }
                    for date in tracker.schedule {
                        if date == selectDayWeek {
                            treckers.append(tracker)
                            break
                        }
                    }
                }
                if !treckers.isEmpty {
                    let tempCategory: TrackerCategory = TrackerCategory(title: category.title, tracker: treckers)
                    targetDayTrackers.append(tempCategory)
                }
            }
        }
        showContentOrPlaceholder()
        collectionView.reloadData()
    }
    
    private func updateExecutedTrackerIds() {
        for tracker in completedTrackers {
            let id = tracker.idTracker
            if executedTrackerIds.contains(id) {
                continue
            } else {
                executedTrackerIds.insert(id)
            }
        }
    }
    
    private func setupConstraints() {
        view.addSubview(addTrecarButton)
        view.addSubview(datePicker)
        view.addSubview(titleLable)
        view.addSubview(serchLine)
        
        
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
            serchLine.heightAnchor.constraint(equalToConstant: 36)
        ])
    }
    
    private func layoutCollection() {
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: serchLine.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func loadDefaultImage() {
        view.addSubview(noDataView)
        
        NSLayoutConstraint.activate([
            noDataView.topAnchor.constraint(equalTo: serchLine.bottomAnchor, constant: 10),
            noDataView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            noDataView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            noDataView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int) -> CGSize {
            return CGSize(width: collectionView.frame.width, height: 46)
        }
    
}

extension TrackerViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return targetDayTrackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return targetDayTrackers[section].tracker.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? TrackerCollectionViewCell
        guard let cell = cell else {
            return UICollectionViewCell()
        }
        let tracker = targetDayTrackers[indexPath.section].tracker[indexPath.item]
        cell.nameLable.text = tracker.name
        cell.color = tracker.color
        cell.smail.text = tracker.emoji
        cell.id = tracker.id
        cell.delegate = self
        cell.status = false
        if executedTrackerIds.contains(tracker.id){
            guard let index = completedTrackers.firstIndex(where: { $0.idTracker == tracker.id }) else {
                print("При сборе ячейки не нашел трекер в выполненных")
                cell.apdateMark()
                return cell
            }
            let selDate = Calendar.current.dateComponents([.day, .month, .year], from: selectedDate)
            for date in completedTrackers[index].date {
                let dateCompleted = Calendar.current.dateComponents([.day, .month, .year], from: date)
                if selDate == dateCompleted {
                    cell.status = true
                }
            }
        }
        cell.apdateMark()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 10) / 2
        return CGSize(width: width, height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TrackerCollectionViewHeader", for: indexPath) as? TrackerCollectionViewHeader
        guard let headerView = headerView else {
            return UICollectionReusableView()
        }
        headerView.textLabel.text = targetDayTrackers[indexPath.section].title
        return headerView
    }
}

extension TrackerViewController: UICollectionViewDelegateFlowLayout {}

extension TrackerViewController: TrackerCellDelegate {
    func didTapAddButton(_ id: UUID, _ status: Bool) -> Bool{
        guard selectedDate < Date() else {
            return !status
        }
        var date: [Date] = []
        if executedTrackerIds.contains(id) {
            guard let index = completedTrackers.firstIndex(where: { $0.idTracker == id }) else {
                print("Не нашел трекер во время изменения статуса")
                return status
            }
            if status {
                
                date = completedTrackers[index].date + [selectedDate]
            } else {
                let selectedDate = Calendar.current.dateComponents([.day, .month, .year], from: selectedDate)
                for dateCompletedDate in completedTrackers[index].date {
                    let dateCompleted = Calendar.current.dateComponents([.day, .month, .year], from: dateCompletedDate)
                    if selectedDate == dateCompleted {
                        print(completedTrackers[index].date)
                        date = completedTrackers[index].date.filter { $0 != dateCompletedDate }
                        print(date)
                        guard !date.isEmpty else {
                            completedTrackers.remove(at: index)
                            executedTrackerIds.remove(id)
                            return status
                        }
                    }
                }
            }
            completedTrackers.remove(at: index)
        } else {
            date = [selectedDate]
        }
        completedTrackers.append(TrackerRecord(idTracker: id, date: date))
        executedTrackerIds.insert(id)
        return status
    }
}

extension Notification.Name {
    static let addCategory = Notification.Name("addCategory")
}

extension TrackerViewController: CreatingTrackerViewControllerDelegate {
    func passCategories() -> [TrackerCategory] {
        return categories
    }
}
