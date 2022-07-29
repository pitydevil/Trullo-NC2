//
//  ReminderTableViewCell.swift
//  Trullo NC2
//
//  Created by Mikhael Adiputra on 28/07/22.
//

import UIKit

class ReminderTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var descLabel : UILabel!
    @IBOutlet weak var imageStatus : UIImageView!
    
    func setupReminderCell(_ reminderModel : ReminderModel) {
        self.titleLabel.text  = reminderModel.title
        self.descLabel.text   = reminderModel.desc
    }
}
