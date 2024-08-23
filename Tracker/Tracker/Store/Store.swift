//
//  Store.swift
//  Tracker
//
//  Created by Глеб Хамин on 19.08.2024.
//
enum TrackerStoreError: Error {
    case decodingErrorInvalidTitleTrackerCategory
    case decodingErrorInvalidColorHex
}

import UIKit
import CoreData

final class Store {
    
    let context: NSManagedObjectContext
//    private var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreDate>
    
//    var category: [TrackerCategory] {
//        guard
//            let objects = self.fetchedResultsController.fetchedObjects,
//            let category = try? objects.map({ try self.categoryArr(from: $0) })
//        else { return [] }
//        return category
//    }
    
    convenience init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
//    func categoryArr() throws -> [TrackerCategory] {
//        var categories: [TrackerCategory] = []
//        let request = NSFetchRequest<TrackerCategoryCoreDate>(entityName: "TrackerCategoryCoreDate")
//        let authors = try? context.fetch(request)
//        authors?.forEach { categories.append(TrackerCategory(title: $0.title!, tracker: [])) }
//        return categories
//    }
//    
//    func addNewCategory(_ trackerCategory: TrackerCategory) throws {
//        let trackerCategoryCoreDate = TrackerCategoryCoreDate(context: context)
//        trackerCategoryCoreDate.title = trackerCategory.title
//        try context.save()
//    }
    
    func categoryArr() throws -> [TrackerCategory] {
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
        
        func addNewCategory(_ trackerCategory: TrackerCategory) throws {
            do {
                let trackerCategoryCoreDate = TrackerCategoryCoreDate(context: context)
                trackerCategoryCoreDate.title = trackerCategory.title
                try context.save()
            } catch {
                throw error
            }
        }
    

}
