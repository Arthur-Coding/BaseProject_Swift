//
//  UIViewController+Extension.swift
//  MangQiLai
//
//  Created by 刘帅 on 2020/3/28.
//  Copyright © 2020 ArthurShuai. All rights reserved.
//

import UIKit
import AVFoundation
import CoreServices
import Photos
import LSRouter_Swift

extension UIViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate, HXImagePickerControllerDelegate {
    
    private static var uploadAvatarBlk: (([UIImage])->Void)?
    
    /// 选择图片/拍照
    ///
    /// - Parameters:
    ///   - photoLibrary: true 包含从相册中选择 false 不包含从相册中选择
    ///   - maxSelectCount: 图片数量
    ///   - nextAction: 选择图片后处理
    public func uploadImage(_ hasPhotoLibrary: Bool,
                            _ maxSelectCount: Int,
                            _ nextAction: (([UIImage])->Void)?)
    {
        UIViewController.uploadAvatarBlk = nextAction
        
        var actionNames = ["手机拍照"]
        var actionTypes = [UIAlertAction.Style.default]
        var actions: [LSRouter.alertAction] = [{ _ in
            self.setupImagePicker(hasPhotoLibrary, maxSelectCount)
        }]
        if hasPhotoLibrary {
            actionNames.append("从相册中上传")
            actionTypes.append(.default)
            actions.append({ _ in
                self.setupImagePicker(false, maxSelectCount)
            })
        }
        actionNames.append("取消")
        actionTypes.append(.cancel)
        var alertConfig = LSRouter.AlertConfig()
        alertConfig.type = .actionSheet
        alertConfig.actionTitles = actionNames
        alertConfig.actionStyles = actionTypes
        alertConfig.actions = actions
        LSRouter.showAlert(obj: self, alertConfig)
    }
    
}

extension UIViewController {
    
    private func setupImagePicker(_ isPhotograph: Bool,
                                  _ maxSelectCount: Int)
    {
        if isPhotograph {
            if UIImagePickerController.availableMediaTypes(for: .camera) == nil {
                LSRouter.alert("提示", "相机不可用")
            } else {
                requestCameraPemission { (granted) in
                    if granted {
                        let picker = UIImagePickerController()
                        picker.delegate = self
                        picker.sourceType = .camera
                        picker.mediaTypes = [kUTTypeImage as String]
                        self.present(picker, animated: true, completion: nil)
                    }
                }
            }
        } else {
            requestPhotoLibraryPemission { (granted) in
                if granted {
                    let picker = HXImagePickerController(hasAlbumList: true)
                    picker.hxip_delegate = self
                    picker.maxSelectCount = maxSelectCount
                    self.present(picker, animated: true, completion: nil)
                }
            }
        }
    }
    
    private func requestCameraPemission(_ action: ((Bool)->Void)? = nil)
    {
        if AVCaptureDevice.responds(to: #selector(AVCaptureDevice.authorizationStatus(for:))) {
            let permission = AVCaptureDevice.authorizationStatus(for: .video)
            switch permission {
            case .authorized:
                if action != nil {
                    action!(true)
                }
            break
            case .denied, .restricted:
                LSRouter.alert2("请授权芒起来使用摄像头", "请在“设置”>“隐私”>“相机”中或“设置”>“手机麻麻”中打开", { (_) in
                    let url = URL.init(string: UIApplication.openSettingsURLString)
                    if UIApplication.shared.canOpenURL(url!) {
                        UIApplication.shared.openURL(url!)
                    }
                }, nil)
                if action != nil {
                    action!(false)
                }
            break
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { (granted) in
                    DispatchQueue.main.async {
                        if action != nil {
                            action!(true)
                        }
                    }
                }
            break
            default: break
            }
        }
    }
    
    private func requestPhotoLibraryPemission(_ action: ((Bool)->Void)? = nil)
    {
        let photoAuthorStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorStatus {
        case .authorized:
            if action != nil {
                action!(true)
            }
        break
        case .denied, .restricted:
            LSRouter.alert2("请授权芒起来使用摄像头", "请在“设置”>“隐私”>“照片”中或“设置”>“手机麻麻”中打开", { (_) in
                let url = URL.init(string: UIApplication.openSettingsURLString)
                if UIApplication.shared.canOpenURL(url!) {
                    UIApplication.shared.openURL(url!)
                }
            }, nil)
            if action != nil {
                action!(false)
            }
        break
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { (status) in
                DispatchQueue.main.async {
                    if action != nil {
                        action!(status == .authorized)
                    }
                }
            }
        break
        default: break
        }
    }
    
}

extension UIViewController {
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let mediaType = info[UIImagePickerController.InfoKey.mediaType.rawValue] as! String
        if mediaType == kUTTypeImage as String {
            let editImg = info[UIImagePickerController.InfoKey.originalImage.rawValue] as! UIImage
            picker.dismiss(animated: true, completion: nil)
            picker.delegate = nil
            if UIViewController.uploadAvatarBlk != nil {
                UIViewController.uploadAvatarBlk!([editImg.fixOrientation()])
            }
        }
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        picker.delegate = nil
    }
    
    func imagePickerController(_ imagePickerController: HXImagePickerController, didSelected images: [UIImage]) {
        if images.count > 0 && UIViewController.uploadAvatarBlk != nil {
            UIViewController.uploadAvatarBlk!(images)
        }
    }
    
}

private let btnTitleFont = UIFont.systemFont(ofSize: 12, weight: .medium)
private let btnTitleColor = UIColor(red: 0.55, green: 0.55, blue: 0.55, alpha:1)
private let btnH: CGFloat = 24
private let btnSpcX: CGFloat = 15
private let btnSpcY: CGFloat = 15
private let spaceX: CGFloat = 15

extension UIViewController {
    
    func createSearchButtonView(_ texts: [String], _ target: UIViewController, _ action: Selector) -> UIView
    {
        let view = UIView()
        let btns = createButtons(texts, target, action)
        for button in btns {
            view.addSubview(button)
        }
        view.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: btns.count > 0 ? btns.last!.frame.origin.y + btnH + btnSpcY : 0)
        return view
    }
    
    private func createButtons(_ texts: [String], _ target: UIViewController, _ action: Selector) -> [UIButton]
    {
        var btns = [UIButton]()
        
        var totalWidth = spaceX
        var btnOriginX = spaceX
        var btnOriginY = btnSpcY
        
        for (idx, obj) in texts.enumerated() {
            var width = LSRouter.countWidth(obj, btnTitleFont) + 40
            if width > SCREEN_WIDTH - 2 * spaceX {
                width = SCREEN_WIDTH - 2 * spaceX
            }
            if idx > 0 {
                let lastBtn = btns[idx - 1]
                totalWidth = lastBtn.frame.origin.x + lastBtn.frame.width + btnSpcX
                btnOriginY = lastBtn.frame.origin.y
            }
            if totalWidth + width <= SCREEN_WIDTH - spaceX {
                btnOriginX = totalWidth
            } else {
                btnOriginX = spaceX
                btnOriginY += btnH + btnSpcY
                totalWidth = spaceX
            }
            let button = creatButton(btnOriginX, btnOriginY, width, obj, target, action)
            button.tag = idx
            btns.append(button)
            
            if (idx == 0) {
                totalWidth = width + spaceX
            }
        }
        
        return btns
    }
    
    private func creatButton(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ title: String, _ target: UIViewController, _ action: Selector) -> UIButton
    {
        let button = UIButton(type: .custom)
        button.clipsToBounds = true
        button.layer.cornerRadius = btnH / 2.0
        button.backgroundColor = .groupTableViewBackground
        button.frame = CGRect(x: x, y: y, width: width, height: btnH)
        button.titleLabel?.font = btnTitleFont
        button.titleLabel?.lineBreakMode = .byTruncatingTail
        button.setTitle(title, for: .normal)
        button.setTitleColor(btnTitleColor, for: .normal)
        button.addTarget(target, action: action, for: .touchUpInside)
        return button
    }
    
}
