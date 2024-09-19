//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Глеб Хамин on 25.07.2024.
//

import UIKit
import CoreData

enum Filter {
    case all
    case today
    case completed
    case unfinished
}

final class TrackerViewController: UIViewController {
    
    // MARK: - Public Properties
    
    var completedTrackers: [TrackerRecord] = []
    
    // MARK: - Private Properties
        
    private let store = Store.shared
    private let trackerStore = TrackerStore()
    private let trackerRecordStore = TrackerRecordStore()
    private let cellIdentifier = "cell"
    private let calendar = Calendar(identifier: .gregorian)
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var executedTrackerIds: Set<UUID> = []
    private var selectedDate = Date()
    private var targetSelectedDate: DateComponents?
    private var selectDayWeek: DayOfWeek?
    private var targetDayTrackers: [TrackerCategory] = []
    private var filterSerchText: String?
    private var filterSerchDayTrackers: [TrackerCategory] = []
    private var cellIsEnabled = true
    private var selectedFilter: Filter = .all
    private var filterTrackers: [TrackerCategory] = []
    
    // MARK: - UI Components
    
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
        datePicker.overrideUserInterfaceStyle = .light
        datePicker.backgroundColor = .ypWhite
        datePicker.layer.cornerRadius = 8
        datePicker.layer.masksToBounds = true
        datePicker.datePickerMode = .date
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        return datePicker
    }()
    
    private lazy var titleLable: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        let emptyStateText = NSLocalizedString("main.trackers", comment: "Трекеры")
        lable.text = emptyStateText
        lable.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        return lable
    }()
    
    private lazy var serchLine: UISearchTextField = {
        let searchTextField = UISearchTextField()
        searchTextField.textColor = UIColor(named: "Gray")
        searchTextField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        let emptyStateText = NSLocalizedString("main.search", comment: "Поиск")
        searchTextField.placeholder = emptyStateText
        searchTextField.backgroundColor = .ypWhite
        searchTextField.layer.cornerRadius = 9
        searchTextField.layer.masksToBounds = true
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        
        return searchTextField
    }()
    
    private lazy var noDataView: NoDataView = {
        let view = NoDataView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let emptyStateText = NSLocalizedString("main.placeholder", comment: "Что будем отслеживать?")
        view.text = emptyStateText
        view.image = UIImage(named: "NoContent")
        return view
    }()
    
    private lazy var noSearchView: NoDataView = {
        let view = NoDataView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let emptyStateText = NSLocalizedString("main.noSearch", comment: "Ничего не найдено")
        view.text = emptyStateText
        view.image = UIImage(named: "SearchError")
        return view
    }()
    
    private lazy var filterButton: UIButton = {
        let button = UIButton()
        button.overrideUserInterfaceStyle = .light
        button.translatesAutoresizingMaskIntoConstraints = false
        let emptyStateText = NSLocalizedString("main.filters", comment: "Фильтры")
        button.setTitle(emptyStateText, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        button.sizeToFit()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        button.titleLabel?.textColor = .ypWhite
        button.backgroundColor = .ypBlue
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(openFilterMenu), for: .touchUpInside)
        return button
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .none
        layout.sectionInset = UIEdgeInsets(top: 0, left: 13, bottom: 0, right: 13)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.register(
            TrackerCollectionViewHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "TrackerCollectionViewHeader")
        return collectionView
    }()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        updateCollectionTrackerDate(selectedDate)
        udateDate()
        setupConstraints()
        showContentOrPlaceholder()
        notifyDataChanged()
    }
    
    deinit {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self)
    }
    
    // MARK: - IBActions
    
    @IBAction private func addTracker() {
        let creatingTrackerVC = CreatingTrackerViewController()
        self.present(creatingTrackerVC, animated: true, completion: nil)
    }
    
    // MARK: - Public Methods
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int) -> CGSize {
            return CGSize(width: collectionView.frame.width, height: 46)
        }
    
    // MARK: - Private Methods

    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let date = sender.date
        updateCollectionTrackerDate(date)
        udateDate()
        updateCellIsEnabled()
        showContentOrPlaceholder()
        collectionView.reloadData()
        if selectedFilter == .today {
            selectedFilter = .all
        }
    }
    
    @objc func textDidChange(_ searchField: UISearchTextField) {
        if let searchText = searchField.text, !searchText.isEmpty {
            filterSerchText = searchText
            updatefilterSerch()
        } else {
            filterSerchText = nil
            filterSerchDayTrackers = targetDayTrackers
        }
        showContentOrPlaceholder()
        collectionView.reloadData()
    }
    
    @objc func openFilterMenu() {
        let filterVC = FilterViewController()
        filterVC.delegate = self
        filterVC.selectedFilter = selectedFilter
        self.present(filterVC, animated: true, completion: nil)
    }
    
    private func updatefilterSerch() {
        guard let filterSerchText else{
            filterSerchDayTrackers = targetDayTrackers
            return
        }
        filterSerchDayTrackers = targetDayTrackers.compactMap { category in
            let categoryMatches = category.title.lowercased().contains(filterSerchText.lowercased())
            let filteredTrackers = category.tracker.filter { $0.name.lowercased().contains(filterSerchText.lowercased()) }
            return categoryMatches ? category : (filteredTrackers.isEmpty ? nil : TrackerCategory(title: category.title, tracker: filteredTrackers))
        }
    }
    
    private func notifyDataChanged() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(forName: Notification.Name("DataUpdated"), object: nil, queue: nil) { [weak self] notification in
            
            self?.udateDate()
            self?.updateCellIsEnabled()
            self?.showContentOrPlaceholder()
            self?.collectionView.reloadData()
        }
    }
    
    private func udateDate() {
        do {
            completedTrackers = try trackerRecordStore.getCompletedTrackers()
            updateExecutedTrackerIds()
            let category = try store.getCategoriesTracker()
            updateTargetDayTrackers(category)
            updatefilterSerch()
            updateSelectFilter()
        } catch {
            print("Данные не доступны")
        }
        
    }
    
    private func updateCellIsEnabled() {
        cellIsEnabled = selectedDate <= Date()
    }
    
    private func showContentOrPlaceholder() {
        if targetDayTrackers.count > 0 {
            if filterSerchDayTrackers.count > 0 {
                if filterTrackers.count > 0 {
                    layoutCollection()
                    layoutFilter()
                    colorFilterButton()
                    
                    noSearchView.removeFromSuperview()
                    noDataView.removeFromSuperview()
                } else {
                    filterButton.removeFromSuperview()
                    layoutFilter()
                    colorFilterButton()
                    loadDefaultImage(noSearchView)
                }
            } else {
                
                filterButton.removeFromSuperview()
                noDataView.removeFromSuperview()
                loadDefaultImage(noSearchView)
            }
        } else {
            filterButton.removeFromSuperview()
            noSearchView.removeFromSuperview()
            loadDefaultImage(noDataView)
            
        }
    }
    
    private func updateCollectionTrackerDate(_ date: Date) {
        selectedDate = date
        targetSelectedDate = Calendar.current.dateComponents([.day, .month, .year], from: date)
        getDayOfWeek(date: date)
    }
    
    private func getDayOfWeek(date: Date) {
        let dayOfWeek = calendar.component(.weekday, from: date)
        
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
    }
    
    private func updateTargetDayTrackers(_ categories: [TrackerCategory]) {
        targetDayTrackers = []
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
                            let compareDate = Calendar.current.dateComponents([.day, .month, .year], from: completedTrackers[index].date[0])
                            if compareDate == targetSelectedDate {
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
    }
    
    private func updateExecutedTrackerIds() {
        executedTrackerIds.removeAll()
        for tracker in completedTrackers {
            let id = tracker.idTracker
            executedTrackerIds.insert(id)
        }
    }
    
    private func updateFilter() {
        switch selectedFilter {
        case .all:
            filterTrackers = filterSerchDayTrackers
            datePickerValueChanged(datePicker)
        case .today:
            datePicker.date = Date()
            datePickerValueChanged(datePicker)
        case .completed:
            datePickerValueChanged(datePicker)
        case .unfinished:
            datePickerValueChanged(datePicker)
        }
    }
    
    private func updateSelectFilter() {
        guard selectedFilter == .completed || selectedFilter == .unfinished else {
            filterTrackers = filterSerchDayTrackers
            return
        }
        if selectedFilter == .completed {
            filterCompleted()
        } else if selectedFilter == .unfinished {
            filterUnfinished()
        }
    }
    
    private func filterCompleted() {
        filterTrackers = []

        for category in filterSerchDayTrackers {
            var treckers: [Tracker] = []

            for tracker in category.tracker {
                if executedTrackerIds.contains(tracker.id){
                    guard let index = completedTrackers.firstIndex(where: { $0.idTracker == tracker.id }) else {
                        continue
                    }
                    for date in completedTrackers[index].date {
                        let dateCompleted = Calendar.current.dateComponents([.day, .month, .year], from: date)
                        if targetSelectedDate == dateCompleted {
                            treckers.append(tracker)
                            break
                        }
                    }
                }
            }

            if !treckers.isEmpty {
                filterTrackers.append(TrackerCategory(title: category.title, tracker: treckers))
            }
        }
    }
    
    private func filterUnfinished() {
        filterTrackers = []

        for category in filterSerchDayTrackers {
            var treckers: [Tracker] = []

            for tracker in category.tracker {
                if executedTrackerIds.contains(tracker.id){
                    guard let index = completedTrackers.firstIndex(where: { $0.idTracker == tracker.id }) else {
                        continue
                    }
                    var status = false
                    for date in completedTrackers[index].date {
                        let dateCompleted = Calendar.current.dateComponents([.day, .month, .year], from: date)
                        if targetSelectedDate == dateCompleted {
                            status = true
                            break
                        }
                    }
                    if !status {
                        treckers.append(tracker)
                    }
                } else {
                    treckers.append(tracker)
                }
            }
            if !treckers.isEmpty {
                filterTrackers.append(TrackerCategory(title: category.title, tracker: treckers))
            }
        }
    }
    
    func colorFilterButton() {
        switch selectedFilter {
        case .all:
            filterButton.backgroundColor = .ypBlue
        case .today:
            filterButton.backgroundColor = .ypRed
        case .completed:
            filterButton.backgroundColor = .ypRed
        case .unfinished:
            filterButton.backgroundColor = .ypRed
        }
    }
    
    // MARK: - View Layout
    
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
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
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
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func layoutFilter() {
        view.addSubview(filterButton)
        
        NSLayoutConstraint.activate([
            filterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            filterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filterButton.heightAnchor.constraint(equalToConstant: 60),
            
        ])
    }
    
    private func loadDefaultImage(_ placeholders: UIView) {
        view.addSubview(placeholders)
        
        NSLayoutConstraint.activate([
            placeholders.topAnchor.constraint(equalTo: serchLine.bottomAnchor, constant: 10),
            placeholders.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            placeholders.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            placeholders.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

// MARK: - Extension: UICollectionViewDataSource

extension TrackerViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return filterTrackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterTrackers[section].tracker.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? TrackerCollectionViewCell
        guard let cell = cell else {
            return UICollectionViewCell()
        }
        let tracker = filterTrackers[indexPath.section].tracker[indexPath.item]
        
        cell.delegate = self
        cell.delegateContextMenu = self
        var day = 0
        var status = false
        
        if executedTrackerIds.contains(tracker.id){
            guard let index = completedTrackers.firstIndex(where: { $0.idTracker == tracker.id }) else {
                print("При сборе ячейки не нашел трекер в выполненных")
                return cell
            }
            day = completedTrackers[index].date.count
            cell.updateCountDays(day: day)
            for date in completedTrackers[index].date {
                let dateCompleted = Calendar.current.dateComponents([.day, .month, .year], from: date)
                if targetSelectedDate == dateCompleted {
                    status = true
                }
            }
        }
        
        cell.configCell(id: tracker.id, name: tracker.name, color: tracker.color, emoji: tracker.emoji, executionStatus: status, day: day, cellStatus: cellIsEnabled, isPinned: tracker.isPinned)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 26) / 2
        return CGSize(width: width, height: 152)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TrackerCollectionViewHeader", for: indexPath) as? TrackerCollectionViewHeader
        guard let headerView = headerView else {
            return UICollectionReusableView()
        }
        headerView.textLabel.text = filterTrackers[indexPath.section].title
        return headerView
    }
}

// MARK: - Extension: UICollectionViewDelegateFlowLayout

extension TrackerViewController: UICollectionViewDelegateFlowLayout {
}

// MARK: - Extension: TrackerCellDelegate

extension TrackerViewController: TrackerCellDelegate {
    func didTapAddButton(_ id: UUID, _ status: Bool) {
        
        if executedTrackerIds.contains(id) {
            guard let index = completedTrackers.firstIndex(where: { $0.idTracker == id }) else {
                print("Не нашел трекер во время изменения статуса")
                return
            }
            if !status {
                let selectedDate = Calendar.current.dateComponents([.day, .month, .year], from: selectedDate)
                for dateCompletedDate in completedTrackers[index].date {
                    let dateCompleted = Calendar.current.dateComponents([.day, .month, .year], from: dateCompletedDate)
                    if selectedDate == dateCompleted {
                        trackerRecordStore.deleteTrackerRecord(trackerId: id, date: dateCompletedDate)
                        udateDate()
                        return
                    }
                }
            }
        }
        trackerRecordStore.addNewTrackerRecord(trackerId: id, date: selectedDate)
        udateDate()
    }
}

// MARK: - Extension: FilterViewControllerDelegate

extension TrackerViewController: FilterViewControllerDelegate {
    func updateFilter(_ selectFilter: Filter) {
        selectedFilter = selectFilter
        updateFilter()
    }
}

// MARK: - Extension: ContextMenuDelegate

extension TrackerViewController: ContextMenuDelegate {
    func contextMenuSecure(_ trackerId: UUID) {
        trackerStore.secureTracker(trackerId)
        udateDate()
        collectionView.reloadData()
    }
    
    func contextMenuUnpin(_ trackerId: UUID) {
        
    }
    
    func contextMenuLeave(_ trackerId: UUID, _ countDay: Int) {
        leaveTracker(trackerId, countDay)
    }
    
    func contextMenuDelete(_ trackerId: UUID) {
        showActionSheet(trackerId)
    }
    
    private func leaveTracker(_ trackerId: UUID, _ countDay: Int) {
        let settingHabitViewController = SettingHabitViewController()
        var selectedTracker: Tracker?

        for category in filterTrackers {
            for tracker in category.tracker {
                if tracker.id == trackerId {
                    selectedTracker = tracker
                    break
                }
            }
            if selectedTracker != nil {
                break
            }
        }
        guard let selectedTracker else {
            return
        }
        
        settingHabitViewController.settingTracker(selectedTracker.id, selectedTracker.name, selectedTracker.color, selectedTracker.emoji, selectedTracker.schedule, countDay, selectedTracker.isPinned)
        self.present(settingHabitViewController, animated: true, completion: nil)
    }
    
    private func showActionSheet(_ trackerId: UUID) {
        
        let emptyStateTextTitle = NSLocalizedString("main.alert.title", comment: "Уверены что хотите удалить трекер?")
        let actionSheet = UIAlertController(title: emptyStateTextTitle, message: nil, preferredStyle: .actionSheet)
        
        let emptyStateTextDelete = NSLocalizedString("main.alert.delete", comment: "Удалить")
        let firstButton = UIAlertAction(title: emptyStateTextDelete, style: .destructive) { _ in
            self.deleteTracker(trackerId)
        }
        
        let emptyStateTextCancel = NSLocalizedString("main.alert.cancel", comment: "Отмена")
        let cancelButton = UIAlertAction(title: emptyStateTextCancel, style: .cancel)
        
        actionSheet.addAction(firstButton)
        actionSheet.addAction(cancelButton)
        
        present(actionSheet, animated: true)
    }
    
    private func deleteTracker(_ trackerId: UUID) {
        trackerRecordStore.deleteTrackerRecord(trackerId)
        trackerStore.deleteTracker(trackerId)
        udateDate()
        updateCellIsEnabled()
        showContentOrPlaceholder()
        collectionView.reloadData()
    }
    
}
