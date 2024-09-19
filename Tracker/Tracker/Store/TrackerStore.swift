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
                trackerCoreDate.isPinned = tracker.isPinned
                
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
    
    func secureTracker(_ trackerId: UUID) {
        let fetchRequest: NSFetchRequest<TrackerCoreDate> = TrackerCoreDate.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", trackerId as NSUUID)
        
        do {
            let trackes = try context.fetch(fetchRequest)
            if let tracker = trackes.first {
                tracker.isPinned = !tracker.isPinned
                try context.save()
            }
        } catch {
            print("Ошибка поиска записи: \(error)")
        }
    }
    
    func saveTrackerChanges(_ tracker: Tracker, _ category: String) {
        let fetchRequestTracker: NSFetchRequest<TrackerCoreDate> = TrackerCoreDate.fetchRequest()
        fetchRequestTracker.predicate = NSPredicate(format: "id == %@", tracker.id as NSUUID)
        
        let fetchRequestCategory: NSFetchRequest<TrackerCategoryCoreDate> = TrackerCategoryCoreDate.fetchRequest()
        fetchRequestCategory.predicate = NSPredicate(format: "title == %@", category)
        
        do {
            let trackersCoreDate = try context.fetch(fetchRequestTracker)
            let categories = try context.fetch(fetchRequestCategory)
            if let trackerCoreDate = trackersCoreDate.first,
               let category = categories.first {
                
                trackerCoreDate.name = tracker.name
                trackerCoreDate.emoji = tracker.emoji
                trackerCoreDate.color = tracker.color
                let jsonSchedule = try? JSONEncoder().encode(tracker.schedule)
                trackerCoreDate.schedule = jsonSchedule as NSData?
                trackerCoreDate.isPinned = tracker.isPinned
                
                trackerCoreDate.category = category
                
                try context.save()
            }
        } catch {
            print("Ошибка поиска записи: \(error)")
        }
    }
    
    func getCategoryForTracker(_ trackerId: UUID) -> String {
        let fetchRequest: NSFetchRequest<TrackerCoreDate> = TrackerCoreDate.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", trackerId as NSUUID)
        var nameCategory = ""
        do {
            let trackes = try context.fetch(fetchRequest)
            if let tracker = trackes.first {
                if let category = tracker.category {
                    if let name = category.title {
                        nameCategory = name
                    }
                }
            }
        } catch {
            print("Ошибка поиска записи: \(error)")
        }
        return nameCategory
    }
    
    func deleteTracker(_ trackerId: UUID) {
        let fetchRequest: NSFetchRequest<TrackerCoreDate> = TrackerCoreDate.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", trackerId as NSUUID)
        
        do {
            let trackes = try context.fetch(fetchRequest)
            if let tracker = trackes.first {
                context.delete(tracker)
                try context.save()
            }
        } catch {
            print("Ошибка поиска записи: \(error)")
        }
    }
}
