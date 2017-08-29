//
//  ViewController.m
//  GuideMaskView
//
//  Created by PacteraLF on 2017/8/28.
//  Copyright © 2017年 PacteraLF. All rights reserved.
//

#import "ViewController.h"
#import "GuideMask.h"

@interface ViewController ()

//是否是更新了版本
@property (nonatomic, assign) BOOL isNewVersion;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //读取App配置
    [self readAppConfig];
    
    [self createUI];
}

-(void)createUI{
    self.title = @"主页";
    self.view.backgroundColor = [UIColor whiteColor];
    NSMutableArray <UIButton *>*marr = [NSMutableArray arrayWithCapacity:10];
    for (NSInteger i = 0; i < 10; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [btn setTitle:@"133218908908111" forState:UIControlStateNormal];
        [self.view addSubview:btn];
        btn.frame = CGRectMake(120, 80 + i * 60, 100, 60);
        [btn sizeToFit];
        [marr addObject:btn];
    }
    
    if (self.isNewVersion) {
        GuideMask *tipView = [GuideMask shareGuide];
        [tipView addGuideViews:marr.copy imagePrefixName:@"tipImage"];
        
        tipView.tipImageLocation = @[@(GuideMaskPositionUp),@(GuideMaskPositionDown),@(GuideMaskPositionLeft),@(GuideMaskPositionRight),@(GuideMaskPositionLeftDown),@(GuideMaskPositionLeftUp),@(GuideMaskPositionRightUp),@(GuideMaskPositionRightDown)];
        
        tipView.bgColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    }
    
}

-(void)readAppConfig{
    //读取旧版本
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *oldVersion = [userDefaults stringForKey:@"kApp_Version"];
    
    //读取新版本
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    //如果是新版本
    if (![oldVersion isEqualToString:app_Version]) {
        self.isNewVersion = YES;
        [userDefaults setObject:app_Version forKey:@"kApp_Version"];
    }else{
        self.isNewVersion = NO;
    }
}


@end
