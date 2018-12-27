//
//  ViewController.m
//  MJGradientFlashingView
//
//  Created by 刘鹏i on 2018/12/26.
//  Copyright © 2018 wuhan.musjoy. All rights reserved.
//

#import "ViewController.h"
#import "MJGradientFlashingView.h"

@interface ViewController ()
@property (nonatomic, strong) IBOutlet MJGradientFlashingView *flashView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [_flashView startAnimation];
}


@end
