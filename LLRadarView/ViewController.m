//
//  ViewController.m
//  LLRadarView
//
//  Created by 雷亮 on 16/8/31.
//  Copyright © 2016年 Leiliang. All rights reserved.
//

#import "ViewController.h"
#import "LLRadarView.h"

@interface ViewController ()

@property (nonatomic, strong) LLRadarView *radarView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.radarView = [[LLRadarView alloc] initWithFrame:CGRectMake(50, 100, 200, 200)];
    _radarView.showCrossline = YES;
    _radarView.needOpacityAnimation = YES;
    [self.view addSubview:_radarView];    
}

- (IBAction)startAnimation:(id)sender {
    [_radarView startAnimation];
}

- (IBAction)stopAnimation:(id)sender {
    [_radarView stopAnimation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
