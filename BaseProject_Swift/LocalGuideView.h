//
//  LocalGuideView.h
//
//  Created by ArthurShuai on 16/4/14.
//  Copyright © 2016年 ArthurShuai. All rights reserved.
//
//  系统名称：加载滚动图片引导页
//  功能描述：1.支持加载滚动图片实现引导页
//          2.reloadData 刷新数据的方法,可以刷新引导页中数据

#import <UIKit/UIKit.h>


@class LocalGuideView;

@protocol LocalGuideViewDelegate <UIScrollViewDelegate>


@optional
// 滚动结束
- (void)didScroll:(LocalGuideView *)scrollView index:(NSInteger)index;
// 点击滚动视图
- (void)clickAtIndex:(NSInteger)index scrollView:(LocalGuideView *)scrollView;

@end

@interface LocalGuideView : UIScrollView

@property (nonatomic) id<LocalGuideViewDelegate> actionDelegate;

@property (nonatomic, strong) NSArray *imageArr;//图片数组
@property (nonatomic) UIViewContentMode imgContentMode; // 图片模式
@property (nonatomic) CGFloat imgCorner; // 图片圆角

- (instancetype)initWithFrame:(CGRect)frame and:(NSArray *)imgArr;

- (instancetype)initWithFrame:(CGRect)frame and:(NSArray *)imgArr imagePlaceholder:(NSString *)imageName;

- (instancetype)initWithFrame:(CGRect)frame and:(NSArray *)imgArr imagePlaceholder:(NSString *)imageName imgBackgroundColor:(UIColor *)bgColor;

/**
 开启自动轮播
 @param timeInterval 切换时间
 */
- (void)openCarouselWithTimeInterval:(NSInteger)timeInterval;

/**
 关闭自动轮播
 */
- (void)closeCarousel;

/**
 刷新数据方法
 */
- (void)reloadData;

@end
