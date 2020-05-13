//
//  AppDelegate.swift
//  BaseProject_Swift
//
//  Created by ArthurShuai on 2018/1/31.
//  Copyright © 2018年 ArthurShuai. All rights reserved.
//

import UIKit
import LSRouter_Swift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        LSRouter.application(application, didFinishLaunchingWithOptions: launchOptions)
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        LSRouter.applicationWillResignActive(application)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        LSRouter.applicationDidEnterBackground(application)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        LSRouter.applicationWillEnterForeground(application)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        LSRouter.applicationDidBecomeActive(application)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        LSRouter.applicationWillTerminate(application)
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return LS_AllowScreenRotation ? .allButUpsideDown : .portrait
    }

}

