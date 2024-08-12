//
//  SettingHabitViewController.swift
//  Tracker
//
//  Created by Глеб Хамин on 05.08.2024.
//

import Foundation
import UIKit

final class SettingHabitViewController: UIViewController {
    
    var newCategory: TrackerCategory?
    
    var trackerType: TrackerType?
    
    var cellsTable: [String] = []

    var categories: [TrackerCategory] = []

    
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
    
    private var currentCategory: Int?
    private var schedule: String = ""
    private var nameTracker: String = ""
    
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        defineCellsTable()
        setupTable()
        setupLayout()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateCategory(_:)), name: .updateCategory, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .updateCategory, object: nil)
    }
    
    @objc private func updateCategory(_ notification: Notification) {
        if let newCategory = notification.object as? [TrackerCategory] {
            categories = newCategory
        }
    }
    
    @IBAction private func create() {
        createCategory()
        let notification = Notification(name: .addCategory, object: newCategory)
        NotificationCenter.default.post(notification)
        if let window = UIApplication.shared.windows.first {
            window.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text, !text.isEmpty {
            nameTracker = text
            canPerformAction()
        } else {
            nameTracker = ""
        }
    }
    
    @IBAction private func cancellation() {
        if let window = UIApplication.shared.windows.first {
            window.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    private func createCategory() {
        guard let currentCategory else { return }
        var trackers: [Tracker] = [createTracker()]
        if !categories[currentCategory].tracker.isEmpty {
            trackers = categories[currentCategory].tracker + trackers
        }
        newCategory = TrackerCategory(title: categories[currentCategory].title, tracker: trackers)
    }
    
    private func createTracker() -> Tracker{
        let id = createId()
        let name = nameTracker
        let color: UIColor = .ypBlack
        let emoji = "😻"
        let schedule = sreateSchedule()
        return Tracker(id: id, name: name, color: color, emoji: emoji, schedule: schedule)
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
            if nameTracker.count > 0, schedule.count > 0, let _ = currentCategory {
                createButton.isEnabled = true
                createButton.backgroundColor = .ypBlack
            } else {
                createButton.isEnabled = false
                createButton.backgroundColor = .ypGray
            }
        case .event:
            if nameTracker.count > 0, let _ = currentCategory {
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
    
    private func setupLayout() {
        view.addSubview(titleView)
        view.addSubview(stackButton)
        view.addSubview(textFieldNameTracker)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: view.topAnchor),
            titleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            textFieldNameTracker.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 24),
            textFieldNameTracker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textFieldNameTracker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textFieldNameTracker.heightAnchor.constraint(equalToConstant: 75),
            
            tableView.topAnchor.constraint(equalTo: textFieldNameTracker.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: CGFloat(75 * cellsTable.count)),
            
            stackButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            stackButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}

extension SettingHabitViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 38
    }
}

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
        if indexPath.row == 0, let currentCategory {
            let text = categories[currentCategory].title
            typseTrackerCell.subLable.text = text
            typseTrackerCell.addSublabel()
        }
        self.tableView.roundingVorners(cell: typseTrackerCell, tableView: tableView, indexPath: indexPath)
        
        typseTrackerCell.setup(hideTopSeparator: indexPath.row == 0,
                               hideBotSeparator: indexPath.row == daysOfWeek.count - 1)
        
        return typseTrackerCell
    }
}

extension SettingHabitViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            let categoryTrackerVC = CategoryTrackerViewController()
            categoryTrackerVC.categories = categories
            categoryTrackerVC.delegate = self
            if let currentCategory {
                categoryTrackerVC.selectedIndexPath = IndexPath(row: currentCategory, section: 0)
            }
            self.present(categoryTrackerVC, animated:  true, completion: nil)
        } else if indexPath.row == 1 {
            let habitScheduleVC = HabitScheduleViewController()
            habitScheduleVC.delegate = self
            habitScheduleVC.daySelections = daySelections
            self.present(habitScheduleVC, animated:  true, completion: nil)
        }
    }
}

extension SettingHabitViewController: CategoryTrackerViewControllerDelegate {
    func updateСurrentCategory(_ indexPath: IndexPath) {
        currentCategory = indexPath.row
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.reloadRows(at: [indexPath], with: .automatic)
        canPerformAction()
    }
}

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

extension Notification.Name {
    static let updateCategory = Notification.Name("updateCategory")
}
