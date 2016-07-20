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
    @IBOutlet var imageView: UIImageView!

    @IBAction func backgroundTapped(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }

    @IBAction func takePicture(sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()

        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            imagePicker.sourceType = .Camera
        } else {
            imagePicker.sourceType = .PhotoLibrary
        }
        imagePicker.delegate = self

        presentViewController(imagePicker, animated: true, completion: nil)
    }

    @IBAction func deletePicture(sender: UIBarButtonItem) {
        imageStore.deleteImageForKey(friend.friendKey)
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

        firstNameField.text = friend.firstName
        lastNameField.text = friend.lastName
        birthdayField.text =  "\(friend.birthMonth)/\(friend.birthDay)/\(friend.birthYear)"

        imageView.image = imageStore.imageForKey(friend.friendKey)
    }

    @IBAction func editBirthday(sender: UITextField) {
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.Date
        sender.inputView = datePickerView

        datePickerView.addTarget(self, action: #selector(datePickerValueChanged),
                                 forControlEvents: UIControlEvents.ValueChanged)
    }

    func datePickerValueChanged(sender: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle

        birthdayField.text = dateFormatter.stringFromDate(sender.date)
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        view.endEditing(true)
        updateFriendInformation()
    }

    func updateFriendInformation() {
        friend.firstName = firstNameField.text ?? ""
        friend.lastName = lastNameField.text ?? ""
        let birthdayInfo = birthdayField.text ?? ""

        let birthday = birthdayInfo.componentsSeparatedByString("/")

        friend.birthMonth = Int(birthday[0]) ?? 1
        friend.birthDay = Int(birthday[1]) ?? 1
        friend.birthYear = Int(birthday[2]) ?? 1970
    }

    func textFieldShouldReturn(textfield: UITextField) -> Bool {
        textfield.resignFirstResponder()
        return true
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageStore.setImage(image, forKey: friend.friendKey)
        imageView.image = image
        dismissViewControllerAnimated(true, completion: nil)
    }
}
