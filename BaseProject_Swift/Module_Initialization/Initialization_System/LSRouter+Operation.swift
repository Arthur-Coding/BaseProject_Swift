//
//  LSRouter+Operation.swift
//  BaseProject_Swift
//
//  Created by ArthurShuai on 2018/2/26.
//  Copyright © 2018年 ArthurShuai. All rights reserved.
//
//  文档名称：快捷操作配置
//  功能描述：快捷操作配置

import Foundation
import UIKit

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

public typealias alertAction = (UIAlertAction)->Void
/// 提示框
///
/// - Parameters:
///   - obj: 弹出提示框的视图控制器
///   - alertType: 提示框的弹出类型
///   - title: 提示标题
///   - message: 提示信息
///   - actionTitles: action按钮标题数组
///   - actionTypes: action按钮类型数组
///   - actions: actions数组
///   - completion: 提示框弹出后操作
public func alert(obj:UIViewController, alertType:UIAlertControllerStyle, title:String?, message:String?, actionTitles:[String]?, actionTypes:[UIAlertActionStyle]?, actions:[alertAction]?, completion:(()->Void)?)
{
    let alert = UIAlertController.init(title: title, message: message, preferredStyle: alertType)
    for (index, title) in actionTitles!.enumerated()
    {
        var action:alertAction?
        if index < (actions?.count)!
        {
            action = actions?[index]
        }
        let alertAction = UIAlertAction.init(title: title, style: actionTypes![index], handler:action)
        alert.addAction(alertAction)
    }
    obj.present(alert, animated: true, completion: completion)
}

/// 更改手机状态栏背景颜色
///
/// - Parameter color: color
public func changeStatusBarColor(color:UIColor)
{
    let statusBarWindow:UIWindow = UIApplication.shared.value(forKey: "statusBarWindow") as! UIWindow
    let statusBar:UIView = statusBarWindow.value(forKey: "statusBar") as! UIView
    if statusBar.responds(to: #selector(setter: UIView.backgroundColor))
    {
        statusBar.backgroundColor = color
    }
}
