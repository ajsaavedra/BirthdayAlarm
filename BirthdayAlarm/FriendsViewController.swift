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
    var imageStore: ImageStore!

    func addNewRow(friend: Friend) {
        if let index = FriendCollection().allFriends.indexOf(friend) {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        navigationItem.leftBarButtonItem = editButtonItem()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 65
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()

        let backgroundImage = UIImage(named: "gift.png")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView

        tableView.tableFooterView = UIView(frame: CGRectZero)
        imageView.contentMode = .ScaleAspectFit
        tableView.backgroundColor = ColorModel().getRandomColor()
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
                self.imageStore.deleteImageForKey(alarm.friendKey)
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
        let detailViewController = segue.destinationViewController as! DetailViewController
        detailViewController.imageStore = imageStore
        if segue.identifier == "ShowAlarm" {
            if let row = tableView.indexPathForSelectedRow?.row {
                let alarm = friendCollection.allFriends[row]
                detailViewController.friend = alarm
                detailViewController.friendImage = imageStore.imageForKey(alarm.friendKey)
            }
        }
    }

    @IBAction func unwindToAlarmList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? DetailViewController,
            alarm = sourceViewController.friend {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                friendCollection.allFriends[selectedIndexPath.row] = alarm
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
            } else {
                let newIndexPath = NSIndexPath(forRow: friendCollection.allFriends.count, inSection: 0)
                friendCollection.allFriends.append(alarm)
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
            }
        }
    }
}
