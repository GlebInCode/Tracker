//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Глеб Хамин on 25.08.2024.
//

import Foundation
import CoreData

final class TrackerRecordStore {
    private let context = Store.shared.context
    
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
    
    func deleteTrackerRecord(_ trackerId: UUID) {
        let fetchRequest: NSFetchRequest<TrackerRecordCoreDate> = TrackerRecordCoreDate.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "tracker.id == %@", trackerId as NSUUID)
        
        do {
            let records = try context.fetch(fetchRequest)
            for record in records {
                    context.delete(record)
                    try context.save()
            }
        } catch {
            print("Ошибка поиска записи: \(error)")
        }
    }
    
    func fetchedResultsController() -> NSFetchedResultsController<TrackerRecordCoreDate> {
        let fetchRequest: NSFetchRequest<TrackerRecordCoreDate> = TrackerRecordCoreDate.fetchRequest()
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: context,
                                                    sectionNameKeyPath: nil,
                                                    cacheName: nil)
        return controller
    }
}
