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
@property (nonatomic, strong) NSArray *completeColors;///< 一整个循环颜色数组
@property (nonatomic, assign) NSInteger startIndex;///< 当前取色数组起始位置
@end

// 帧数
static NSInteger frames = 60;

@implementation MJGradientFlashingView
#pragma mark - Life Circle
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    if (_autoStart) {
        self.colors = @[self.beginColor, self.endColor];
        [self startAnimation];
    }
}

- (void)dealloc
{
    [self.displaylink invalidate];
    [self.displaylink removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

/// 创建计时器
- (CADisplayLink *)createDisplaylink
{
    CADisplayLink *displaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(startFlash)];
    // 每秒帧数
    if (@available(iOS 10.0, *)) {
        displaylink.preferredFramesPerSecond = frames;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        displaylink.frameInterval = frames;
#pragma clang diagnostic pop
    }
    return displaylink;
}

#pragma mark - Set & Get
- (void)setColors:(NSArray<UIColor *> *)colors
{
    _colors = colors;
    [self configCompleteColors];
}

- (void)setSpeed:(CGFloat)speed
{
    _speed = speed;
    [self configCompleteColors];
}

/// 计算一整个循环需要的颜色数组
- (void)configCompleteColors
{
    if (_colors.count > 1 && _speed != 0) {
        /*
         计算一整个循环需要的颜色数组
         这里是是因为:
         如果及时计算每个时刻需要的颜色，会根据每个颜色的地址算位置，如果有相同地址的颜色传入，那么会计算错误，
         所以提前算好一整个颜色循环数组，直接从数组中取颜色，而不用及时计算
         */
        NSMutableArray *arrCompelet = [NSMutableArray arrayWithCapacity:_colors.count * 3];
        if (_speed < 0) {
            // 头
            [arrCompelet addObject:_colors[1]];
        }
        // 正序完整数组
        [arrCompelet addObjectsFromArray:_colors];
        // 逆序去头尾数组
        NSMutableArray *arrReverse = [_colors.reverseObjectEnumerator.allObjects mutableCopy];
        [arrReverse removeObjectAtIndex:0];
        [arrReverse removeLastObject];
        [arrCompelet addObjectsFromArray:arrReverse];
        // 正序完整数组
        [arrCompelet addObjectsFromArray:_colors];
        if (_speed > 0) {
            // 尾
            [arrCompelet addObject:_colors[_colors.count - 2]];
        }
        
        if (_speed < 0) {
            _completeColors = [arrCompelet copy];
        } else {
            _completeColors = [arrCompelet.reverseObjectEnumerator.allObjects copy];
        }
    }
}

#pragma mark - Animation
/// 开始动画
- (void)startAnimation
{
    if (_displaylink) {
        [_displaylink setPaused:NO];
    } else {
        _displaylink = [self createDisplaylink];
        [_displaylink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
}

/// 结束动画
- (void)endAnimation
{
    [_displaylink setPaused:YES];
}

#pragma mark - Action
/// 每帧动画
- (void)startFlash
{
    if (_colors.count < 2) {
        return;
    }
    
    CGFloat offset = _speed / frames;   // 每帧偏移量
    CGFloat space = 1.0 / (_colors.count - 1); // 每个颜色的间距
    
    NSInteger arrCount = _colors.count + 2; // 颜色数组长度
    CGFloat firstPoint = 0.0;  // 起始位置
    
    if (self.arrColors.count > 0) {
        // 动画中
        firstPoint = [self.arrLocations[1] doubleValue];
        
        if (fabs(firstPoint) > space) {
            // 移动后超出范围
            firstPoint += space * (_speed > 0? -1: 1);
            
            // 颜色数组
            _startIndex += 1;
            if (_startIndex + arrCount > _completeColors.count) {
                _startIndex = 0;
            }
            
            NSArray *subArr = [_completeColors subarrayWithRange:NSMakeRange(_startIndex, arrCount)];
            self.arrColors = _speed < 0? subArr: subArr.reverseObjectEnumerator.allObjects;
        } else {
            firstPoint += offset;
        }
    } else {
        // 初始
        NSArray *subArr = [_completeColors subarrayWithRange:NSMakeRange(_startIndex, arrCount)];
        self.arrColors = _speed < 0? subArr: subArr.reverseObjectEnumerator.allObjects;
    }

    // 颜色对应位置
    NSMutableArray *muPoints = [NSMutableArray arrayWithCapacity:arrCount];
    for (NSInteger i = 0; i < arrCount; i++) {
        [muPoints addObject:[NSNumber numberWithFloat:firstPoint + (i - 1) * space]];
    }
    self.arrLocations = muPoints;
    
    [self configColors];
}

@end
