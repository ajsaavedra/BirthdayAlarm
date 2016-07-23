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
    var alarmDate: NSDate!
    var notification: UILocalNotification!
    
    init(firstName: String, lastName: String, day: Int, month: Int, year: Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.birthDay = day
        self.birthMonth = month
        self.birthYear = year
        self.friendKey = NSUUID().UUIDString
        self.notification = UILocalNotification()
        super.init()
    }
    
    func setLocalNotification() {
        let notification = UILocalNotification()
        notification.fireDate = fixedNotificationDate(alarmDate)
        notification.alertBody = "\(firstName) \(lastName)'s birthday is coming up!"
        notification.alertAction = "see details"
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.repeatInterval = .Year
        self.notification = notification
        UIApplication.sharedApplication().scheduleLocalNotification(self.notification)
    }
    
    func deleteNotification() {
        UIApplication.sharedApplication().cancelLocalNotification(self.notification)
    }
    
    func setDateForAlarm(date: NSDate) {
        self.alarmDate = date
    }

    func editAlarmDate(date: NSDate) {
        deleteNotification()
        setDateForAlarm(date)
        setLocalNotification()
    }
    
    func fixedNotificationDate(dateToFix: NSDate) -> NSDate {
        let dateComponents: NSDateComponents = NSCalendar.currentCalendar().components([NSCalendarUnit.Day, NSCalendarUnit.Month, NSCalendarUnit.Year, NSCalendarUnit.Hour, NSCalendarUnit.Minute], fromDate: dateToFix)
        dateComponents.second = 0
        let fixedDate: NSDate = NSCalendar.currentCalendar().dateFromComponents(dateComponents)!
        return fixedDate
    }
}