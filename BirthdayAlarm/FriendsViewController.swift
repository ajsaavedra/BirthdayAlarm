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

    @IBAction func addNewReminder(sender: AnyObject) {
        let newReminder = friendCollection.addFriend()

        if let index = friendCollection.allFriends.indexOf(newReminder) {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }

    @IBAction func toggleEditingMode(sender: AnyObject) {
        if editing {
            sender.setTitle("Edit", forState: .Normal)
            setEditing(false, animated: true)
        } else {
            sender.setTitle("Done", forState: .Normal)
            setEditing(true, animated: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
        let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()

        let backgroundImage = UIImage(named: "gift.png")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView

        tableView.tableFooterView = UIView(frame: CGRectZero)
        imageView.contentMode = .ScaleAspectFit
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection: Int) -> Int {
        return friendCollection.allFriends.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell", forIndexPath: indexPath)

        let friend = friendCollection.allFriends[indexPath.row]

        cell.textLabel?.text = friend.firstName + " " + friend.lastName
        cell.detailTextLabel?.text = "\(friend.birthMonth)/\(friend.birthDay)/\(friend.birthYear)"
        return cell
    }

    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor(white: 1, alpha: 0.5)
        cell.textLabel?.backgroundColor = UIColor.clearColor()
        cell.detailTextLabel?.backgroundColor = UIColor.clearColor()
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let alarm = friendCollection.allFriends[indexPath.row]

            let title = "Delete \(alarm.firstName) \(alarm.lastName)?"
            let message = "Are you sure you want to delete this birthday alarm?"
            let ac = UIAlertController(title: title, message: message, preferredStyle: .ActionSheet)

            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            ac.addAction(cancelAction)

            let deleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: {(action) -> Void in
                self.friendCollection.removeReminder(alarm)
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            })

            ac.addAction(deleteAction)

            presentViewController(ac, animated: true, completion: nil)
        }
    }

    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        friendCollection.moveReminderAtIndex(sourceIndexPath.row, toIndex: destinationIndexPath.row)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowAlarm" {
            if let row = tableView.indexPathForSelectedRow?.row {
                let alarm = friendCollection.allFriends[row]
                let detailViewController = segue.destinationViewController as! DetailViewController
                detailViewController.friend = alarm
            }
        }
    }
}
