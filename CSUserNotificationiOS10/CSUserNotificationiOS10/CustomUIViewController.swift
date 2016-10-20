//
//  CustomUIViewController.swift
//  CSUserNotificationiOS10
//
//  Created by arduomeng on 16/9/28.
//  Copyright © 2016年 arduomeng. All rights reserved.
//

import UIKit
import UserNotifications

class CustomUIViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendOnclick(_ sender: AnyObject) {
        let content = UNMutableNotificationContent()
        content.title = "Custom Notification"
        content.body = "Show me some images!"
        content.userInfo = ["items": [["title": "Photo 1", "subtitle": "image1"], ["title": "Photo 2", "subtitle": "image2"]]]
        content.categoryIdentifier = NotificationCategoryType.customUI.rawValue
        
        //attachments 虽然是一个数组，但是系统只会展示第一个 attachment 对象的内容
        var attachArr = [UNNotificationAttachment]()
        if let imageURL = Bundle.main.url(forResource: "image", withExtension: "png"),
            let attachment = try? UNNotificationAttachment(identifier: "image", url: imageURL, options: nil)
        {
            attachArr.append(attachment)
        }
        if let imageURL = Bundle.main.url(forResource: "image2", withExtension: "png"),
            let attachment = try? UNNotificationAttachment(identifier: "image2", url: imageURL, options: nil)
        {
            attachArr.append(attachment)
        }
        content.attachments = attachArr
        
        // Create a trigger to decide when/where to present the notification
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        let requestIdentifier = "CustomNotification"
        
        // The request describes this notification.
        let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                UIAlertController.showConfirmAlert(message: error.localizedDescription, in: self)
            } else {
                print("Media Notification scheduled: \(requestIdentifier)")
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
