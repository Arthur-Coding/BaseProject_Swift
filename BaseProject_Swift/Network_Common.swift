//
//  Network_Common.swift
//  MangQiLai
//
//  Created by 刘帅 on 2020/3/30.
//  Copyright © 2020 ArthurShuai. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import LSRouter_Swift

// MARK: - API

/// 单个图片上传
private let API_Upload_Image = ""

// MARK: - 图片上传

extension LSRouter {
    
    /// 选择/拍照后单个图片上传
    /// - Parameters:
    ///   - hasPhotoLibrary: true 支持从相册中选择，false 不支持从相册中选择
    ///   - nextAction: 上传成功后处理
    class func common_uploadImage(_ hasPhotoLibrary:Bool, _ nextAction: ((UIImage, String, String)->Void)?)
    {
        currentViewController().uploadImage(hasPhotoLibrary, 1) { (images) in
            if images.count > 0 {
                uploadImage(images.first!, nextAction)
            }
        }
    }
    
    /// 单个图片上传
    /// - Parameters:
    ///   - image: 图片
    ///   - biz: 业务类型名
    ///   - nextAction: 上传成功后处理
    private class func uploadImage(_ image: UIImage, _ nextAction: ((UIImage, String, String)->Void)?)
    {
        DispatchQueue.main.async {
            showHudInView(text: "图片上传中", offset: 0, autoHide: false, afterDelay: 0, presenter: UIApplication.shared.keyWindow!)
            Alamofire.upload(multipartFormData: { (formData) in
                let imageName = "image\(time_cTimestampFromDate(date: Date())).jpg"
                formData.append(image.compressImage(), withName: "file", fileName: imageName, mimeType: "image/jpeg")
            }, to: API_BASE + API_Upload_Image) { (result) in
                switch result {
                case .success(let imgUpload, _, _):
                    imgUpload.responseJSON { (response) in
                        handleResponse(response, { (data) in
//                            if nextAction != nil {
//                                nextAction!(image, data["imageObjectUrl"].stringValue, data["imageObjectKey"].stringValue)
//                            }
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) {
                                showHint(text: "上传图片成功", presenter: UIApplication.shared.keyWindow!)
                            }
                        }, nil)
                    }
                break
                case .failure(let err):
                    hideHud(presenter: UIApplication.shared.keyWindow!)
                    print(err)
                break
                }
            }
        }
    }
    
}
