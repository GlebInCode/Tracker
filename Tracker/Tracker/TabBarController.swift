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
        viewControllers = [
            generateVC(
                viewController: TrackerViewController(),
                title: "Трекер",
                image: UIImage(named: "Tracker")
            ),
            generateVC(
                viewController: StaticticsViewController(),
                title: "Статистика",
                image: UIImage(named: "Statistics")
            )
        ]
        
    }
    
    private func generateVC(viewController: UIViewController, title: String, image: UIImage?) -> UIViewController {
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image
        return viewController
    }
    
}

