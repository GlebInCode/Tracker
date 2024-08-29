//
//  Store.swift
//  Tracker
//
//  Created by Глеб Хамин on 19.08.2024.
//

import UIKit
import CoreData

final class Store {
    static let shared = Store()
    let context: NSManagedObjectContext
    
    private convenience init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func getCategoriesTracker() throws -> [TrackerCategory] {
        var categories: [TrackerCategory] = []
        let request = NSFetchRequest<TrackerCategoryCoreDate>(entityName: "TrackerCategoryCoreDate")
        do {
            let categoriesCoreData = try context.fetch(request)
            categoriesCoreData.forEach { categoryCoreData in
                var trackers: [Tracker] = []
                categoryCoreData.tracker?.forEach { trackerCoreDataOptional in
                    if let trackerCoreData = trackerCoreDataOptional as? TrackerCoreDate {
                        if let id = trackerCoreData.id,
                           let name = trackerCoreData.name,
                           let color = trackerCoreData.color,
                           let emoji = trackerCoreData.emoji
                        {
                            var schedule: [DayOfWeek] = []
                            if let jsonSchedule = trackerCoreData.schedule as? NSData {
                                let daysOfWeek = try? JSONDecoder().decode([DayOfWeek].self, from: jsonSchedule as Data)
                                schedule = daysOfWeek ?? []
                            }
                            
                            let tracker = Tracker(id: id, name: name, color: color as! UIColor, emoji: emoji, schedule: schedule)
                            trackers.append(tracker)
                        }
                    }
                }
                if let title = categoryCoreData.title {
                    let category = TrackerCategory(title: title, tracker: trackers)
                    categories.append(category)
                }
            }
        } catch {
            throw error
        }
        return categories
    }
}
