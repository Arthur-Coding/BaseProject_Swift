//
//  LSRouter+Foundation.swift
//  BaseProject_Swift
//
//  Created by ArthurShuai on 2018/2/26.
//  Copyright © 2018年 ArthurShuai. All rights reserved.
//

import Foundation
import UIKit

/// 应用Apple ID
public let AppleID = ""

/// 是否使用模拟数据
public let USE_SIMULATE = false

/// 获取plist文件模拟数据
/// plist文件根结构为数组
/// - Parameter plistName: plist文件名
/// - Returns: 数组数据
public func get_simulate_array(plistName:String) -> [Any]
{
    return NSArray.init(contentsOfFile: Bundle.main.path(forResource: plistName, ofType: "plist")!) as! [Any]
}
/// 获取plist文件模拟数据
/// plist文件根结构为字典
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

/// 加载本地图片
///
/// - Parameters:
///   - imageName: 图片名称
///   - type: 图片类型：png、jpg等
/// - Returns: 图片
public func loadImage(imageName:String, type:String) -> UIImage
{
    return UIImage.init(contentsOfFile: Bundle.main.path(forResource: imageName, ofType: type)!)!
}

/// 颜色生成器
///
/// - Parameters:
///   - rgbValue: 16进制rgbValue e.g. 0xffffff
///   - alphaValue: 透明度值 0~1
/// - Returns: 颜色
public func makeColor(rgbValue:Int, alphaValue:CGFloat) -> UIColor
{
    return UIColor.init(red: (CGFloat((rgbValue & 0xFF0000)>>16))/255.0, green: (CGFloat((rgbValue & 0xFF00)>>8))/255.0, blue: (CGFloat(rgbValue & 0xFF))/255.0, alpha: alphaValue)
}

/// 颜色生成器2
///
/// - Parameters:
///   - redValue: 红色值 0~255
///   - greenValue: 绿色值 0~255
///   - blueValue: 蓝色值 0~255
///   - alphaValue: 透明度值 0~1
/// - Returns: 颜色
public func makeColor(redValue:CGFloat, greenValue:CGFloat, blueValue:CGFloat, alphaValue:CGFloat) -> UIColor
{
    return UIColor.init(red: redValue/255.0, green: greenValue/255.0, blue: blueValue/255.0, alpha: alphaValue)
}
