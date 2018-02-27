//
//  LSRouter+Network.swift
//  BaseProject_Swift
//
//  Created by ArthurShuai on 2018/2/26.
//  Copyright © 2018年 ArthurShuai. All rights reserved.
//

import Foundation
import LSRouter_Swift
import AFNetworking
import SwiftyJSON

public extension LSRouter {

    /// 网络请求
    public class func networkManager() -> AFHTTPSessionManager
    {
        let session:AFHTTPSessionManager! = AFHTTPSessionManager.init();
        if baseUrl.hasPrefix("https") {
            // 设置HTTPS免证书登录
            let securityPolicy = AFSecurityPolicy.default()
            securityPolicy.allowInvalidCertificates = true;
            securityPolicy.validatesDomainName = false;
            session.securityPolicy = securityPolicy
        }
        return session;
    }

    /// 网络状态监控
    public class func openNetworkMonitoring()
    {
        let manager = AFNetworkReachabilityManager.shared()
        manager.setReachabilityStatusChange { (_ status: AFNetworkReachabilityStatus) in
            switch status
            {
                case .unknown, .notReachable:
                
                break
                case .reachableViaWWAN:

                break
                case .reachableViaWiFi:
                    
                break
            }
        }
        manager.startMonitoring()
    }
    
}
