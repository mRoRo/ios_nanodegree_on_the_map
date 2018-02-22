//
//  TableController.swift
//  OnTheMap
//
//  Created by Maro on 21/2/18.
//  Copyright © 2018 Maro. All rights reserved.
//

import UIKit

// MARK: - TableController: UIViewController

class TableController: UIViewController, RefreshData {
    
    // MARK: Properties
    var studentsLocations: [StudentLocation] = [StudentLocation]()
    private let refreshControl = UIRefreshControl()
    @IBOutlet var tableView: UITableView!
    
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addPullRefresh(tableView: tableView, refreshControl: refreshControl)
        studentsLocations = StudentModel.sharedInstance.studentsLocations
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: RefreshData
    func refresh() {
        studentsLocations = StudentModel.sharedInstance.studentsLocations
        performUIUpdatesOnMain {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    // MARK: UI
    @objc func fetchTableData(_ sender: Any) {
        StudentModel.sharedInstance.updateStudentsLocations(controller:self)
    }
}
