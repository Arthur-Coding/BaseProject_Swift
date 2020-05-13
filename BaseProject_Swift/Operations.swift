//
//  Operations.swift
//  BaseProject
//
//  Created by ArthurShuai on 2018/4/24.
//  Copyright © 2018年 ArthurShuai. All rights reserved.
//

import Foundation
import LSRouter_Swift
import LSRootNavigationController
import MJRefresh

extension LSRouter {
    
    class func setupNavigationController(_ rootVC: UIViewController) -> LSRootNavigationController
    {
        let navc = LSRootNavigationController(rootViewController: rootVC)
        navc.navigationBar.isTranslucent = false
        navc.navigationBar.tintColor = color(rgbValue: 0x333333)
        navc.navigationBar.barTintColor = .white
        navc.navigationBar.titleTextAttributes = [.foregroundColor: color(rgbValue: 0x333333), .font: UIFont.boldSystemFont(ofSize: 18)]
        return navc
    }
    
    class func setupPresentNavigationController(_ rootVC: UIViewController) -> LSRootNavigationController
    {
        let navc = setupNavigationController(rootVC)
        navc.modalPresentationStyle = .custom
        navc.modalTransitionStyle = .crossDissolve
        navc.view.backgroundColor = .clear
        rootVC.navigationController?.navigationBar.isHidden = true
        return navc
    }
    
    /// 当前显示的视图控制器
    class func currentViewController() -> UIViewController
    {
        return findTopViewController((UIApplication.shared.keyWindow?.rootViewController)!)
    }
    private class func findTopViewController(_ vc: UIViewController) -> UIViewController
    {
        if vc.presentedViewController != nil {
            return findTopViewController(vc.presentedViewController!)
        } else if vc is UISplitViewController {
            let tvc = vc as! UISplitViewController
            return tvc.viewControllers.count > 0 ? findTopViewController(tvc.viewControllers.last!) : vc
        } else if vc is UINavigationController {
            let tvc = vc as! UINavigationController
            return tvc.viewControllers.count > 0 ? findTopViewController(tvc.viewControllers.last!) : vc
        } else if vc is UITabBarController {
            let tvc = vc as! UITabBarController
            return (tvc.viewControllers?.count)! > 0 ? findTopViewController(tvc.selectedViewController!) : vc
        } else if vc is LSContainerController {
            return findTopViewController((vc as! LSContainerController).contentViewController)
        } else {
            return vc
        }
    }
    
}

extension LSRouter {

    typealias alertAction = (UIAlertAction)->Void
    
    class func alert(_ title: String?, _ message: String?, _ confirmAction: alertAction? = nil, _ confirmTitle: String = ALERT_CONFIRM)
    {
        var config = AlertConfig()
        config.title = title
        config.message = message
        config.actionTitles = [confirmTitle]
        config.actionStyles = [.default]
        if confirmAction != nil {
            config.actions = [confirmAction!]
        }
        showAlert(obj: (UIApplication.shared.keyWindow?.rootViewController)!, config)
    }

    class func alert2(_ title: String?, _ message: String?, _ confirmAction: alertAction? = nil, _ cancelAction: alertAction? = nil)
    {
        var config = AlertConfig()
        config.title = title
        config.message = message
        config.actionTitles = [ALERT_CONFIRM, ALERT_CANCEL]
        config.actionStyles = [.default, .cancel]
        var actions = [alertAction]()
        if confirmAction != nil {
            actions.append(confirmAction!)
        }
        if cancelAction != nil {
            actions.append(cancelAction!)
        }
        config.actions = actions
        showAlert(obj: (UIApplication.shared.keyWindow?.rootViewController)!, config)
    }
    
    struct AlertConfig {
        
        public var type = UIAlertController.Style.alert
        
        public var title: String?
        public var titleTextAlign = NSTextAlignment.center
        public var titleTextColor: UIColor?
        
        public var message: String?
        public var messageTextAlign = NSTextAlignment.center
        public var messageTextColor: UIColor?
        
        public var actionTitles: [String]?
        public var actionStyles: [UIAlertAction.Style]?
        public var actionTitleColors: [UIColor]?
        public var actions: [alertAction]?
        
        public var hasTextField = false
        public var configurations: [(UITextField)->Void]?
        
        public var completion:(()->Void)?
        
    }
    
    class func showAlert(obj:UIViewController, _ config: AlertConfig)
    {
        let alert = UIAlertController.init(title: config.title, message: config.message, preferredStyle: config.type)
        
        for subView in (((((alert.view.subviews[0]).subviews[0]).subviews[0]).subviews[0]).subviews[0]).subviews {
            if let lab = subView as? UILabel {
                if lab.text == config.title {
                    lab.textAlignment = config.titleTextAlign
                    if config.titleTextColor != nil {
                        lab.textColor = config.titleTextColor!
                    }
                }else if lab.text == config.message {
                    lab.textAlignment = config.messageTextAlign
                    if config.messageTextColor != nil {
                        lab.textColor = config.messageTextColor!
                    }
                }
            }
        }
        
        if config.actionTitles == nil {
            let alertAction1 = UIAlertAction.init(title: "确定", style: .default, handler: config.actions != nil ? config.actions?.first : nil)
            let alertAction2 = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
            alert.addAction(alertAction1)
            alert.addAction(alertAction2)
        } else {
            for (index, title) in config.actionTitles!.enumerated() {
                var action: alertAction?
                if config.actions != nil && index < config.actions!.count {
                    action = config.actions![index]
                }
                let alertAction = UIAlertAction.init(title: title, style: config.actionStyles![index], handler:action)
                if config.actionTitleColors != nil && index < config.actionTitleColors!.count {
                    alertAction.setValue(config.actionTitleColors![index], forKey: "titleTextColor")
                }
                alert.addAction(alertAction)
            }
        }
        
        if config.hasTextField && config.configurations != nil  {
            for configuration in config.configurations! {
                alert.addTextField(configurationHandler: configuration)
            }
        }
        
        DispatchQueue.main.async {
            obj.present(alert, animated: true, completion: config.completion)
        }
    }
    
}
    
extension LSRouter {
    
    /// 颜色值求颜色
    ///
    /// - Parameters:
    ///   - rgbValue: 16进制rgbValue e.g. 0xffffff
    ///   - alpha: 透明度值 0~1
    /// - Returns: 颜色
    class func color(rgbValue:Int, alpha:CGFloat = 1) -> UIColor
    {
        return UIColor.init(red: (CGFloat((rgbValue & 0xFF0000)>>16))/255.0, green: (CGFloat((rgbValue & 0xFF00)>>8))/255.0, blue: (CGFloat(rgbValue & 0xFF))/255.0, alpha: alpha)
    }

    /// 重置图片大小
    ///
    /// - Parameters:
    ///   - imageName: 图片名字，png可以忽略后缀
    ///   - width: 宽度
    ///   - height: 高度
    /// - Returns: 图片
    class func resetImageSize(imageName:String, width:CGFloat, height:CGFloat) -> UIImage {
        let image = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: width, height: height))
        image.image = UIImage.init(named: imageName)
        let bgImg = image.image
        UIGraphicsBeginImageContextWithOptions(CGSize.init(width: width, height: height), false, 0)
        bgImg?.draw(in: image.frame)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return (newImage?.withRenderingMode(.alwaysOriginal))!
    }

    /// 判断数据是否是字符串
    ///
    /// - Parameter data: 数据
    /// - Returns: 是字符串时返回字符串，不是字符串返回空字符串
    class func toString(data:Any) -> String
    {
        return data is NSNull ? "" : String(describing: data)
    }
    
}

extension LSRouter {

    /// 验证手机号码格式是否正确
    ///
    /// - Parameter phone: 手机号码
    /// - Returns: true or false
    class func validatePhone(phone:String) -> Bool
    {
        let phoneTest = NSPredicate.init(format: "SELF MATCHES %@", "^(1)\\d{10}$")
        return phoneTest.evaluate(with:phone)
    }

    /// 验证邮箱格式是否正确
    ///
    /// - Parameter email: 邮箱
    /// - Returns: true or false
    class func validateEmail(email:String) -> Bool
    {
        let emailTest = NSPredicate.init(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}")
        return emailTest.evaluate(with:email)
    }
    
    /// 计算文本宽度
    ///
    /// 一行文字
    /// - Parameters:
    ///   - text: 文本
    ///   - font: 字体
    /// - Returns: 宽度
    class func countWidth(_ text: String, _ font: UIFont) -> CGFloat
    {
        return (text as NSString).size(withAttributes: [NSAttributedString.Key.font:font]).width
    }
    
}

extension LSRouter {

    /// 文件夹大小
    ///
    /// - Parameter path: 文件夹路径
    /// - Returns: 单位Mb
    class func folderSize(atPath path:String) -> CGFloat
    {
        let fileManager = FileManager.init()
        var folderSize:CGFloat = 0.0
        if fileManager.fileExists(atPath: path) {
            let subFiles = fileManager.subpaths(atPath: path)
            for fileName in subFiles! {
                folderSize += fileSize(atPath: (path as NSString).appendingPathComponent(fileName))
            }
        }
        return folderSize
    }

    /// 计算文件夹内单个文件大小
    ///
    /// - Parameter path: 文件路径
    /// - Returns: 单个文件大小，单位Mb
    private class func fileSize(atPath path:String) -> CGFloat
    {
        let fileManager = FileManager.init()
        var fileSize:CGFloat = 0.0
        if fileManager.fileExists(atPath: path as String) {
            do {
                let attr = try fileManager.attributesOfItem(atPath: path)
                let size = attr[FileAttributeKey.size] as! CGFloat
                fileSize = size/1024.0/1024.0
            }
            catch {
                print("error :\(error)")
            }
        }
        return fileSize
    }

    /// 缓存文件大小
    ///
    /// - Returns: 单位Mb
    class func cacheSize() -> CGFloat
    {
        let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
        return folderSize(atPath: path!)
    }

    /// 清理缓存文件
    class func clearCache()
    {
        let fileManager = FileManager.init()
        let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
        do {
            try fileManager.removeItem(atPath: path!)
        } catch {
            print("error :\(error)")
        }
    }
    
}

extension LSRouter {
    
    /// 清除字典中的null值
    class func clearNull(_ dict: [String: Any]?) -> [String: Any]
    {
        var temp = dict
        if dict != nil {
            for (key, value) in dict! {
                if value is NSNull {
                    temp![key] = nil
                }
            }
        }
        return temp ?? [String: Any]()
    }
    
}
