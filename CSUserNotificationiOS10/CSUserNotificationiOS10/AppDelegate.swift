//
//  AppDelegate.swift
//  CSUserNotificationiOS10
//
//  Created by arduomeng on 16/9/27.
//  Copyright © 2016年 arduomeng. All rights reserved.
//

import UIKit
import UserNotifications

/*
 如果要进行本地化对应，在设置这些内容文本时，本地可以使用 String.localizedUserNotificationString(forKey: "your_key", arguments: []) 的方式来从 Localizable.strings 文件中取出本地化字符串，而远程推送的话，也可以在 payload 的 alert 中使用 loc-key 或者 title-loc-key 来进行指定。关于 payload 中的 key，可以参考这篇文档https://developer.apple.com/library/content/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/PayloadKeyReference.html。
 */
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let notificationHandler = NotificationHandler()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // 注册NotificationCategory 用于NotificationAction和自定义通知UI
        registerNotificationCategory()
        UNUserNotificationCenter.current().delegate = notificationHandler
        
        return true
    }

   
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("Device Token \(deviceToken.hexString)")
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("RegisterForRemoteNotification error \(error)")
    }

    private func registerNotificationCategory() {
        
        // simpleCategory
        // 1
        let inputAction = UNTextInputNotificationAction(
            identifier: NotificationActionType.Input.rawValue,
            title: "Input",
            options: [.foreground],
            textInputButtonTitle: "Send",
            textInputPlaceholder: "What do you want to say..."
        )
        
        // 2
        let goodbyeAction = UNNotificationAction(
            identifier: NotificationActionType.Goodbye.rawValue,
            title: "Goodbye",
            options: [.foreground]) // foreground 启动应用
        
        // 3
        let cancelAction = UNNotificationAction(
            identifier: NotificationActionType.Cancel.rawValue,
            title: "Cancel",
            options: [.destructive]) // destructive 红色提醒
        
        UNUserNotificationCenter.current().setNotificationCategories([UNNotificationCategory(identifier: NotificationCategoryType.simpleCategory.rawValue, actions: [inputAction, goodbyeAction, cancelAction], intentIdentifiers: [], options: [.customDismissAction])])
        
        // CustomUI
        // 1
        let switchAction = UNNotificationAction(
            identifier: NotificationCustomActionType.switch.rawValue,
            title: "switch",
            options: [.destructive])
        
        // 2
        let openAction = UNNotificationAction(
            identifier: NotificationCustomActionType.open.rawValue,
            title: "Goodbye",
            options: [.foreground])
        
        // 3
        let dismissAction = UNNotificationAction(
            identifier: NotificationCustomActionType.dismiss.rawValue,
            title: "Cancel",
            options: [.destructive])
        
        UNUserNotificationCenter.current().setNotificationCategories([UNNotificationCategory(identifier: NotificationCategoryType.customUI.rawValue, actions: [switchAction, openAction, dismissAction], intentIdentifiers: [], options: [.customDismissAction])])
    }
    
}

