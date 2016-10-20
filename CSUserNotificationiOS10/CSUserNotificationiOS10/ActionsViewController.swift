//
//  ActionsViewController.swift
//  CSUserNotificationiOS10
//
//  Created by arduomeng on 16/9/28.
//  Copyright © 2016年 arduomeng. All rights reserved.
//

import UIKit
import UserNotifications

class ActionsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendOnclick(_ sender: AnyObject) {
        
        // 1. 创建通知内容
        let content = UNMutableNotificationContent()
        content.title = "Action Notification"
        content.body = "My Action notification"
        content.userInfo = ["name" : "arduomeng"]
        content.categoryIdentifier = NotificationCategoryType.simpleCategory.rawValue
        
        // 2. 创建发送触发
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        
        // 3. 发送请求标识符
        let requestIdentifier = NotificationCategoryType.simpleCategory.rawValue
        
        // 4. 创建一个发送请求
        let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
        
        // 将请求添加到发送中心
        UNUserNotificationCenter.current().add(request) { error in
            if error == nil {
                print("Time Interval Notification scheduled: \(requestIdentifier)")
            }
        }
        
    }
    

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
