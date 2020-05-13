//
//  HUDProgressKit.swift
//  BaseProject
//
//  Created by ArthurShuai on 2018/4/25.
//  Copyright © 2018年 ArthurShuai. All rights reserved.
//

import Foundation
import UIKit
import LSRouter_Swift
import MBProgressHUD

extension LSRouter {

    // MARK: - 加载和提示

    /// 设置HUD背景颜色
    ///
    /// - Parameters:
    ///   - color: 背景颜色
    ///   - obj: 视图控制器/视图
    class func setHUDBackgroundColor(color:UIColor?, presenter obj:NSObject)
    {
        obj.setHUDBackgroundColor(color: color)
    }

    /// 设置HUD风火轮/文本颜色
    ///
    /// - Parameters:
    ///   - color: 风火轮/文本颜色
    ///   - obj: 视图控制器/视图
    class func setHUDContentColor(color:UIColor?, presenter obj:NSObject)
    {
		obj.setHUDContentColor(color: color)
    }

    /// 加载风火轮
    ///
    /// - Parameters obj: 视图控制器/视图
    class func showHudInView(presenter obj:NSObject)
    {
		obj.showHudInView()
    }

    /// 信息提示
    ///
    /// - Parameter:
    ///	  - hint: 提示信息
    ///   - obj: 视图控制器/视图
    class func showHint(text hint:String?, presenter obj:NSObject)
    {
        showHint(text: hint, offset: 180, autoHide: true, afterDelay: 2, presenter: obj)
    }

    /// 通用加载风火轮
    ///
    /// - Parameters:
    ///   - hint: 提示信息
    ///   - yOffset: Y轴偏移，相当于父视图中间位置
    ///   - hide: 是否自动隐藏
    ///   - delay: 自动隐藏延迟时间，只有hide为true才起作用
    ///   - obj: 视图控制器/视图
    class func showHudInView(text hint:String?, offset yOffset:CGFloat, autoHide hide:Bool, afterDelay delay:TimeInterval, presenter obj:NSObject)
    {
		obj.showHudInView(text: hint, offset: yOffset, autoHide: hide, afterDelay: delay)
    }

    /// 通用图片和信息提示
    ///
    /// - Parameters:
    ///   - hint: 提示信息
    ///   - img: 提示图片
    ///   - yOffset: Y轴偏移，相当于父视图中间位置
    ///   - hide: 是否自动隐藏
    ///   - delay: 自动隐藏延迟时间，只有hide为true才起作用
    ///   - obj: 视图控制器/视图
    class func showHint(text hint:String?, image img:UIImage?, offset yOffset:CGFloat, autoHide hide:Bool, afterDelay delay:TimeInterval, presenter obj:NSObject)
    {
		obj.showHint(text: hint, image: img, offset: yOffset, autoHide: hide, afterDelay: delay)
    }

    /// 通用信息提示
    ///
    /// - Parameters:
    ///   - hint: 提示信息
    ///   - yOffset: Y轴偏移，相当于父视图中间位置
    ///   - hide: 是否自动隐藏
    ///   - delay: 自动隐藏延迟时间，只有hide为true才起作用
    ///   - obj: 视图控制器/视图
    class func showHint(text hint:String?, offset yOffset:CGFloat, autoHide hide:Bool, afterDelay delay:TimeInterval, presenter obj:NSObject)
    {
        showHint(text: hint, image: nil, offset: yOffset, autoHide: hide, afterDelay: delay, presenter: obj)
    }

    /// 隐藏hud
    ///
    /// - Parameters presenter: 视图控制器/视图
    class func hideHud(presenter obj:NSObject)
    {
		obj.hideHud()
    }

	// MARK: - 进度条

    /// 便利初始化
    ///
    /// - Parameters:
    ///   - width: 进度条宽度
    ///   - height: 进度条高度
    ///   - lineColor: 进度条颜色
    ///   - presenter: 视图控制器/视图/layer
    class func addLoadProgress(width:CGFloat, height:CGFloat, lineColor:UIColor?, presenter:NSObject)
    {
        let layer = LSProgressLayer.init(width: width, height: height, lineColor: lineColor)
        if presenter is UIViewController {
			(presenter as! UIViewController).view.layer.addSublayer(layer)
        }else if presenter is UIView {
			(presenter as! UIView).layer.addSublayer(layer)
        }else if presenter is CALayer {
			(presenter as! CALayer).addSublayer(layer)
        }
    }

    private class func getProgressLayer(presenter:NSObject, after:((_ layer:LSProgressLayer)->Void)?)
    {
        var layer:CALayer?
        if presenter is UIViewController {
            layer = (presenter as! UIViewController).view.layer
        }else if presenter is UIView {
            layer = (presenter as! UIView).layer
        }else if presenter is CALayer {
            layer =  presenter as? CALayer
        }
        if layer != nil {
            for obj in layer!.sublayers! {
                if obj is LSProgressLayer {
                    if after != nil {
                        after!(obj as! LSProgressLayer)
                    }
                }
            }
        }
    }

    /// 加载开始
    ///
    /// - Parameter presenter: 视图控制器/视图/layer
    class func startLoadProgressAt(presenter:NSObject)
    {
        getProgressLayer(presenter: presenter) { (_ layer) in
            layer.startLoad()
        }
    }

    /// 加载完成
    ///
    /// - Parameter presenter: 视图控制器/视图
    class func finishedLoadProgressAt(presenter:NSObject)
    {
        getProgressLayer(presenter: presenter) { (_ layer) in
            layer.finishedLoad()
        }
    }

    /// 关闭定时器
    ///
    /// - deinit方法调用
    ///
    /// - Parameter presenter: 视图控制器/视图
    class func closeProgressTimerAt(presenter:NSObject)
    {
        getProgressLayer(presenter: presenter) { (_ layer) in
            layer.closeTimer()
        }
    }
}

extension NSObject {

    private var HUD: MBProgressHUD? {
        set(hud) {
            objc_setAssociatedObject(self, UnsafeRawPointer.init(bitPattern: "HUD".hashValue)!, hud, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            let hud = objc_getAssociatedObject(self, UnsafeRawPointer.init(bitPattern: "HUD".hashValue)!) as? MBProgressHUD
            hud?.layer.zPosition = CGFloat(INT8_MAX)
            return hud
        }
    }

    private var hudBackgroundColor: UIColor? {
        set(color) {
            objc_setAssociatedObject(self, UnsafeRawPointer.init(bitPattern: "hudBackgroundColor".hashValue)!, color, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            let color = objc_getAssociatedObject(self, UnsafeRawPointer.init(bitPattern: "hudBackgroundColor".hashValue)!) as? UIColor
            return color == nil ? UIColor.black : color
        }
    }

    private var hudContentColor: UIColor? {
        set(color) {
            objc_setAssociatedObject(self, UnsafeRawPointer.init(bitPattern: "hudContentColor".hashValue)!, color, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            let color = objc_getAssociatedObject(self, UnsafeRawPointer.init(bitPattern: "hudContentColor".hashValue)!) as? UIColor
            return color == nil ? UIColor.white : color
        }
    }

    /// 设置HUD背景颜色
    ///
    /// - Parameter color: 背景颜色
    func setHUDBackgroundColor(color:UIColor?)
    {
		hudBackgroundColor = color
    }

    /// 设置HUD风火轮/文本颜色
    ///
    /// - Parameter color: 风火轮/文本颜色
    func setHUDContentColor(color:UIColor?)
    {
		hudContentColor = color
    }

    /// 加载风火轮
    func showHudInView()
    {
		hideHud()
        var coverView:UIView?
        if self is UIViewController {
            coverView = (self as? UIViewController)?.view
        }else {
            coverView = self as? UIView
        }
        HUD = MBProgressHUD.init(view: coverView!)
		HUD?.bezelView.backgroundColor = hudBackgroundColor
        HUD?.contentColor = hudContentColor
        HUD?.removeFromSuperViewOnHide = true
        coverView!.addSubview(HUD!)
		HUD?.show(animated: true)
    }

    /// 信息提示
    ///
    /// - Parameter hint: 提示信息
    func showHint(text hint:String?)
    {
		showHint(text: hint, offset: 180, autoHide: true, afterDelay: 2)
    }

    /// 通用加载风火轮
    ///
    /// - Parameters:
    ///   - hint: 提示信息
    ///   - yOffset: Y轴偏移，相当于父视图中间位置
    ///   - hide: 是否自动隐藏
    ///   - delay: 自动隐藏延迟时间，只有hide为true才起作用
    func showHudInView(text hint:String?, offset yOffset:CGFloat, autoHide hide:Bool, afterDelay delay:TimeInterval)
    {
		showHudInView()
        HUD?.offset = CGPoint.init(x: (HUD?.offset.x)!, y: (HUD?.offset.y)!+yOffset)
        HUD?.label.numberOfLines = 0
		HUD?.label.text = hint
        if hide {
            HUD?.hide(animated: true, afterDelay: delay)
        }
    }

    /// 通用图片和信息提示
    ///
    /// - Parameters:
    ///   - hint: 提示信息
    ///	  - img: 提示图片
    ///   - yOffset: Y轴偏移，相当于父视图中间位置
    ///   - hide: 是否自动隐藏
    ///   - delay: 自动隐藏延迟时间，只有hide为true才起作用
    func showHint(text hint:String?, image img:UIImage?, offset yOffset:CGFloat, autoHide hide:Bool, afterDelay delay:TimeInterval)
    {
		hideHud()
        let window = UIApplication.shared.delegate?.window
        HUD = MBProgressHUD.showAdded(to: window!! as UIView, animated: true)
        HUD?.isUserInteractionEnabled = false;
        HUD?.mode = .text;
        HUD?.bezelView.backgroundColor = hudBackgroundColor;
        HUD?.contentColor = hudContentColor;
        HUD?.removeFromSuperViewOnHide = true;
        HUD?.label.numberOfLines = 0;
        HUD?.label.text = hint;
        HUD?.margin = 10;
		HUD?.offset = CGPoint.init(x: (HUD?.offset.x)!, y: (HUD?.offset.y)!+yOffset)

        if img != nil {
			HUD?.customView = UIImageView.init(image: img)
			HUD?.mode = .customView
        }

        if hide {
            HUD?.hide(animated: true, afterDelay: delay)
        }
    }

    /// 通用信息提示
    ///
    /// - Parameters:
    ///   - hint: 提示信息
    ///   - yOffset: Y轴偏移，相当于父视图中间位置
    ///   - hide: 是否自动隐藏
    ///   - delay: 自动隐藏延迟时间，只有hide为true才起作用
    func showHint(text hint:String?, offset yOffset:CGFloat, autoHide hide:Bool, afterDelay delay:TimeInterval)
    {
		showHint(text: hint, image: nil, offset: yOffset, autoHide: hide, afterDelay: delay)
    }

    /// 隐藏hud
    func hideHud()
    {
		HUD?.hide(animated: true)
        HUD = nil
    }

}

class LSProgressLayer: CAShapeLayer {

    static let kTimeInterval:TimeInterval = 0.0088
    private var timer:Timer?
    private var plusWidth:CGFloat = 0.01

    /// 便利初始化
    ///
    /// - Parameters:
    ///   - width: 进度条宽度
    ///   - height: 进度条高度
    ///   - lineColor: 进度条颜色
    init(width:CGFloat, height:CGFloat, lineColor:UIColor?) {
		super.init()

        self.frame = CGRect.init(x: 0, y: 0.25, width: width, height: height)
        let path = UIBezierPath.init()
        path.move(to: CGPoint.init(x: 0, y: height))
        path.addLine(to: CGPoint.init(x: width, y: height))
        self.path = path.cgPath
        strokeEnd = 0
        strokeColor = lineColor?.cgColor
        lineWidth = height

        timer = Timer.scheduledTimer(timeInterval: LSProgressLayer.kTimeInterval, target: self, selector: #selector(pathChanged(timer:)), userInfo: nil, repeats: true)
        timer?.fireDate = Date.distantFuture
    }

    override init(layer: Any) {
        super.init(layer: layer)
    }

    @objc func pathChanged(timer:Timer)
    {
		strokeEnd += plusWidth

        if strokeEnd > 0.66 {
            plusWidth = 0.002
        }
    }

    /// 加载开始
    func startLoad()
    {
        if (timer?.isValid)! {
			timer?.fireDate = Date.init(timeIntervalSinceNow: LSProgressLayer.kTimeInterval)
        }
    }

    /// 加载完成
    func finishedLoad()
    {
		closeTimer()
        strokeEnd = 1.0
        weak var weakSelf = self
        DispatchQueue.main.asyncAfter(deadline: .now()+0.25) {
            weakSelf?.removeFromSuperlayer()
        }
    }

    /// 关闭定时器
    func closeTimer()
    {
		timer?.invalidate()
        timer = nil
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
		closeTimer()
    }

}
