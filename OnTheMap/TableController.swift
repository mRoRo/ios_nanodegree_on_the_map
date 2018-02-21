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
    @IBOutlet var tableView: UITableView!
    
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
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
        }
    }
}

// MARK: - TableController: UITableViewDelegate, UITableViewDataSource
extension TableController: UITableViewDelegate, UITableViewDataSource {

    static let NoFirstNameString = "[No First Name]"
    static let NoLastNameString = "[No Last Name]"
    static let NoMediaUrlString = "[No Media URL]"
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        /* Get cell type */
        let cellReuseIdentifier = "StudentTableViewCell"
        let location = studentsLocations[(indexPath as NSIndexPath).row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        
        /* Set cell defaults */
        let firstName = location.firstName ?? TableController.NoFirstNameString
        let lastName = location.lastName ?? TableController.NoLastNameString
        let mediaUrl = location.mediaUrl ?? TableController.NoMediaUrlString
        cell?.textLabel!.text = firstName + lastName
        cell?.detailTextLabel?.text = mediaUrl
        cell?.imageView!.image = UIImage(named: "Pin")
        cell?.imageView!.contentMode = UIViewContentMode.scaleAspectFit
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentsLocations.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let controller = storyboard!.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
//        controller.movie = movies[(indexPath as NSIndexPath).row]
//        navigationController!.pushViewController(controller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

