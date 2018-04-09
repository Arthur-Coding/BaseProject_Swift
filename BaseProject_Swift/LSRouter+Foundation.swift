//
//  LSRouter+Foundation.swift
//  BaseProject_Swift
//
//  Created by ArthurShuai on 2018/2/26.
//  Copyright © 2018年 ArthurShuai. All rights reserved.
//
//  文档名称：基础配置
//  功能描述：基础配置

import Foundation
import UIKit

/// 应用Apple ID
public let AppleID = ""

/// 是否使用模拟数据
public let USE_SIMULATE = false

/// 获取plist文件模拟数据
/// 根目录为数组
/// - Parameter plistName: plist文件名
/// - Returns: 数组数据
public func get_simulate_array(plistName:String) -> [Any]
{
    return NSArray.init(contentsOfFile: Bundle.main.path(forResource: plistName, ofType: "plist")!) as! [Any]
}
/// 获取plist文件模拟数据
/// 根目录为字典
/// - Parameter plistName: plist文件名
/// - Returns: 字典数据
public func get_simulate_dictionary(plistName:String) -> [String:Any]
{
    return NSDictionary.init(contentsOfFile: Bundle.main.path(forResource: plistName, ofType: "plist")!) as! [String:Any]
}

/// 屏幕宽度
public let SCREEN_WIDTH = UIScreen.main.bounds.size.width

/// 屏幕高度
public let SCREEN_HEIGHT = UIScreen.main.bounds.size.height

/// 当前APP应用版本
public let APP_VERSION = Bundle.main.infoDictionary!["CFBundleShortVersionString"]

/// 当前手机系统版本
public let IPHONE_SYSTEM_VERSION = UIDevice.current.systemVersion

/// 当前手机系统语言
public let IPHONE_SYSTEM_LANGUAGE = NSLocale.preferredLanguages.first
