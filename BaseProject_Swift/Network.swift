//
//  LSRouter+Network.swift
//  MangQiLai
//
//  Created by ArthurShuai on 2018/2/26.
//  Copyright © 2018年 ArthurShuai. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import LSRouter_Swift

let API_BASE = GATEWAY_IP + ""

extension LSRouter {
    
    static var sessionManger: SessionManager? = nil
    
    /// 网络请求
    /// - Parameters:
    ///   - showHud: 是否展示hud
    ///   - hudText: hud提示文本
    ///   - url: api
    ///   - params: 请求参数
    ///   - successAction: 请求成功处理
    ///   - failedAction: 请求失败处理
    /// - Returns: 请求实例
    @discardableResult
    class func request(_ showHud:Bool,
                       _ hudText: String?,
                       _ url: String,
                       _ params: [String: Any]?,
                       _ successAction:((_ response: JSON) -> Void)? = nil,
                       _ failedAction: ((Int, String)->Void)? = nil) -> DataRequest?
    {
        if showHud {
            showHudInView(text: hudText, offset: 0, autoHide: false, afterDelay: 0, presenter:UIApplication.shared.keyWindow!)
        }
        return Alamofire
            .request(API_BASE + url,
                     method: .post,
                     parameters: params,
                     encoding: URLEncoding.default,
                     headers: ["token": LS_Token] as HTTPHeaders)
            .responseJSON { (response) in
            handleResponse(response, successAction, failedAction)
        }
    }
    
    class func handleResponse(_ response: DataResponse<Any>,
                              _ successAction:((_ response: JSON) -> Void)? = nil,
                              _ failedAction: ((Int, String)->Void)? = nil)
    {
        hideHud(presenter: UIApplication.shared.keyWindow!)
        if response.result.isSuccess {
            let json = JSON.init(response.result.value ?? [String: Any]())
            if json["code"].intValue == 200 {
                if successAction != nil {
                    successAction!(json["data"])
                }
            } else {
                if json["code"].intValue == 102 { // 需要重新登录
                    LS_IsLogin = false
                    LS_Token = ""
                    LS_UserInfo = nil

//                    (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController = MQL_TabBarVC()
//                    (UIApplication.shared.delegate as! AppDelegate).window?.makeKeyAndVisible()
//                    let loginVC = LSRouter.setupNavigationController(MQL_LoginVC())
//                    loginVC.modalPresentationStyle = .fullScreen
//                    UIApplication.shared.keyWindow?.rootViewController!.present(loginVC, animated: true, completion: nil)
                }
                
                if failedAction != nil {
                    failedAction!(json["code"].intValue, json["msg"].stringValue)
                }
                
                if json["msg"].stringValue.count > 0 {
                    showHint(text: json["msg"].stringValue, presenter: (UIApplication.shared.keyWindow?.rootViewController)!)
                }
            }
        } else {
            if failedAction != nil {
                failedAction!(0, "");
            }
        }
    }
    
}
