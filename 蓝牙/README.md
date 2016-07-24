# iOS中的蓝牙

### 概述

#### iOS中提供了4个框架用于实现蓝牙连接

- 1.GameKit.framework(用法简单)
    * `只能用于iOS设备之间的同个应用内连接`,多用于游戏(eg.拳皇,棋牌类),从`iOS7开始过期`

- 2.MultipeerConnectivity.framework(代替1)
    * `只能用于iOS设备之间的连接,从iOS7开始引入`,主要用于`非联网状态`下,通过wifi或者蓝牙进行文件共享(仅限于沙盒的文件),多用于附近无网聊天

- 3.ExternalAccessory.framework(MFi)
    * `可用于第三方蓝牙设备交互`,但是蓝牙设备必须经过`苹果MFi认证`(国内很少)

- 4.CoreBluetooth.framework（时下热门)
    * `可用于第三方蓝牙设备交互`,必须要支持蓝牙4.0
    * 硬件至少是4s,系统至少是iOS6
    * 蓝牙4.0以低功耗著称,一般也叫BLE（Bluetooth Low Energy）
    * 目前应用比较多的案例:运动手环,嵌入式设备,智能家居

#### 设计到的系统/框架

- HealthKit/物联网HomeKit/wathOS1,2/iBeacon
