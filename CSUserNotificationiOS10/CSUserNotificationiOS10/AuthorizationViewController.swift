//
//  AuthorizationViewController.swift
//  CSUserNotificationiOS10
//
//  Created by arduomeng on 16/9/27.
//  Copyright © 2016年 arduomeng. All rights reserved.
//

import UIKit
import UserNotifications

class AuthorizationViewController: UIViewController {

    @IBOutlet weak var deviceToken: UILabel!
    @IBOutlet weak var notificationCenter: UILabel!
    @IBOutlet weak var sound: UILabel!
    @IBOutlet weak var badge: UILabel!
    @IBOutlet weak var lockScreen: UILabel!
    @IBOutlet weak var alert: UILabel!
    @IBOutlet weak var alertStyle: UILabel!
    
    var settingStatus : UNNotificationSettings? {
        didSet{
            updateUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getSettingStatus()
    }
    
    @IBAction func RequestOnclick(_ sender: AnyObject) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if granted {
                UIApplication.shared.registerForRemoteNotifications()
                self.getSettingStatus()
            }else{
                if let error = error {
                    UIAlertController.showConfirmAlert(message: error.localizedDescription, in: self)
                }
            }
        }
    }
    
    private func updateUI(){
        notificationCenter.text = settingStatus?.notificationCenterSetting.description
        sound.text = settingStatus?.soundSetting.description
        badge.text = settingStatus?.badgeSetting.description
        alert.text = settingStatus?.alertSetting.description
        lockScreen.text = settingStatus?.lockScreenSetting.description
        alertStyle.text = settingStatus?.alertStyle.description
        
    }

    private func getSettingStatus(){
        UNUserNotificationCenter.current().getNotificationSettings { (setting) in
            self.settingStatus = setting
            self .updateUI()
        }
    }
}

// CustomStringConvertible 协议作用 自定义对象的打印输出 类似description
extension UNNotificationSetting : CustomStringConvertible{
    public var description : String {
        switch self {
        case .notSupported:
            return "notSupported"
        case .disabled:
            return "disabled"
        case .enabled:
            return "enabled"
        }
    }
}

extension UNAlertStyle : CustomStringConvertible{
    public var description : String{
        switch self {
        case .none:
            return "none"
        case .banner:
            return "banner"
        case .alert:
            return "alert"
        }
    }
}
