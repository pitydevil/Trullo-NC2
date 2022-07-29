//
//  HomeViewController.swift
//  Trullo NC2
//
//  Created by Mikhael Adiputra on 28/07/22.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var quoteTextView: UITextView!
    
    @IBOutlet weak var advancedTableView: UITableView!
    @IBOutlet weak var intermediateTableView: UITableView!
    @IBOutlet weak var beginnerTableView: UITableView!
    @IBOutlet weak var homeScrollView: UIScrollView!
    
    @IBOutlet weak var advancedView: UIView!
    @IBOutlet weak var intermediateView: UIView!
    @IBOutlet weak var beginnerView: UIView!
    @IBOutlet weak var quoteView: UIView!
    @IBOutlet weak var accountButton: UIBarButtonItem!
    
    private let homeViewModel      = HomeViewModel()
    private let mainRefreshControl = UIRefreshControl()
    
    override func viewWillAppear(_ animated: Bool) {
        updateUserInterface()
    }
    
    override func viewWillLayoutSubviews() {
        advancedView.setCustomRadius(9)
        intermediateView.setCustomRadius(9)
        beginnerView.setCustomRadius(9)
        quoteView.setCustomRadius(9)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeScrollView.refreshControl = mainRefreshControl
        mainRefreshControl.addTarget(self, action: #selector(fetchQuote(refreshControl:)), for: .valueChanged)
    }
    
    @objc private func fetchQuote(refreshControl: UIRefreshControl)  {
        mainRefreshControl.endRefreshing()
    }

    @IBAction func accountButtonPressed(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        self.segueToDetailWithParams("")
    }
    
    private func updateUserInterface() {
        self.showSpinner()
        self.homeViewModel.getAllReminders("1") {
            self.beginnerTableView.dataSource = self
            self.beginnerTableView.delegate = self
            self.beginnerTableView.register(UINib(nibName: "ReminderTableViewCell", bundle: nil), forCellReuseIdentifier: "reminderCell")
            self.beginnerTableView.reloadData()
        }
        self.homeViewModel.getAllReminders("2") {
            self.intermediateTableView.dataSource = self
            self.intermediateTableView.delegate = self
            self.intermediateTableView.register(UINib(nibName: "ReminderTableViewCell", bundle: nil), forCellReuseIdentifier: "reminderCell")
            self.intermediateTableView.reloadData()
        }
        self.homeViewModel.getAllReminders("3") {
            self.advancedTableView.dataSource = self
            self.advancedTableView.delegate = self
            self.advancedTableView.register(UINib(nibName: "ReminderTableViewCell", bundle: nil), forCellReuseIdentifier: "reminderCell")
            self.advancedTableView.reloadData()
            self.removeSpinner()
        }
    }
    private func segueToDetailWithParams(_ title : String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Detail") as! DetailViewController
        vc.titleString = title
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reminderCell", for: indexPath) as! ReminderTableViewCell
        
        var reminder : ReminderModel?
        
        if tableView == beginnerTableView {
            reminder = self.homeViewModel.cellForRowAt("1", indexPath: indexPath)
        }else if tableView == intermediateView {
            reminder = self.homeViewModel.cellForRowAt("2", indexPath: indexPath)
        }else {
            reminder = self.homeViewModel.cellForRowAt("3", indexPath: indexPath)
        }
        cell.setupReminderCell(reminder!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var reminderType : String?
        if tableView == beginnerTableView {
            reminderType = "1"
        }else if tableView == intermediateView {
            reminderType = "2"
        }else {
            reminderType = "3"
        }
        let object = self.homeViewModel.cellForRowAt(reminderType!, indexPath: indexPath)
        self.segueToDetailWithParams(object.title!)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == beginnerTableView {
            return self.homeViewModel.numberOfRowsInSection(reminderType: "1")
        }else if tableView == intermediateView {
            return self.homeViewModel.numberOfRowsInSection(reminderType: "2")
        }else {
            return self.homeViewModel.numberOfRowsInSection(reminderType: "3")
        }
    }
}
