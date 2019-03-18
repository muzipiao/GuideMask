//
//  LFViewController.m
//  GuideMask
//
//  Created by lifei on 03/18/2019.
//  Copyright (c) 2019 lifei. All rights reserved.
//

#import "LFViewController.h"
#import "GuideMask.h"

@interface LFViewController ()

//是否是更新了版本
@property (nonatomic, assign) BOOL isNewVersion;

@end

@implementation LFViewController

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
        btn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width * 0.5 - 50, 100 + i * 50, 100, 60);
        [btn sizeToFit];
        [marr addObject:btn];
    }
    
    //判断是否是新版本
    if (YES) {
        //创建提示
        GuideMask *tipView = [GuideMask shareGuide];
        //待提示的数组放入数组中，并把图片名称前缀传入
        [tipView addGuideViews:marr.copy imagePrefixName:@"arrow"];
        
        //-------------------------下方可选----------------
        //指定位置，默认在正下方
        tipView.tipImageLocation = @[@(GuideMaskPositionUp),@(GuideMaskPositionDown),@(GuideMaskPositionLeft),@(GuideMaskPositionRight),@(GuideMaskPositionLeftUp),@(GuideMaskPositionRightUp),@(GuideMaskPositionLeftDown),@(GuideMaskPositionRightDown)];
        
        /*
         * 设置偏移量UIOffset(horizontal, vertical)
         * 第0个向上偏移5
         * 第1个向左偏移40
         * 第2个向下偏移20
         * 第3个向下偏移8
         */
        tipView.offsetDict = @{@"0":@"{0,-5}",@"1":@"{-40,0}", @"2":@"{0,20}", @"3":@"{0,8}"};
        
        //背景色
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
