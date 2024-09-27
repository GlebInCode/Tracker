//
//  TabBarController.swift
//  Tracker
//
//  Created by Глеб Хамин on 25.07.2024.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateTabBar()
        
    }
    
    private func generateTabBar() {
        let emptyStateText1 = NSLocalizedString("main.trackers", comment: "Трекеры")
        let emptyStateText2 = NSLocalizedString("main.statictics", comment: "Статистика")
        viewControllers = [
            generateVC(
                viewController: TrackerViewController(),
                title: emptyStateText1,
                image: UIImage(named: "Tracker")
            ),
            generateVC(
                viewController: StaticticsViewController(),
                title: emptyStateText2,
                image: UIImage(named: "Statistics")
            )
        ]
        
    }
    
    private func generateVC(viewController: UIViewController, title: String, image: UIImage?) -> UIViewController {
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image
        
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: tabBar.frame.width, height: 1.0)
        topBorder.backgroundColor = UIColor.ypTabBarGray.cgColor
        tabBar.layer.addSublayer(topBorder)
        
        return viewController
    }
    
}

