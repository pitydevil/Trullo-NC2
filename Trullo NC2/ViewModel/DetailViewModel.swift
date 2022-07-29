//
//  DetailViewModel.swift
//  Trullo NC2
//
//  Created by Mikhael Adiputra on 28/07/22.
//

import Foundation

enum typeError {
  case salahInputType, gagalAddData, success
}

class DetailViewModel {
    
    private var baseProvider = BaseProvider()
    private var reminderTypeArray = ["Beginner", "Intermediate", "Advanced"]
    var reminderObject : ReminderModel?
    var reminderType   : String?
    
    init() {
        self.baseProvider = { return BaseProvider()}()
    }
    
    func getReminderID(_ title : String, completion: @escaping () -> ()) {
        self.baseProvider.getReminderID(title) { [weak self] (result) in
            switch (result) {
            case .success(let reminderModel):
                DispatchQueue.main.async {
                    print("reminder model")
                    self?.reminderObject = reminderModel
                    switch (self?.reminderObject?.reminderType) {
                    case "1":
                        self?.reminderType = "Beginner"
                    case "2":
                        self?.reminderType = "Intermediate"
                    case "3":
                        self?.reminderType = "Advanced"
                    default:
                        self?.reminderType = "Nil"
                    }
                    completion()
                }
            case .failure(let error):
                print("error \(error.localizedDescription)")
            }
        }
    }
    
    func deleteReminder(_ title: String, completion: @escaping(_ result: Bool)-> Void ) {
        baseProvider.deleteFavorite(title) { result in
            switch (result) {
            case .success(let success):
                completion(success)
            case .failure(let error):
                completion(false)
                print("error deleting \(error.localizedDescription)")
            }
        }
    }

    func addReminder(_ title:String, _ desc: String, _ dateCreated : Date, reminderType : String, completion: @escaping(_ result: typeError)-> Void ) {
        if title.count != 0 && desc.count != 0 && reminderType.count != 0{
            var remType : String?
            if reminderType == "Beginner" {
                remType = "1"
            }else if reminderType == "Intermediate" {
                remType = "2"
            }else {
                remType = "3"
            }
            baseProvider.addReminder(title, desc, dateCreated, reminderType: remType!) { result in
                if result {
                    completion(.success)
                }else {
                    completion(.gagalAddData)
                }
            }
        }else {
            completion(.salahInputType)
        }
    }
    func numberOfRowInComponent() -> Int {
        if !reminderTypeArray.isEmpty {
            return reminderTypeArray.count
        }else {
            return 0
        }
    }
    func didSelectPicker(indexpath : Int) -> String {
        return reminderTypeArray[indexpath]
    }
}
