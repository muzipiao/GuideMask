//
//  GuideMaskTests.m
//  GuideMaskTests
//
//  Created by lifei on 03/18/2019.
//  Copyright (c) 2019 lifei. All rights reserved.
//

@import XCTest;
#import "GuideMask.h"

@interface Tests : XCTestCase

@property (nonatomic, strong) GuideMask *guideMask;

// 被提示的视图数组
@property (nonatomic, strong) NSArray *testViewArray;

@end

@implementation Tests

- (void)setUp
{
    [super setUp];
    self.guideMask = [GuideMask shareGuide];
    
    // 创建待提示的视图
    UIViewController *rootViewController = UIApplication.sharedApplication.keyWindow.rootViewController;
    UIView *rootView = rootViewController.view;
    
    UIButton *testView1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [testView1 setTitle:@"待测按钮1" forState:UIControlStateNormal];
    [testView1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rootView addSubview:testView1];
    testView1.frame = CGRectMake(150, 200, 100, 100);
    [testView1 sizeToFit];
    
    UIImageView *testView2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tipImage7"]];
    [rootView addSubview:testView2];
    testView2.frame = CGRectMake(150, 300, 100, 100);
    [testView2 sizeToFit];
    
    self.testViewArray = @[testView1, testView2];
}

- (void)tearDown
{
    self.guideMask = nil;
    // 移除子视图
    UIViewController *rootViewController = UIApplication.sharedApplication.keyWindow.rootViewController;
    UIView *rootView = rootViewController.view;
    for (UIView *tempView in rootView.subviews) {
        if ([self.testViewArray containsObject:tempView]) {
            [tempView removeFromSuperview];
        }
    }
    self.testViewArray = nil;
    [super tearDown];
}

-(void)testInitializers{
    // singleton
    GuideMask *newObj = [GuideMask shareGuide];
    XCTAssertNotNil(newObj, @"GuideMask singleton object should be created success.");
    XCTAssertEqual(newObj, self.guideMask,@"GuideMask should be singleton.");
    
    UIViewController *rootViewController = UIApplication.sharedApplication.keyWindow.rootViewController;
    UIView *rootView = rootViewController.view;
    for (UIView *subView in self.testViewArray) {
        XCTAssertEqual(rootView, subView.superview, @"SubView'superview should be rootView.");
    }
}

-(void)testAddGuideViews{
    NSString *imagePrefixName = @"arrow";
    [self.guideMask addGuideViews:self.testViewArray imagePrefixName:imagePrefixName];
    // KVC 读取私有属性
    UIView *bgView = [self.guideMask valueForKey:@"bgView"]; // 背景容器
    // 背景图片，默认为半透明灰黑色
    UIImageView *bgImageView = [self.guideMask valueForKey:@"bgImageView"];
    UIImageView *tipImageView = [self.guideMask valueForKey:@"tipImageView"]; // 提示图片
    // 提示图片的名称前缀
    NSString *tipImagePrefixName = [self.guideMask valueForKey:@"tipImagePrefixName"];
    // 当前提示的索引，例如0为第一个提示
    NSInteger currentIndex = [[self.guideMask valueForKey:@"currentIndex"] integerValue];
    // 当前被指引的视图数组
    NSArray *beGuidedViewsArray = [self.guideMask valueForKey:@"beGuidedViewsArray"];
    
    XCTAssertEqual(bgImageView.alpha, 1.f, @"The bgImageView should be visible.");
    XCTAssertEqual(tipImageView.alpha, 1.f, @"The tipImageView should be visible.");
    
    UIWindow *keyWin = [UIApplication sharedApplication].delegate.window;
    
    XCTAssertTrue(CGRectEqualToRect(bgView.frame, [UIScreen mainScreen].bounds), @"BgView should be full screen.");
    XCTAssertEqual(keyWin, bgView.superview, @"The parent view of BgView should be key window.");
    XCTAssertEqual(beGuidedViewsArray, self.testViewArray, @"The array of views being prompted should be the same.");
    XCTAssertTrue([tipImagePrefixName isEqualToString:imagePrefixName], @"The picture name prefix should be the same.");
    XCTAssertTrue(currentIndex==0, @"The index should start at 0.");
    XCTAssertTrue(bgImageView.userInteractionEnabled==YES,@"The user interaction of bgImageView should be enabled.");
    NSData *indexOneImgData = UIImagePNGRepresentation([UIImage imageNamed:[NSString stringWithFormat:@"%@0",imagePrefixName]]);
    NSData *imageViewImgData = UIImagePNGRepresentation(tipImageView.image);
    BOOL isSameImg = [indexOneImgData isEqualToData:imageViewImgData];
    XCTAssertTrue(isSameImg, @"Image data should be the same.");
    
    self.guideMask.tipImageLocation = @[@(GuideMaskPositionLeft),@(GuideMaskPositionRight)];
    UIView *firstTipView = self.testViewArray[0];
    CGFloat ftX = firstTipView.frame.origin.x;
    CGFloat guideMaskMargin = 5;
    CGFloat calX = tipImageView.frame.origin.x + guideMaskMargin + tipImageView.frame.size.width;
    XCTAssertEqual(ftX, calX, @"The location of the prompt image should be 5.");
    
    CGPoint tipImgOrigin = tipImageView.frame.origin;
    self.guideMask.offsetDict = @{@"0":@"{0,-10}",@"1":@"{-40,0}"};
    XCTAssertEqual(tipImgOrigin.y - 10 + guideMaskMargin, tipImageView.frame.origin.y, @"The offset setting should be accurate.");
}

@end

