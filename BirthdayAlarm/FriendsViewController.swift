//
//  FriendsViewController.swift
//  BirthdayAlarm
//
//  Created by Tony Saavedra on 7/6/16.
//  Copyright © 2016 Tony Saavedra. All rights reserved.
//

import UIKit

class FriendsViewController: UITableViewController {
    var friendCollection: FriendCollection!
    
    override func tableView(tableView: UITableView, numberOfRowsInSection: Int) -> Int {
        return friendCollection.allFriends.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Value1, reuseIdentifier: "UITableViewCell")
        
        let friend = friendCollection.allFriends[indexPath.row]
        
        cell.textLabel?.text = friend.firstName + " " + friend.lastName
        cell.detailTextLabel?.text = "\(friend.birthDay)/\(friend.birthMonth)/\(friend.birthYear)"
        return cell
    }
}
