//
//  MJGradientFlashingView.m
//  MJGradientFlashingView
//
//  Created by 刘鹏i on 2018/12/26.
//  Copyright © 2018 wuhan.musjoy. All rights reserved.
//

#import "MJGradientFlashingView.h"

@interface MJGradientFlashingView ()
@property (nonatomic, strong) CADisplayLink *displaylink;///< 计时器
@end

@implementation MJGradientFlashingView
#pragma mark - Life Circle
- (void)dealloc
{
    [self.displaylink invalidate];
    [self.displaylink removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

#pragma mark - Set & Get
/// 计时器
- (CADisplayLink *)displaylink
{
    if (_displaylink == nil) {
        _displaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(startFlash)];
        // 每秒30帧
        if (@available(iOS 10.0, *)) {
            _displaylink.preferredFramesPerSecond = 30;
        } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            _displaylink.frameInterval = 30;
#pragma clang diagnostic pop
        }
    }
    return _displaylink;
}

#pragma mark - Animation
/// 开始动画
- (void)startAnimation
{
    if (_displaylink) {
        [self.displaylink setPaused:NO];
    } else {
        [self.displaylink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
}

/// 结束动画
- (void)endAnimation
{
    [self.displaylink setPaused:YES];
}

#pragma mark - Action
- (void)startFlash
{
    CGFloat offset = _speed / 30.0;   // 30为上面计时器的帧数
    
    NSArray *colors = nil;// 颜色数组
    
    CGFloat centerPoint = 0.0;  // 可视范围颜色位置
    
    if (self.arrColors.count > 1) {
        // 动画中
        UIColor *colorOut = self.arrColors[0];
        UIColor *colorIn = self.arrColors[1];
        centerPoint = [self.arrLocations[1] floatValue];
        
        centerPoint += offset;
        
        if (centerPoint > 1) {
            centerPoint -= 1;
            colors = @[colorIn, colorOut, colorIn];
        } else if (centerPoint < 0) {
            centerPoint += 1;
            colors = @[colorIn, colorOut, colorIn];
        } else {
            colors = self.arrColors;
        }
    } else {
        // 初始
        colors = @[self.endColor, self.beginColor, self.endColor];
        centerPoint = 0.5;
    }
    
    self.arrColors = colors;
    
    self.arrLocations = @[@(centerPoint - 1),
                          @(centerPoint),
                          @(centerPoint + 1)];
    
    [self configColors];
}

@end
