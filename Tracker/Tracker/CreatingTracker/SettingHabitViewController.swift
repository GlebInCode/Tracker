//
//  SettingHabitViewController.swift
//  Tracker
//
//  Created by Глеб Хамин on 05.08.2024.
//

import Foundation
import UIKit

final class SettingHabitViewController: UIViewController {
    
    // MARK: - Public Properties
    
    var trackerType: TrackerType?
    var categories: [TrackerCategory] = []
    
    // MARK: - Private Properties

    private let trackerStore = TrackerStore()
    private var tracker: Tracker?
    private var cellsTable: [String] = []
    private var newCategory: TrackerCategory?
    private var nameCategory: String?
    private var schedule: String = ""
    private var nameTracker: String = ""
    private var daySelections: [DayOfWeek: Bool] = [.monday : false,
                                                    .tuesday : false,
                                                    .wednesday : false,
                                                    .thursday : false,
                                                    .friday : false,
                                                    .saturday : false,
                                                    .sunday : false]
    private let daysOfWeek: [DayOfWeek] = [
        .monday,
        .tuesday,
        .wednesday,
        .thursday,
        .friday,
        .saturday,
        .sunday
    ]
    private let settingSection = ["Emoji", "Цвет"]
    private let emojies = [
        "🙂", "😻", "🌺", "🐶", "❤️", "😱",
        "😇", "😡", "🥶", "🤔", "🙌", "🍔",
        "🥦", "🏓", "🥇", "🎸", "🌴", "😪"
    ]
    private var selectEmoji: Int?
    private let colors = [
        "#FD4C49", "#FF881E", "#007BFA", "#6E44FE", "#33CF69", "#E66DD4",
        "#F9D4D4", "#34A7FE", "#46E69D", "#35347C", "#FF674D", "#FF99CC",
        "#F6C48B", "#7994F5", "#832CF1", "#AD56DA", "#8D72E6", "#2FD058"
    ]
    private var selectColor: Int?
    private let emojiCellIdentifier = "EmojiCell"
    private let colorCellIdentifier = "ColorCell"
    
    // MARK: - UI Components

    private lazy var titleView: UILabel = {
        let lable = CustomTitle()
        if let trackerType = trackerType {
            switch trackerType {
            case .habit:
                lable.text = "Новая привычка"
            case .event:
                lable.text = "Новое нерегулярное событие"
            }
        }
        return lable
    }()
    
    private lazy var createButton: UIButton = {
        let button = UIButton()
        button.setTitle("Создать", for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.backgroundColor = .ypGray
        button.addTarget(self, action: #selector(create), for: .touchUpInside)
        return button
    }()
    
    private lazy var cancellationButton: UIButton = {
        let button = UIButton()
        button.setTitle("Отменить", for: .normal)
        button.setTitleColor(.ypRed, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.backgroundColor = .none
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.ypRed.cgColor
        button.addTarget(self, action: #selector(cancellation), for: .touchUpInside)
        return button
    }()
    
    private lazy var stackButton: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [cancellationButton, createButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var textFieldNameTracker: CustomTextFiel = {
        let textField = CustomTextFiel(placeholder: "Введите название трекера")
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return textField
    }()
    
    private let tableView = ParameterTable(frame: .zero, style: .plain)
    
    private lazy var settingScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        let height: CGFloat = 99 + CGFloat(75 * cellsTable.count) + calculateCellSize()
        scrollView.contentSize = CGSize(width: view.frame.width - 34, height: height)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        collectionView.allowsMultipleSelection = true
        collectionView.register(EmojiCollectionViewCell.self, forCellWithReuseIdentifier: emojiCellIdentifier)
        collectionView.register(ColorCollectionViewHeader.self, forCellWithReuseIdentifier: colorCellIdentifier)
        collectionView.register(SettingCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SettingCollectionViewHeader")
        return collectionView
    }()
    
    
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        defineCellsTable()
        setupTable()
        setupLayout()
    }
    
    deinit {
        UserDefaults.standard.removeObject(forKey: Constants.selectedCategory)
    }
    
    // MARK: - IBActions

    @IBAction private func create() {
        createTracker()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(name: Notification.Name("DataUpdated"), object: self, userInfo: nil)

        if let window = UIApplication.shared.windows.first {
            window.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction private func cancellation() {
        if let window = UIApplication.shared.windows.first {
            window.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Private Methods
    
    func calculateCellSize() -> CGFloat {
        let width = view.frame.width - 32
        let height: CGFloat
        let heightCell = width / 6
        height = heightCell * 6 + 74 * 2
        return height
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text, !text.isEmpty {
            nameTracker = text
            canPerformAction()
        } else {
            nameTracker = ""
        }
    }
    
    private func createTracker() {
        guard let nameCategory, let selectColor, let selectEmoji else { return }
        guard let colorUI = UIColor(hex: colors[selectColor]) else { return }
        let id = createId()
        let name = nameTracker
        let color = colorUI
        let emoji = emojies[selectEmoji]
        let schedule = sreateSchedule()
        tracker = Tracker(id: id, name: name, color: color, emoji: emoji, schedule: schedule)
        guard let tracker else { return }
        trackerStore.addNewTracker(tracker, nameCategory)
    }
    
    private func createId() -> UUID {
        let uuid = UUID()
        let id = uuid
        return id
    }
    
    private func sreateSchedule() -> [DayOfWeek]{
        var schedule: [DayOfWeek] = []
        for (day, isSelected) in daySelections {
            if isSelected {
                schedule.append(day)
            }
        }
        return schedule
    }
    
    private func canPerformAction() {
        switch trackerType {
        case .habit:
            if nameTracker.count > 0, schedule.count > 0, let _ = nameCategory, let _ = selectColor, let _ = selectEmoji {
                createButton.isEnabled = true
                createButton.backgroundColor = .ypBlack
            } else {
                createButton.isEnabled = false
                createButton.backgroundColor = .ypGray
            }
        case .event:
            if nameTracker.count > 0, let _ = nameCategory, let _ = selectColor, let _ = selectEmoji {
                createButton.isEnabled = true
                createButton.backgroundColor = .ypBlack
            } else {
                createButton.isEnabled = false
                createButton.backgroundColor = .ypGray
            }
        case nil:
            return
        }
    }
    
    private func defineCellsTable(){
            switch trackerType {
            case .habit:
                return cellsTable = ["Категория", "Расписание"]
            case .event:
                return cellsTable = ["Категория"]
            case .none:
                return cellsTable = []
            }
    }
    
    private func setupTable() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = false
    }
    
    private func loadSelectedCategory() {
        guard let title = UserDefaults.standard.string(
            forKey: Constants.selectedCategory
        ) else { return }
        nameCategory = title
    }
    
    // MARK: - View Layout

    private func setupLayout() {
        view.addSubview(titleView)
        view.addSubview(stackButton)
        
        view.addSubview(settingScrollView)
        settingScrollView.addSubview(tableView)
        settingScrollView.addSubview(textFieldNameTracker)
        settingScrollView.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: view.topAnchor),
            titleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            stackButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            stackButton.heightAnchor.constraint(equalToConstant: 60),
            
            settingScrollView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 24),
            settingScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            settingScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            settingScrollView.bottomAnchor.constraint(equalTo: stackButton.topAnchor, constant: -16),
            
            textFieldNameTracker.topAnchor.constraint(equalTo: settingScrollView.topAnchor),
            textFieldNameTracker.widthAnchor.constraint(equalTo: settingScrollView.widthAnchor),
            textFieldNameTracker.heightAnchor.constraint(equalToConstant: 75),
            
            tableView.topAnchor.constraint(equalTo: textFieldNameTracker.bottomAnchor, constant: 24),
            tableView.widthAnchor.constraint(equalTo: settingScrollView.widthAnchor),
            tableView.heightAnchor.constraint(equalToConstant: CGFloat(75 * cellsTable.count)),
            
            collectionView.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            collectionView.widthAnchor.constraint(equalTo: settingScrollView.widthAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: calculateCellSize())
        ])
    }
}

// MARK: - Extension: UITextFieldDelegate

extension SettingHabitViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 38
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - Extension: UITableViewDataSource

extension SettingHabitViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellsTable.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TypseTrackerCell", for: indexPath)
        
        guard let typseTrackerCell = cell as? TypseTrackerCell else {
            return UITableViewCell()
        }
        typseTrackerCell.lable.text = cellsTable[indexPath.row]
        if indexPath.row == 1, schedule.count != 0 {
            typseTrackerCell.subLable.text = schedule
            typseTrackerCell.addSublabel()
        }
        if indexPath.row == 0, let nameCategory {
            typseTrackerCell.subLable.text = nameCategory
            typseTrackerCell.addSublabel()
        }
        self.tableView.roundingVorners(cell: typseTrackerCell, tableView: tableView, indexPath: indexPath)
        
        typseTrackerCell.setup(hideTopSeparator: indexPath.row == 0,
                               hideBotSeparator: indexPath.row == daysOfWeek.count - 1)
        
        return typseTrackerCell
    }
}

// MARK: - Extension: UITableViewDelegate

extension SettingHabitViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            let categoryTrackerVC = CategoryTrackerViewController()
            categoryTrackerVC.delegate = self
            self.present(categoryTrackerVC, animated:  true, completion: nil)
        } else if indexPath.row == 1 {
            let habitScheduleVC = HabitScheduleViewController()
            habitScheduleVC.delegate = self
            habitScheduleVC.daySelections = daySelections
            self.present(habitScheduleVC, animated:  true, completion: nil)
        }
    }
}

// MARK: - Extension: CategoryTrackerViewControllerDelegate

extension SettingHabitViewController: CategoryTrackerViewControllerDelegate {
    func updateСurrentCategory() {
        loadSelectedCategory()
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.reloadRows(at: [indexPath], with: .automatic)
        canPerformAction()
    }
}

// MARK: - Extension: HabitScheduleViewControllerDelegate

extension SettingHabitViewController: HabitScheduleViewControllerDelegate {
    func updateSchedule(_ daysWeek: [DayOfWeek: Bool]) {
        daySelections = daysWeek
        schedule = formatDaysOfWeek()
        let indexPath = IndexPath(row: 1, section: 0)
        tableView.reloadRows(at: [indexPath], with: .automatic)
        canPerformAction()
    }
    
    private func formatDaysOfWeek() -> String {
        var scheduleString = ""
        
        if daySelections.allSatisfy({ $0.value }) {
            return "Каждый день"
        }
        for day in daysOfWeek {
            if daySelections[day] ?? false {
                var dayAbbreviation = ""
                switch day {
                case .monday:
                    dayAbbreviation = "Пн"
                case .tuesday:
                    dayAbbreviation = "Вт"
                case .wednesday:
                    dayAbbreviation = "Ср"
                case .thursday:
                    dayAbbreviation = "Чт"
                case .friday:
                    dayAbbreviation = "Пт"
                case .saturday:
                    dayAbbreviation = "Сб"
                case .sunday:
                    dayAbbreviation = "Вс"
                }
                scheduleString = scheduleString.isEmpty ? dayAbbreviation : scheduleString + ", \(dayAbbreviation)"
            }
        }
        return scheduleString
    }
}

// MARK: - Extension: UICollectionViewDataSource

extension SettingHabitViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return settingSection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerSection = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SettingCollectionViewHeader", for: indexPath) as? SettingCollectionViewHeader else {
            return UICollectionReusableView()
        }
        headerSection.configHeader(title: settingSection[indexPath.section])
        return headerSection
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return emojies.count
        } else if section == 1 {
            return colors.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: emojiCellIdentifier, for: indexPath) as? EmojiCollectionViewCell else {
                return UICollectionViewCell()
            }
            var select = false
            if let selectEmoji, selectEmoji == indexPath.row {
                select = true
            }
            cell.configCell(emoji: emojies[indexPath.row], select: select)
            return cell
        } else if indexPath.section == 1 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: colorCellIdentifier, for: indexPath) as? ColorCollectionViewHeader else {
                return UICollectionViewCell()
            }
            var select = false
            if let selectColor, selectColor == indexPath.row {
                select = true
            }
            cell.configCell(color: colors[indexPath.row],select: select)
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width) / 6
        return CGSize(width: width, height: width)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int) -> CGSize {
            return CGSize(width: collectionView.frame.width, height: 74)
        }
}

// MARK: - Extension: UICollectionViewDelegateFlowLayout

extension SettingHabitViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            selectEmoji = indexPath.row
        } else if indexPath.section == 1 {
            selectColor = indexPath.row
        }
        collectionView.reloadData()
        canPerformAction()
    }
}

