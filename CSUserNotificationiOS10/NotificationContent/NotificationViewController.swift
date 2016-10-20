//
//  NotificationViewController.swift
//  NotificationContent
//
//  Created by arduomeng on 16/9/29.
//  Copyright © 2016年 arduomeng. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

struct NotificationPresentItem {
    let url: URL
    let title: String
    let subTitle: String
}


class NotificationViewController: UIViewController, UNNotificationContentExtension {

    private var index : Int = 0
    private var itemArr = [NotificationPresentItem]()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var headTitle: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let size = view.bounds.size
        preferredContentSize = CGSize(width: size.width, height: size.width / 2)
    }
    
    func didReceive(_ notification: UNNotification) {
        
        if let userInfo = notification.request.content.userInfo["items"] as? [[String : String]]{
            for i in 0..<userInfo.count {
                let info = userInfo[i]
                guard let title = info["title"], let subTitle = info["subtitle"] else {
                    continue
                }
                
                let item = NotificationPresentItem(url: notification.request.content.attachments[i].url, title: title, subTitle: subTitle)
                itemArr.append(item)
                
            }
        }
    
        
        
        
        updateUI()
    }
    
    
    
    // 可选方法 当点击NotificationContent的Action后会调用此方法
    func didReceive(_ response: UNNotificationResponse, completionHandler completion: @escaping (UNNotificationContentExtensionResponseOption) -> Void) {
        
        /*
            doNotDismiss 通知不消失
            dismissAndForwardAction 通知消失并且把通知的 action 继续传递给应用的 UNUserNotificationCenterDelegate 中的 userNotificationCenter(:didReceive:withCompletionHandler)
            dismiss 直接解散这个通知。
         */
        
        if response.actionIdentifier == "switch" {
            updateUI()
            completion(.doNotDismiss)
        } else if response.actionIdentifier == "open" {
            completion(.dismissAndForwardAction)
        } else if response.actionIdentifier == "dismiss" {
            completion(.dismiss)
        } else {
            completion(.dismissAndForwardAction)
        }
    }
    
    func updateUI(){
        if index == 1{
            index = 0
        }else {
            index = 1
        }
        
        if (itemArr.count) > 0 {
            let item = itemArr[index]
            //暂时获取Attachment权限
            if item.url.startAccessingSecurityScopedResource() {
                imageView.image = UIImage(contentsOfFile: item.url.path)
                item.url.stopAccessingSecurityScopedResource()
            }
            
            headTitle.text = item.title
            subTitle.text = item.subTitle
        }
        
        
    }

}
