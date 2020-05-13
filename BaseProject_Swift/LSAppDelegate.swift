//
//  LSRouter+AppDelegate.swift
//  BaseProject_Swift
//
//  Created by ArthurShuai on 2018/2/26.
//  Copyright © 2018年 ArthurShuai. All rights reserved.
//
//  文档名称：AppDelegate配置
//  功能描述：AppDelegate配置

import UIKit
import LSRouter_Swift
import IQKeyboardManagerSwift

public extension LSRouter {

    // MARK: - 项目初始化
    class func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
    {
        let tableView:UITableView = UITableView.appearance()
        tableView.tableHeaderView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
        tableView.tableFooterView = UIView.init()
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.toolbarTintColor = .black
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "完成"
        
    }

    // MARK: - 通知相关配置
    // MARK: 用户通知(推送) _自定义方法
    private class func registerUserNotification()
    {
        let types = (UInt8(UIUserNotificationType.alert.rawValue)|UInt8(UIUserNotificationType.sound.rawValue)|UInt8(UIUserNotificationType.badge.rawValue))
        let settings = UIUserNotificationSettings.init(types: UIUserNotificationType(rawValue: UIUserNotificationType.RawValue(types)), categories: nil)
        UIApplication.shared.registerForRemoteNotifications()
        UIApplication.shared.registerUserNotificationSettings(settings)
    }
    // MARK: 远程通知注册成功委托
    class func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    {
    }
    // MARK: 远程通知注册失败委托
    class func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error)
    {
    }
    // MARK: background fetch  唤醒
    class func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void)
    {
        completionHandler(UIBackgroundFetchResult.newData)
    }
    // MARK: APP已经接收到“远程”通知(推送) - 透传推送消息
    class func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any])
    {
        //清除角标
        application.applicationIconBadgeNumber = 0;
    }

    // MARK: - Others
    class func applicationWillResignActive(_ application: UIApplication)
    {
    }

    class func applicationDidEnterBackground(_ application: UIApplication)
    {
    }

    class func applicationWillEnterForeground(_ application: UIApplication)
    {
    }

    class func applicationDidBecomeActive(_ application: UIApplication)
    {
    }

    class func applicationWillTerminate(_ application: UIApplication)
    {
    }
}
