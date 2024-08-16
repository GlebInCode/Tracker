//
//  HabitScheduleViewController.swift
//  Tracker
//
//  Created by Глеб Хамин on 07.08.2024.
//

import UIKit

// MARK: - Protocol: HabitScheduleViewControllerDelegate

protocol HabitScheduleViewControllerDelegate: AnyObject {
    func updateSchedule(_ daysOfWeek: [DayOfWeek: Bool])
}

final class HabitScheduleViewController: UIViewController {
    
    // MARK: - Public Properties
    
    var daySelections: [DayOfWeek: Bool] = [:]
    weak var delegate: HabitScheduleViewControllerDelegate?
    
    // MARK: - Private Properties
    
    private let daysOfWeek: [DayOfWeek] = [
        .monday,
        .tuesday,
        .wednesday,
        .thursday,
        .friday,
        .saturday,
        .sunday
    ]
    
    // MARK: - UI Components
    
    private lazy var titleView: UILabel = {
        let lable = CustomTitle()
        lable.text = "Расписание"
        return lable
    }()
    
    private lazy var readyButton: UIButton = {
        let button = CustomBlakButton()
        button.backgroundColor = .ypGray
        button.setTitle("Готово", for: .normal)
        button.addTarget(self, action: #selector(ready), for: .touchUpInside)
        return button
    }()
    
    private let tableView = ParameterTable(frame: .zero, style: .plain)
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupTable()
        setupLayout()
        shouldEnableButton()
    }
    
    // MARK: - IBActions
    
    @IBAction private func switchChanged(_ sender: UISwitch) {
        let day = daysOfWeek[sender.tag]
        daySelections[day] = sender.isOn
        
        shouldEnableButton()
    }
    
    // MARK: - Private Methods
    
    @objc private func ready() {
        if let delegate = delegate {
            delegate.updateSchedule(daySelections)
        }
        dismiss(animated: true, completion: nil)
    }
    
    private func shouldEnableButton() {
        if daySelections.contains(where: { $0.value }) {
            readyButton.isEnabled = true
            readyButton.backgroundColor = .ypBlack
        } else {
            readyButton.isEnabled = false
            readyButton.backgroundColor = .ypGray        }
    }
    
    private func setupTable() {
        tableView.dataSource = self
    }
    
    private func printDayOfWeek(_ day: DayOfWeek) -> String{
        switch day {
        case .monday:
            "Понедельник"
        case .tuesday:
            "Вторник"
        case .wednesday:
            "Среда"
        case .thursday:
            "Четверг"
        case .friday:
            "Пятница"
        case .saturday:
            "Суббота"
        case .sunday:
            "Воскресенье"
        }
    }
    
    // MARK: - View Layout
    
    private func setupLayout() {
        view.addSubview(titleView)
        view.addSubview(tableView)
        view.addSubview(readyButton)
        
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: view.topAnchor),
            titleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            readyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            readyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            readyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: readyButton.topAnchor, constant: -16)
        ])
    }
}

// MARK: - Extension: UITableViewDataSource

extension HabitScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        daysOfWeek.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DayWeekCell", for: indexPath)
        
        guard let typseTrackerCell = cell as? DayWeekCell else {
            return UITableViewCell()
        }
        
        let day = daysOfWeek[indexPath.row]
        let text = printDayOfWeek(day)
        typseTrackerCell.lable.text = text
        let selectedIndex: Bool = daySelections[day] ?? false
        typseTrackerCell.switchControl.isOn = selectedIndex
        typseTrackerCell.switchControl.tag = indexPath.row
        typseTrackerCell.switchControl.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
        
        self.tableView.roundingVorners(cell: typseTrackerCell, tableView: tableView, indexPath: indexPath)
        
        typseTrackerCell.setup(hideTopSeparator: indexPath.row == 0,
                               hideBotSeparator: indexPath.row == daysOfWeek.count - 1)
        return typseTrackerCell
    }
}
