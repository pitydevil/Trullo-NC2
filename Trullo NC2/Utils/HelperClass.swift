//
//  HelperClass.swift
//  Trullo NC2
//
//  Created by Mikhael Adiputra on 28/07/22.
//

import Foundation
import UIKit

public func createAlert(titleAlert : String, messageAlert : String, okayAction : String) -> UIAlertController{
    let alert = UIAlertController(title: titleAlert, message: messageAlert, preferredStyle: .alert)
    let cancel = UIAlertAction(title: okayAction, style: .cancel)
    alert.addAction(cancel)
    return alert
}
