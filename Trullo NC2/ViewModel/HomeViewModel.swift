//
//  HomeViewModel.swift
//  Trullo NC2
//
//  Created by Mikhael Adiputra on 28/07/22.
//

import Foundation

class HomeViewModel {
    
    private var baseProvider = BaseProvider()
    private var beginnerReminder = [ReminderModel]()
    private var intermediateReminder = [ReminderModel]()
    private var advancedReminder = [ReminderModel]()
    var identifier = "goToDetail"
    
    init() {
        self.baseProvider = { return BaseProvider()}()
    }

    func getAllReminders(_ reminderType : String, completion: @escaping () -> ()) {
        self.baseProvider.getAllReminder(reminderType) { [weak self] (result) in
            switch(result) {
                case.success(let reminderModel):
                    DispatchQueue.main.async {
                        if reminderType == "1" {
                            self?.beginnerReminder     = reminderModel
                            completion()
                        }else if reminderType == "2" {
                            self?.intermediateReminder = reminderModel
                            completion()
                        }else {
                            self?.advancedReminder     = reminderModel
                            completion()
                        }
                    }
            case .failure(let error):
                print("\(error.localizedDescription)")
            }
        }
    }
    
    func numberOfRowsInSection(reminderType : String) -> Int {
        if reminderType == "1" {
            if !beginnerReminder.isEmpty {
                return beginnerReminder.count
            }else {
                return 0
            }
        }else if reminderType == "2" {
            if !intermediateReminder.isEmpty {
                return intermediateReminder.count
            }else {
                return 0
            }
        }else {
            if !advancedReminder.isEmpty {
                return advancedReminder.count
            }else {
                return 0
            }
        }
    }

    func cellForRowAt(_ reminderType : String, indexPath: IndexPath) -> ReminderModel {
        if reminderType == "1" {
            return beginnerReminder[indexPath.row]
        }else if reminderType == "2" {
            return intermediateReminder[indexPath.row]
        }else {
            return advancedReminder[indexPath.row]
        }
    }
}
