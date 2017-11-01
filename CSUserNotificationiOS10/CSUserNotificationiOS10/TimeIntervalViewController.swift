//
//  TimeIntervalViewController.swift
//  CSUserNotificationiOS10
//
//  Created by arduomeng on 16/9/28.
//  Copyright © 2016年 arduomeng. All rights reserved.
//

import UIKit
import UserNotifications

class TimeIntervalViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

    @IBAction func sendOnclick(_ sender: AnyObject) {
        // 1. 创建通知内容
        let content = UNMutableNotificationContent()
        content.title = String.localizedUserNotificationString(forKey: "Time Interval Notification", arguments: [])
        content.body = "My first notification"
        content.userInfo = ["name" : "arduomeng"]
        
        // 2. 创建发送触发
        /*
         在一定时间后触发 UNTimeIntervalNotificationTrigger，在某月某日某时触发 UNCalendarNotificationTrigger 以及在用户进入或是离开某个区域时触发 UNLocationNotificationTrigger
         */
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        // 3. 发送请求标识符
        let requestIdentifier = "com.onevcat.usernotification.myFirstNotification"
        
        // 4. 创建一个发送请求
        let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
        
        // 将请求添加到发送中心
        UNUserNotificationCenter.current().add(request) { error in
            if error == nil {
                print("Time Interval Notification scheduled: \(requestIdentifier)")
            }
        }
    }

}
