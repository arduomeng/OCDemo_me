//
//  NotificationHandler.swift
//  CSUserNotificationiOS10
//
//  Created by arduomeng on 16/9/28.
//  Copyright © 2016年 arduomeng. All rights reserved.
//

import UIKit
import UserNotifications

enum NotificationCategoryType : String {
    case simpleCategory
    case customUI
}

enum NotificationActionType : String {
    case Input
    case Goodbye
    case Cancel
}

enum NotificationCustomActionType : String {
    case `switch`
    case open
    case dismiss
}

class NotificationHandler: NSObject,UNUserNotificationCenterDelegate{

    
    // 通知点击后或者点击或者触发了某个 action调用
    // 推送请求对应的 response，UNNotificationResponse 是一个几乎包括了通知的所有信息的对象
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if let categoryType = NotificationCategoryType(rawValue:response.notification.request.content.categoryIdentifier){
            switch categoryType {
            case .simpleCategory:
                handleSimple(response: response)
            case .customUI:
                handleCustom(response: response)
            }
        }else{
            let text : String? = response.notification.request.content.userInfo["name"] as? String
            UIAlertController.showConfirmAlertFromTopViewController(message: "You just said \(text)")
        }
        completionHandler()
    }
    
    // 应用内显示通知 如果不想显示某个通知，可以直接用空 options 调用 completionHandler:
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let option : UNNotificationPresentationOptions = [.alert, .sound]
        completionHandler(option)
    }
    
    
    private func handleSimple(response: UNNotificationResponse) {
        let text: String
        
        if let actionType = NotificationActionType(rawValue: response.actionIdentifier) {
            switch actionType {
            case .Input: text = (response as! UNTextInputNotificationResponse).userText
            case .Goodbye: text = "Goodbye"
            case .Cancel: text = ""
            }
        } else {
            // Only tap or clear. (You will not receive this callback when user clear your notification unless you set .customDismissAction as the option of category)
            text = ""
        }
        
        if !text.isEmpty {
            UIAlertController.showConfirmAlertFromTopViewController(message: "You just said \(text)")
        }
    }
    
    private func handleCustom(response: UNNotificationResponse){
        print(response.notification.request.content.title)
    }
}
