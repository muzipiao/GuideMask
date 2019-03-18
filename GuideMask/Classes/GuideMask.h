//
//  GuideMask.h
//  GuideMaskView
//
//  Created by PacteraLF on 2017/8/29.
//  Copyright © 2017年 PacteraLF. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GuideMaskPosition) {
    /// 上
    GuideMaskPositionUp,
    /// 下
    GuideMaskPositionDown,
    /// 左
    GuideMaskPositionLeft,
    /// 右
    GuideMaskPositionRight,
    /// 左上
    GuideMaskPositionLeftUp,
    /// 左下
    GuideMaskPositionLeftDown,
    /// 右上
    GuideMaskPositionRightUp,
    /// 右下
    GuideMaskPositionRightDown,
    /// 中心对齐
    GuideMaskPositionCenter,
    /// 全屏覆盖
    GuideMaskPositionFullScreen
};

@interface GuideMask : NSObject

//定义为单例
+(instancetype)shareGuide;

/**
 创建遮罩提示层
 @param beGuidedViews 数组存入需要高亮的控件
 @param prefixName 提示图片的前缀，例如preName0前缀为preName,图片按照此格式命名
 */
-(void)addGuideViews:(NSArray<UIView *> *)beGuidedViews imagePrefixName:(NSString *)prefixName;


//-----------以下根据需要设置-------------
//背景色，默认为黑色，几乎透明(Alpha=0.1)的背景色
@property (nonatomic, strong) UIColor *bgColor;

//提示图片的位置数组，放入枚举例如@[@(GuideMaskPositionUp),@(GuideMaskPositionDown)]
@property (nonatomic, strong) NSArray<NSNumber *> *tipImageLocation;

/**
 * 某个位置微调；@{@"位置0,1,2..":@"{水平偏移,竖直偏移}"}
 * 以数组元素索引为key，UIOffset(horizontal, vertical)为偏移量
 * eg:@{@"2":@"{10,-5}"}表示第3张提示图片水平方向向右偏移10，竖直防线向上偏移5
 */
@property (nonatomic, strong) NSDictionary<NSString *,NSString *> *offsetDict;

//凸显提示位置方框的切圆角半径，不设置默认是5
@property (nonatomic, assign) CGFloat rectRadius;

@end
