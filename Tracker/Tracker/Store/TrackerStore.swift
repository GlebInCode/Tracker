//
//  TrackerStore.swift
//  Tracker
//
//  Created by Глеб Хамин on 25.08.2024.
//

import Foundation
import CoreData

final class TrackerStore {
    private let context = Store.shared.context
    
    func addNewTracker(_ tracker: Tracker, _ category: String) {
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreDate> = TrackerCategoryCoreDate.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", category)
        do {
            let categories = try context.fetch(fetchRequest)
            if let category = categories.first {
                let trackerCoreDate = TrackerCoreDate(context: context)
                trackerCoreDate.id = tracker.id
                trackerCoreDate.name = tracker.name
                trackerCoreDate.emoji = tracker.emoji
                trackerCoreDate.color = tracker.color
                let jsonSchedule = try? JSONEncoder().encode(tracker.schedule)
                trackerCoreDate.schedule = jsonSchedule as NSData?
                
                trackerCoreDate.category = category
                try context.save()
            } else {
                print("Category not found with title: \(category)")
            }
        } catch {
            print("Error finding category: \(error)")
        }
    }
    
    func fetchedResultsController() -> NSFetchedResultsController<TrackerCoreDate> {
        let fetchRequest: NSFetchRequest<TrackerCoreDate> = TrackerCoreDate.fetchRequest()
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: context,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        return fetchedResultsController
    }
}
