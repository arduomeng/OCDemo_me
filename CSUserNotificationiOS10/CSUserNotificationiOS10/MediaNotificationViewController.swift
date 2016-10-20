//
//  MediaNotificationViewController.swift
//  CSUserNotificationiOS10
//
//  Created by arduomeng on 16/9/28.
//  Copyright © 2016年 arduomeng. All rights reserved.
//

import UIKit
import UserNotifications

class MediaNotificationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func sendOnclick(_ sender: AnyObject) {
        // Create notification content
        
        let content = UNMutableNotificationContent()
        content.title = "Image Notification"
        content.body = "Show me an image!"
    
        if let imageURL = Bundle.main.url(forResource: "image", withExtension: "png"){
            if let attachment = try? UNNotificationAttachment(identifier: "imageIdentifier", url: imageURL, options: nil){
                content.attachments = [attachment]
            }
        }
        
        // Create a trigger to decide when/where to present the notification
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        let requestIdentifier = "mediaNotification"
        
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
    


}
