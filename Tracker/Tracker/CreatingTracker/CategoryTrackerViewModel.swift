//
//  CategoryTrackerViewModel.swift
//  Tracker
//
//  Created by Глеб Хамин on 09.09.2024.
//

import Foundation

final class CategoryTrackerViewModel {
    
    // MARK: - Public Properties

    var categories: [TrackerCategory] = []
    
    // MARK: - Private Properties
        
    private let trackerCategoryStore = TrackerCategoryStore()
    private var selectedCategory: String?
    
    // MARK: - Initialization
    
    init() {
        updateCategory()
        loadSelectedCategory()
    }
    
    // MARK: - Table
    
    func countCategory() -> Int {
        categories.count
    }
    
    func titleCell(_ indexRow: Int) -> String {
        categories[indexRow].title
    }
    
    func selectedCell(_ title: String) -> Bool {
        title == selectedCategory
    }
    
    func didSelectCategory(_ title: String) {
        selectedCategory = title
        saveSelectedCategory()
    }
    
    // MARK: - Private Methods
    
    private func saveSelectedCategory() {
        guard let selectedCategory else {
            return
        }
        UserDefaults.standard.set(
            selectedCategory,
            forKey: Constants.selectedCategory)
    }
    
    private func loadSelectedCategory() {
        guard let title = UserDefaults.standard.string(
            forKey: Constants.selectedCategory
        ) else { return }
        selectedCategory = title
    }
    
    private func updateCategory() {
        do {
            categories = try trackerCategoryStore.getCategory()
        } catch {
            print("Данные не доступны")
        }
    }
}
