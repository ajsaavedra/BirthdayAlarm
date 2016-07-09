//
//  DetailViewController.swift
//  BirthdayAlarm
//
//  Created by Tony Saavedra on 7/8/16.
//  Copyright © 2016 Tony Saavedra. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet var firstNameField: UITextField!
    @IBOutlet var lastNameField: UITextField!
    @IBOutlet var birthdayField: UITextField!
    
    var friend: Friend!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        firstNameField.text = friend.firstName
        lastNameField.text = friend.lastName
        birthdayField.text =  "\(friend.birthDay)/\(friend.birthMonth)/\(friend.birthYear)"
    }
}
