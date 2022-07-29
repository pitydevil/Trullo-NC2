//
//  Extension.swift
//  Trullo NC2
//
//  Created by Mikhael Adiputra on 28/07/22.
//

import UIKit

fileprivate var baseView: UIView?

extension UIViewController {
    
    func showSpinner() {
        baseView = UIView(frame: self.view.bounds)
        baseView?.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        
        let ai = UIActivityIndicatorView(style: .large)
        ai.center = baseView!.center
        ai.startAnimating()
        baseView?.addSubview(ai)
        self.view.addSubview(baseView!)
    }
    
    func removeSpinner() {
        baseView?.removeFromSuperview()
        baseView = nil
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIView {
    func setCustomRadius(_ radius : CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.shadowOpacity = 0.20
        self.layer.shadowRadius  = 4.0
        self.layer.shadowColor   = UIColor(red:0/255.0, green:0/255.0, blue:0/255.0, alpha: 1.0).cgColor
        self.layer.shadowOffset  = CGSize(width: 0.0, height: 2)
        self.layer.backgroundColor = UIColor(red:255.0/255.0, green:255.0/255.0, blue:255.0/255.0, alpha: 1.0).cgColor
        self.layer.masksToBounds = false
    }
}
