//
//  Store.swift
//  Tracker
//
//  Created by Глеб Хамин on 19.08.2024.
//

import UIKit
import CoreData

final class Store {
    
    let context: NSManagedObjectContext
    
    convenience init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
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
    
    func addNewCategory(_ title: String) throws {
        let trackerCategoryCoreDate = TrackerCategoryCoreDate(context: context)
        trackerCategoryCoreDate.title = title
        try context.save()
    }
    
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
        print(categories)
        return categories
    }
    
    func getCompletedTrackers() throws -> [TrackerRecord] {
        var trackerRecord: [TrackerRecord] = []
        let request = NSFetchRequest<TrackerCoreDate>(entityName: "TrackerCoreDate")
        do {
            let trackersCoreData = try context.fetch(request)
            
            for trackerCoreData in trackersCoreData {
                
                let trackerId = trackerCoreData.id
                var recordTracker: [Date] = []
                let records = trackerCoreData.record?.allObjects as? [TrackerRecordCoreDate]
                if let records {
                    for record in records {
                        record.willAccessValue(forKey: "data")
                        if let date = record.date {
                            recordTracker.append(date)
                        }
                    }
                    if let trackerId, !recordTracker.isEmpty {
                        trackerRecord.append(TrackerRecord(idTracker: trackerId, date: recordTracker))
                    }
                }
            }
        } catch {
            throw error
        }
        print(trackerRecord)
        return trackerRecord
    }
    
    func addNewTrackerRecord(trackerId: UUID, date: Date) {
        let fetchRequest: NSFetchRequest<TrackerCoreDate> = TrackerCoreDate.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", trackerId as NSUUID)
        do {
            let trackers = try context.fetch(fetchRequest)
            if let tracker = trackers.first {
                let trackerRecordCoreDate = TrackerRecordCoreDate(context: context)
                trackerRecordCoreDate.date = date
                
                trackerRecordCoreDate.tracker = tracker
                tracker.addToRecord(trackerRecordCoreDate)
                print(trackerRecordCoreDate)
                print(tracker)
                try context.save()
            }
        } catch {
            print("Error finding category: \(error)")
        }
    }
    
    func deleteTrackerRecord(trackerId: UUID, date: Date) {
        let fetchRequest: NSFetchRequest<TrackerRecordCoreDate> = TrackerRecordCoreDate.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "tracker.id == %@ AND date == %@", trackerId as NSUUID, date as NSDate)
        
        do {
            let records = try context.fetch(fetchRequest)
            if let record = records.first {
                context.delete(record)
                try context.save()
            }
        } catch {
            print("Ошибка поиска записи: \(error)")
        }
    }
}
