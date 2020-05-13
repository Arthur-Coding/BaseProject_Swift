//
//  LocalGuideView.m
//
//  Created by ArthurShuai on 16/4/14.
//  Copyright © 2016年 ArthurShuai. All rights reserved.
//

#import "LocalGuideView.h"
#import <SDWebImage/SDWebImage.h>

@interface LocalGuideView ()<UIScrollViewDelegate,LocalGuideViewDelegate>

@property (nonatomic,strong) UIImageView *leftImg;//左边imageView
@property (nonatomic,strong) UIImageView *middleImg;//当前 imageView, 即中间显示的 imageView
@property (nonatomic,strong) UIImageView *rightImg;//右边imageView
@property (nonatomic       ) NSInteger   currentIndex;//当前图片索引
@property (nonatomic       ) NSInteger   direction;//滑动方向标识,0为无滑动,1为左滑动,2为右滑动

@property (nonatomic)BOOL isStartTimer;//是否开启定时器
@property (nonatomic,strong) NSTimer *timer;//定时器
@property (nonatomic)NSInteger timeInterval;//定时器时间间隔

@property (nonatomic) NSInteger index;

@property (nonatomic, strong) UIImage *imagePlaceholder; // 图片占位图
@property (nonatomic, strong) UIColor *imgBackgroundColor; // 图片背景颜色

@end
@implementation LocalGuideView

- (instancetype)initWithFrame:(CGRect)frame and:(NSArray *)imgArr
{
    return [self initWithFrame:frame and:imgArr imagePlaceholder:@"noPic2" imgBackgroundColor:nil];
}

- (instancetype)initWithFrame:(CGRect)frame and:(NSArray *)imgArr imagePlaceholder:(NSString *)imageName
{
    return [self initWithFrame:frame and:imgArr imagePlaceholder:imageName imgBackgroundColor:[UIColor clearColor]];
}

- (instancetype)initWithFrame:(CGRect)frame and:(NSArray *)imgArr imagePlaceholder:(NSString *)imageName imgBackgroundColor:(UIColor *)bgColor
{
    if (self = [super initWithFrame:frame]) {
        self.imageArr = imgArr;
        
        self.pagingEnabled = YES;
        self.bounces = NO;//关闭弹性
        //关闭水平和垂直方向的滚动指示条
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        //设置代理
        self.delegate = self;
        
        self.imagePlaceholder = [UIImage imageNamed:imageName];
        self.imgBackgroundColor = bgColor;
        
        //加载图片占位
        [self loadImageForScrollViewWithFrame:frame];
        
        //对方向的改变添加 KVO 监听
        [self addObserver:self forKeyPath:@"direction" options:NSKeyValueObservingOptionNew context:nil];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)setImgContentMode:(UIViewContentMode)imgContentMode
{
    _imgContentMode = imgContentMode;
    [self reloadData];
}

- (void)setImgCorner:(CGFloat)imgCorner
{
    _imgCorner = imgCorner;
    [self reloadData];
}

- (void)tapAction
{
    if ([self.actionDelegate respondsToSelector:@selector(clickAtIndex:scrollView:)]) {
        [self.actionDelegate clickAtIndex:_index scrollView:self];
    }
}
//初始加载3个 imageView 进行占位并赋初值
- (void)loadImageForScrollViewWithFrame:(CGRect)frame
{
    self.contentSize = CGSizeMake(CGRectGetWidth(frame) * 3, CGRectGetHeight(frame));
    self.contentOffset = CGPointMake(CGRectGetWidth(frame), 0);
    
    if (self.imageArr.count == 0) return;//防止数组为空
    _leftImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
    _middleImg = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(frame), 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
    _rightImg = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(frame)*2, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];

    _middleImg.userInteractionEnabled = YES;
    _leftImg.userInteractionEnabled = YES;
    _rightImg.userInteractionEnabled = YES;
    _leftImg.contentMode = _imgContentMode;
    _middleImg.contentMode = _imgContentMode;
    _rightImg.contentMode = _imgContentMode;
    _leftImg.clipsToBounds = YES;
    _middleImg.clipsToBounds = YES;
    _rightImg.clipsToBounds = YES;
    _leftImg.backgroundColor = _imgBackgroundColor;
    _middleImg.backgroundColor = _imgBackgroundColor;
    _rightImg.backgroundColor = _imgBackgroundColor;
    _leftImg.layer.cornerRadius = _imgCorner;
    _middleImg.layer.cornerRadius = _imgCorner;
    _rightImg.layer.cornerRadius = _imgCorner;

    [self addSubview:_leftImg];
    [self addSubview:_middleImg];
    [self addSubview:_rightImg];

    if (self.imageArr.count == 1) {//防止图片数据只有一个而因索引不存在崩溃
        [_leftImg removeFromSuperview];
        [_rightImg removeFromSuperview];
        self.contentOffset = CGPointMake(CGRectGetWidth(frame), 0);
        if ([self.imageArr.firstObject hasPrefix:@"http"]) {
            [_middleImg sd_setImageWithURL:[NSURL URLWithString:self.imageArr.firstObject] placeholderImage:_imagePlaceholder options:SDWebImageProgressiveLoad];
        }else {
            _middleImg.image = [UIImage imageNamed:self.imageArr.firstObject];
        }
        self.scrollEnabled = NO;
        [self.timer invalidate];
    }
    if (self.imageArr.count > 1) {
        self.scrollEnabled = YES;
        _leftImg.image = [self.imageArr[self.imageArr.count-1] isKindOfClass:[NSString class]]?[UIImage imageNamed:self.imageArr[self.imageArr.count-1]]:self.imageArr[self.imageArr.count-1];
        if ([self.imageArr[self.imageArr.count-1] hasPrefix:@"http"]) {
            [_leftImg sd_setImageWithURL:[NSURL URLWithString:self.imageArr[self.imageArr.count-1]] placeholderImage:_imagePlaceholder options:SDWebImageProgressiveLoad];
        }else {
            _leftImg.image = [UIImage imageNamed:self.imageArr[self.imageArr.count-1]];
        }
        if ([self.imageArr.firstObject hasPrefix:@"http"]) {
            [_middleImg sd_setImageWithURL:[NSURL URLWithString:self.imageArr.firstObject] placeholderImage:_imagePlaceholder options:SDWebImageProgressiveLoad];
        }else {
            _middleImg.image = [UIImage imageNamed:self.imageArr.firstObject];
        }
        if ([self.imageArr[1] hasPrefix:@"http"]) {
            [_rightImg sd_setImageWithURL:[NSURL URLWithString:self.imageArr[1]] placeholderImage:_imagePlaceholder options:SDWebImageProgressiveLoad];
        }else {
            _rightImg.image = [UIImage imageNamed:self.imageArr[1]];
        }
    }
}
- (void)openCarouselWithTimeInterval:(NSInteger)timeInterval
{
    if (self.imageArr.count > 0) {
        _timeInterval = timeInterval;
        [self.timer invalidate];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(pageChangeWithTimer) userInfo:nil repeats:YES];
        _isStartTimer = YES;
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self loadImageForScrollViewWithFrame:self.frame];
    }
}

- (void)closeCarousel
{
    [_timer invalidate];
    _timer = nil;
    _isStartTimer = NO;
    _timeInterval = 0;
}

//时刻监听方向的改变,给方向属性赋值
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetX = scrollView.contentOffset.x;
    self.direction = offsetX > CGRectGetWidth(self.frame) ? 1 : offsetX < CGRectGetWidth(self.frame) ? 2 : 0;
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if (self.imageArr.count == 0) return;//防止数组为空
    NSInteger direction = [change[NSKeyValueChangeNewKey] integerValue];
    if (direction == 0) return;
    NSInteger rightIndex = (_currentIndex+1)% self.imageArr.count;//判断索引合法
    NSInteger leftIndex = (_currentIndex-1)<0 ? self.imageArr.count-1 : _currentIndex-1;//判断索引合法
    if ([self.imageArr[leftIndex] hasPrefix:@"http"]) {
        [_leftImg sd_setImageWithURL:[NSURL URLWithString:self.imageArr[leftIndex]] placeholderImage:_imagePlaceholder options:SDWebImageProgressiveLoad];
    }else {
        _leftImg.image = [UIImage imageNamed:self.imageArr[leftIndex]];
    }
    if ([self.imageArr[rightIndex] hasPrefix:@"http"]) {
        [_rightImg sd_setImageWithURL:[NSURL URLWithString:self.imageArr[rightIndex]] placeholderImage:_imagePlaceholder options:SDWebImageProgressiveLoad];
    }else {
        _rightImg.image = [UIImage imageNamed:self.imageArr[rightIndex]];
    }
}
#pragma mark UIScrollViewDelegate
- (void)pageChange
{
    if (self.imageArr.count == 0) return;//防止数组为空
    if (self.direction == 0) return;//无滑动直接返回
    else if (self.direction == 1) _currentIndex = (_currentIndex+1)%self.imageArr.count;//改变当前索引,并判断索引合法
    else if (self.direction == 2) _currentIndex = (_currentIndex-1)<0 ? self.imageArr.count-1 : _currentIndex-1;//改变当前索引,并判断索引合法

    if ([self.imageArr[_currentIndex] hasPrefix:@"http"]) {
        [_middleImg sd_setImageWithURL:[NSURL URLWithString:self.imageArr[_currentIndex]] placeholderImage:_imagePlaceholder options:SDWebImageProgressiveLoad];
    }else {
        _middleImg.image = [UIImage imageNamed:self.imageArr[_currentIndex]];
    }
    self.contentOffset = CGPointMake(CGRectGetWidth(self.frame), 0);//再次设置偏移
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self pageChange];
    _index = _currentIndex;
    if ([self.actionDelegate respondsToSelector:@selector(didScroll:index:)]) {
        [self.actionDelegate didScroll:self index:_currentIndex];
    }
    if (_isStartTimer) {
        [self.timer invalidate];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:_timeInterval target:self selector:@selector(pageChangeWithTimer) userInfo:nil repeats:YES];
    }
}
//NSTimer control
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.timer invalidate];
}
//NSTimer event
- (void)pageChangeWithTimer
{
    CGFloat offsetX = self.contentOffset.x + CGRectGetWidth(self.frame);
    [self setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    [self pageChange];
    _index = (_currentIndex+1)%self.imageArr.count;
    if ([self.actionDelegate respondsToSelector:@selector(didScroll:index:)]) {
        [self.actionDelegate didScroll:self index:(_currentIndex+1)%self.imageArr.count];
    }
}
//刷新数据
- (void)reloadData
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _currentIndex = 0;
    _index = 0;
    if ([self.actionDelegate respondsToSelector:@selector(didScroll:index:)]) {
        [self.actionDelegate didScroll:self index:_currentIndex];
    }
    [self.timer invalidate];
    if (_isStartTimer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:_timeInterval target:self selector:@selector(pageChangeWithTimer) userInfo:nil repeats:YES];
    }
    [self loadImageForScrollViewWithFrame:self.frame];
}

//结束程序后,销毁 KVO 监听与定时器
- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"direction" context:nil];
    [self.timer invalidate];
}

@end
