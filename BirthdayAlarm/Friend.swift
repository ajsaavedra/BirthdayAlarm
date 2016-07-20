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
    
    convenience init(random: Bool = false) {
        if random {
            let fnames = ["Tony", "Maggie", "Jason", "Rowdy", "Dig", "Turanga"]
            let lnames = ["Saavedra", "Gallagher", "Dog", "Dug", "Leela"]
            
            var idx = arc4random_uniform(UInt32(fnames.count))
            let randomFirstName = fnames[Int(idx)]
            
            idx = arc4random_uniform(UInt32(lnames.count))
            let randomLastName = lnames[Int(idx)]
            
            let randomDay = arc4random_uniform(30) + 1
            let randomMonth = arc4random_uniform(12) + 1
            let randomYear = arc4random_uniform(46) + 1970
            
            self.init(firstName: randomFirstName, lastName: randomLastName,
                      day: Int(randomDay), month: Int(randomMonth), year: Int(randomYear))
        } else {
            self.init(firstName: "", lastName: "", day: 0, month: 0, year: 0)
        }
    }
}