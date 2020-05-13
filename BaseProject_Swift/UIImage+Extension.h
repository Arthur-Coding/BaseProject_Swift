//
//  UIImage+Extension.h
//  Shoujimama
//
//  Created by ArthurShuai on 2019/4/13.
//  Copyright © 2019 ArthurShuai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Extension)

// 保持分辨率不变，压缩图片到1M内
- (NSData *)compressImage;

// 旋转图片方向
- (UIImage *)fixOrientation;

@end

NS_ASSUME_NONNULL_END
