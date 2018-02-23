//
//  TableController+TableDelegate.swift
//  OnTheMap
//
//  Created by Maro on 22/2/18.
//  Copyright © 2018 Maro. All rights reserved.
//


import UIKit

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
        cell?.textLabel!.text = firstName + " " + lastName
        cell?.detailTextLabel?.text = mediaUrl
        cell?.imageView!.image = UIImage(named: "Pin")
        cell?.imageView!.contentMode = UIViewContentMode.scaleAspectFit
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentsLocations.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = studentsLocations[(indexPath as NSIndexPath).row]
        openUrlInSafari(urlString: location.mediaUrl, viewController: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
