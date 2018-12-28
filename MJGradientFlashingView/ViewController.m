//
//  ViewController.m
//  MJGradientFlashingView
//
//  Created by 刘鹏i on 2018/12/26.
//  Copyright © 2018 wuhan.musjoy. All rights reserved.
//

#import "ViewController.h"
#import "MJGradientFlashingView.h"
#import "UIColor+Utils.h"

@interface ViewController ()
@property (nonatomic, strong) IBOutlet MJGradientFlashingView *flashView;
@property (nonatomic, strong) IBOutlet MJGradientFlashingView *flashView2;
@property (nonatomic, strong) IBOutlet MJGradientFlashingView *flashView3;

@property (nonatomic, strong) IBOutlet UILabel *lable;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 向右
    _flashView.colors = @[[UIColor colorFromHexRGB:@"2D87FF"],
                          [UIColor colorFromHexRGB:@"E14B91"]];

    _flashView.speed = 1;

    [_flashView startAnimation];

    
    // 向左
    _flashView2.colors = @[[UIColor blackColor],
                           [UIColor greenColor],
                           [UIColor yellowColor],
                           [UIColor whiteColor]];
    _flashView2.speed = -1;

    [_flashView2 startAnimation];
    
    
    // 闪光
    UIColor *color1 = [UIColor clearColor];
    UIColor *color2 = [UIColor whiteColor];
    _flashView3.colors = @[color1,
                           color2,
                           color1,
                           color2,
                           color1,
                           color2];
    _flashView3.speed = 0.5;
    _lable.layer.mask = _flashView3.layer;
    
    [_flashView3 startAnimation];
}


@end
