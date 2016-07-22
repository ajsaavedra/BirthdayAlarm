//
//  Friend.swift
//  BirthdayAlarm
//
//  Created by Tony Saavedra on 7/6/16.
//  Copyright © 2016 Tony Saavedra. All rights reserved.
//

import UIKit

class Friend: NSObject {
    var firstName: String
    var lastName: String
    var birthDay: Int
    var birthMonth: Int
    var birthYear: Int
    let friendKey: String
    
    init(firstName: String, lastName: String, day: Int, month: Int, year: Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.birthDay = day
        self.birthMonth = month
        self.birthYear = year
        self.friendKey = NSUUID().UUIDString

        super.init()
    }    
}