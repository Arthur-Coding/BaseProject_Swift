//
//  ConstKit.swift
//  Swift
//
//  Created by ArthurShuai on 2019/3/8.
//  Copyright © 2019 ArthurShuai. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

// MARK: 项目配置

public var LS_AllowScreenRotation = false

/// 用户是否已登录
public var LS_IsLogin: Bool {
    set {
        UserDefaults.standard.set(newValue, forKey: "LS_IsLogin")
    }
    get {
        UserDefaults.standard.bool(forKey: "LS_IsLogin")
    }
}

/// 用户登录后token
public var LS_Token: String {
    set {
        UserDefaults.standard.set(newValue, forKey: "LS_Token")
    }
    get {
        UserDefaults.standard.string(forKey: "LS_Token") ?? ""
    }
}

/// 用户信息
public var LS_UserInfo: JSON? {
    set {
        UserDefaults.standard.set(newValue?.dictionaryObject, forKey: "L_UserInfo")
    }
    get {
        JSON.init(UserDefaults.standard.object(forKey: "LS_UserInfo") ?? nil!)
    }
}


// MARK: - 屏幕数据

public let SCREEN_WIDTH      = UIScreen.main.bounds.size.width // 屏幕宽度
public let SCREEN_HEIGHT     = UIScreen.main.bounds.size.height // 屏幕高度
public let SCALE_MULTIPLE    = SCREEN_WIDTH / 414.0 // 屏幕宽度比例 基于414.0
public let NAV_STATUS_HEIGHT = UIApplication.shared.statusBarFrame.height + 44.0 // 导航栏 + 状态栏 高度
public let TAB_BAR_HEIGHT   = SAFE_AREA_HEIGHT + 49 // 标签栏 高度
public let SAFE_AREA_HEIGHT = getSafeAreaInsetsBottom() // 安全区域高度
private func getSafeAreaInsetsBottom() -> CGFloat
{
    if #available(iOS 11.0, *) {
        return ((UIApplication.shared.delegate as? AppDelegate)?.window?.safeAreaInsets.bottom)!
    } else {
        return CGFloat(0)
    }
}

// MARK: - APP与手机数据

public let APP_VERSION            = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String // APP应用版本
public let IPHONE_SYSTEM_VERSION  = UIDevice.current.systemVersion // 手机系统版本
public let IPHONE_SYSTEM_LANGUAGE = NSLocale.preferredLanguages.first // 手机系统语言
public let IPHONE_UUID            = UIDevice.current.identifierForVendor?.uuidString // 手机UUID
/// 判断是否是iPhoneX以上刘海屏手机
public func IPHONE_IS_X_SERIES() -> Bool
{
    if UIDevice.current.userInterfaceIdiom != .phone {
        return false
    }
    if #available(iOS 11.0, *) {
        return SAFE_AREA_HEIGHT > CGFloat(0)
    }
    return false
}

