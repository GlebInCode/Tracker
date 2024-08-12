//
//  HabitScheduleViewController.swift
//  Tracker
//
//  Created by Глеб Хамин on 07.08.2024.
//

import UIKit

protocol HabitScheduleViewControllerDelegate: AnyObject {
    func updateSchedule(_ daysOfWeek: [DayOfWeek: Bool])
}

final class HabitScheduleViewController: UIViewController {
    
    weak var delegate: HabitScheduleViewControllerDelegate?
    
    private let daysOfWeek: [DayOfWeek] = [
        .monday,
        .tuesday,
        .wednesday,
        .thursday,
        .friday,
        .saturday,
        .sunday
    ]
    
    var daySelections: [DayOfWeek: Bool] = [:]
    
    private lazy var titleView: UILabel = {
        let lable = CustomTitle()
        lable.text = "Расписание"
        return lable
    }()
    
    private lazy var readyButton: UIButton = {
        let button = CustomBlakButton()
        button.backgroundColor = .ypGray
        button.isEnabled = false
        button.setTitle("Готово", for: .normal)
        button.addTarget(self, action: #selector(ready), for: .touchUpInside)
        return button
    }()
    
    private let tableView = ParameterTable(frame: .zero, style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupTable()
        setupLayout()
    }
    
    @IBAction private func ready() {
        
        if let delegate = delegate {
            delegate.updateSchedule(daySelections)
        }
        dismiss(animated: true, completion: nil)
    }
    
    private func setupTable() {
        tableView.dataSource = self
    }
    
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
    
    @IBAction private func switchChanged(_ sender: UISwitch) {
        let day = daysOfWeek[sender.tag]
        daySelections[day] = sender.isOn
        
        if daySelections.contains(where: { $0.value }) {
            readyButton.isEnabled = true
            readyButton.backgroundColor = .ypBlack
        } else {
            readyButton.isEnabled = false
            readyButton.backgroundColor = .ypGray        }
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
    
    
}
