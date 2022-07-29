//
//  Reminder.swift
//  Trullo NC2
//
//  Created by Mikhael Adiputra on 28/07/22.
//

import Foundation

struct ReminderModel: Identifiable {
    var id: Int32?
    var title: String?
    var desc: String?
    var dateCreated: Date?
    var reminderType : String?
}
