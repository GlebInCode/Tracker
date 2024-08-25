//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Глеб Хамин on 25.08.2024.
//

import Foundation
import CoreData

final class TrackerCategoryStore {
    private let context = Store.shared.context
    
    func addNewCategory(_ title: String) throws {
        let trackerCategoryCoreDate = TrackerCategoryCoreDate(context: context)
        trackerCategoryCoreDate.title = title
        try context.save()
    }
    
    func getCategory() throws -> [TrackerCategory] {
        var categories: [TrackerCategory] = []
        let request = NSFetchRequest<TrackerCategoryCoreDate>(entityName: "TrackerCategoryCoreDate")
        do {
            let authors = try context.fetch(request)
            authors.forEach { categories.append(TrackerCategory(title: $0.title!, tracker: [])) }
        } catch {
            throw error
        }
        return categories
    }
    
    func fetchedResultsController() -> NSFetchedResultsController<TrackerCategoryCoreDate> {
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreDate> = TrackerCategoryCoreDate.fetchRequest()

        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: context,
                                                    sectionNameKeyPath: nil,
                                                    cacheName: nil)
        return controller
    }
}
