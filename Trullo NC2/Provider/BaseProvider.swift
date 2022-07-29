//
//  BaseProvider.swift
//  Trullo NC2
//
//  Created by Mikhael Adiputra on 28/07/22.
//

import Foundation
import CoreData

enum AllFavoriteError: Error {
    case custom(errorMessage: String)
}

class BaseProvider {
    
    lazy var persistContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Trullo_NC2")
        
        container.loadPersistentStores{ _, error in
            guard error == nil else {
                fatalError("Unresolved error \(String(describing: error))")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = false
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.shouldDeleteInaccessibleFaults = true
        container.viewContext.undoManager = nil
        
        return container
    }()
    
    private func newTaskContext() -> NSManagedObjectContext {
        let taskContext = persistContainer.newBackgroundContext()
        taskContext.undoManager = nil
        
        taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        return taskContext
    }
    
    func getReminderID(_ title:String, completion: @escaping(Result<ReminderModel, AllFavoriteError>)-> Void) {
        let taskContext = newTaskContext()

        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Reminder")
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "title == %@", title)
            do {
                if let reminder = try taskContext.fetch(fetchRequest).first{
                    let reminderNewData = ReminderModel(title: reminder.value(forKey: "title") as? String, desc: reminder.value(forKey: "desc") as? String, dateCreated: reminder.value(forKey: "dateCreated") as? Date, reminderType: reminder.value(forKey: "reminderType") as? String)
                    print("test reminder ?")
                    print(reminderNewData.title ?? "")
                    completion(.success(reminderNewData))
                } else {
                    completion(.failure(.custom(errorMessage: "Data Doesnt Exist")))
                }
            } catch let error as NSError {
                completion(.failure(.custom(errorMessage: "error \(error.localizedDescription)")))
            }
        }
    }

    func deleteFavorite(_ title: String, completion: @escaping(Result<Bool, AllFavoriteError>)->Void) {
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Reminder")
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "title == %@", title)
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            batchDeleteRequest.resultType = .resultTypeCount
            if let batchDeleteResult = try? taskContext.execute(batchDeleteRequest) as? NSBatchDeleteResult {
                if batchDeleteResult.result != nil {
                    completion(.success(true))
                }else {
                    completion(.failure(.custom(errorMessage: "Failed to delete")))
                }
            }
        }
    }

    func getAllReminder(_ reminderType : String, completion: @escaping(Result<[ReminderModel], AllFavoriteError>)-> Void) {
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Reminder")
            fetchRequest.predicate = NSPredicate(format: "reminderType == \(reminderType)")
            do {
                let results = try taskContext.fetch(fetchRequest)

                var reminders: [ReminderModel] = []
                
                for reminder in results {

                    let reminderNewData = ReminderModel(title: reminder.value(forKey: "title") as? String, desc: reminder.value(forKey: "desc") as? String, dateCreated: reminder.value(forKey: "dateCreated") as? Date, reminderType: reminder.value(forKey: "reminderType") as? String)
                    
                    reminders.append(reminderNewData)
                }
                completion(.success(reminders))
            } catch let error as NSError {
                completion(.failure(.custom(errorMessage: "error: \(error.userInfo)")))
            }
        }
    }
    
    func addReminder(_ title:String, _ desc: String, _ dateCreated : Date, reminderType : String, completion: @escaping(_ result: Bool) -> Void) {
        
        let taskContext = newTaskContext()
        taskContext.perform {
//            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Reminder")
//            fetchRequest.fetchLimit = 1
//            fetchRequest.predicate = NSPredicate(format: "title == \(title)")
            do {
                if let entity = NSEntityDescription.entity(forEntityName: "Reminder", in: taskContext) {
                    let member = NSManagedObject(entity: entity, insertInto: taskContext)
                    member.setValue(desc, forKeyPath: "desc")
                    member.setValue(title, forKeyPath: "title")
                    member.setValue(dateCreated, forKeyPath: "dateCreated")
                    member.setValue(reminderType, forKey: "reminderType")
                    do {
                        try taskContext.save()
                        print("aman?")
                        completion(true)
                    } catch let error as NSError {
                        completion(false)
                        print("Could not save: \(error.userInfo)")
                    }
                }
            } catch let error as NSError {
                completion(false)
            }
        }
    }
}
