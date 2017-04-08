//
//  AppDelegate.swift
//  CSUserNotificationiOS10
//
//  Created by arduomeng on 16/9/27.
//  Copyright © 2016年 arduomeng. All rights reserved.
//

import UIKit
import UserNotifications

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
        print("Device Token \(deviceToken.description)")
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
            options: [.foreground])
        
        // 3
        let cancelAction = UNNotificationAction(
            identifier: NotificationActionType.Cancel.rawValue,
            title: "Cancel",
            options: [.destructive])
        
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

