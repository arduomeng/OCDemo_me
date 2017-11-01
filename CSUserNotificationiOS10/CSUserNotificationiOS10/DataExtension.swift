//
//  DataExtension.swift
//  CSUserNotificationiOS10
//
//  Created by user on 2017/9/21.
//  Copyright © 2017年 arduomeng. All rights reserved.
//

import Foundation

extension Data {
    var hexString: String {
        return withUnsafeBytes {(bytes: UnsafePointer<UInt8>) -> String in
            let buffer = UnsafeBufferPointer(start: bytes, count: count)
            return buffer.map {String(format: "%02hhx", $0)}.reduce("", { $0 + $1 })
        }
    }
}
