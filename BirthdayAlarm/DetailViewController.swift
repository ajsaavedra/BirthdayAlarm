//
//  DetailViewController.swift
//  BirthdayAlarm
//
//  Created by Tony Saavedra on 7/8/16.
//  Copyright © 2016 Tony Saavedra. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate,
        UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @IBOutlet var firstNameField: UITextField!
    @IBOutlet var lastNameField: UITextField!
    @IBOutlet var birthdayField: UITextField!
    @IBOutlet var alarmDateField: UITextField!
    @IBOutlet var imageView: UIImageView!
    var friendImage: UIImage!
    var alarmDate: NSDate!

    @IBAction func backgroundTapped(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }

    @IBAction func takePicture(sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()

        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            imagePicker.sourceType = .Camera
            imagePicker.allowsEditing = true
        } else {
            imagePicker.sourceType = .PhotoLibrary
        }
        imagePicker.delegate = self

        presentViewController(imagePicker, animated: true, completion: nil)
    }

    @IBAction func deletePicture(sender: UIBarButtonItem) {
        if friend != nil {
            imageStore.deleteImageForKey(friend.friendKey)
        }
        friendImage = nil
        imageView.image = nil
    }

    var friend: Friend! {
        didSet {
            navigationItem.title = friend.firstName
        }
    }

    var imageStore: ImageStore!

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        if let reminder = friend {
            firstNameField.text = reminder.firstName
            lastNameField.text = reminder.lastName
            birthdayField.text =  "\(reminder.birthMonth)/\(reminder.birthDay)/\(reminder.birthYear)"
            imageView.image = imageStore.imageForKey(reminder.friendKey)
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
            dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
            alarmDateField.text = dateFormatter.stringFromDate(reminder.alarmDate)
        } else {
            firstNameField.text = ""
            lastNameField.text = ""
            birthdayField.text =  ""
        }

        let saveButton : UIBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.Plain,
                                                           target: self, action: #selector(DetailViewController.saveFriendDetails))
        self.navigationItem.rightBarButtonItem = saveButton
    }

    @IBAction func editBirthday(sender: UITextField) {
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.Date
        sender.inputView = datePickerView

        datePickerView.addTarget(self, action: #selector(datePickerValueChanged),
                                 forControlEvents: UIControlEvents.ValueChanged)
    }
    
    @IBAction func editAlarmDate(sender: UITextField) {
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.DateAndTime
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(alarmDateValueChanged),
                                 forControlEvents: UIControlEvents.ValueChanged)
    }

    func datePickerValueChanged(sender: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle

        birthdayField.text = dateFormatter.stringFromDate(sender.date)
    }
    
    func alarmDateValueChanged(sender: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        alarmDateField.text = dateFormatter.stringFromDate(sender.date)
        alarmDate = sender.date
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        view.endEditing(true)
    }

    func saveFriendDetails() {
        let first = firstNameField.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) ?? ""
        let last = lastNameField.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) ?? ""
        let birthdayInfo = birthdayField.text ?? ""
        let date = alarmDate ?? NSDate()

        if !first.isEmpty && !birthdayInfo.isEmpty {
            if friend != nil {
                updateFriendInformation()
            } else {
                let birthday = birthdayInfo.componentsSeparatedByString("/")

                let month = Int(birthday[0]) ?? 1
                let day = Int(birthday[1]) ?? 1
                let year = Int(birthday[2]) ?? 1970

                friend = FriendCollection().addFriend(first, lName: last, d: day, m: month, y: year)
                if friendImage != nil {
                    imageStore.setImage(friendImage, forKey: friend.friendKey)
                }
                friend.setDateForAlarm(date)
            }
        }
        self.performSegueWithIdentifier("unwindToTable", sender: self)
    }
    
    func updateFriendInformation() {
        friend.firstName = firstNameField.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) ?? ""
        friend.lastName = lastNameField.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) ?? ""
        let birthdayInfo = birthdayField.text ?? ""
        let birthday = birthdayInfo.componentsSeparatedByString("/")

        friend.birthMonth = Int(birthday[0]) ?? 1
        friend.birthDay = Int(birthday[1]) ?? 1
        friend.birthYear = Int(birthday[2]) ?? 1970
        if friendImage != nil {
            imageStore.setImage(friendImage, forKey: friend.friendKey)
        }
        friend.editAlarmDate(alarmDate)
    }

    func textFieldShouldReturn(textfield: UITextField) -> Bool {
        textfield.resignFirstResponder()
        return true
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        friendImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        if friend != nil {
            imageStore.setImage(friendImage, forKey: friend.friendKey)
        }
        imageView.image = friendImage
        dismissViewControllerAnimated(true, completion: nil)
    }
}
