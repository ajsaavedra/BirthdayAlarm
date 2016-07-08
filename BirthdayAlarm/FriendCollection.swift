//
//  FriendCollection.swift
//  BirthdayAlarm
//
//  Created by Tony Saavedra on 7/6/16.
//  Copyright © 2016 Tony Saavedra. All rights reserved.
//

import UIKit

class FriendCollection {
    var allFriends = [Friend]()
    
    func addFriend() -> Friend {
        let newFriend = Friend(random: true)
        allFriends.append(newFriend)
        return newFriend
    }

    func removeReminder(friend: Friend) {
        if let index = allFriends.indexOf(friend) {
            allFriends.removeAtIndex(index)
        }
    }
}