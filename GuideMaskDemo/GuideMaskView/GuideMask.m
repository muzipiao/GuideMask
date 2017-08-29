//
//  GuideMask.m
//  GuideMaskView
//
//  Created by PacteraLF on 2017/8/29.
//  Copyright © 2017年 PacteraLF. All rights reserved.
//

#import "GuideMask.h"

#define GuideMaskMargin 5

@interface GuideMask ()

//背景容器
@property (nonatomic, strong) UIView *bgView;

//背景图片，默认为半透明灰黑色
@property (nonatomic, strong) UIImageView *bgImageView;

//提示图片
@property (nonatomic, strong) UIImageView *tipImageView;

//提示图片的名称前缀
@property (nonatomic, copy) NSString *tipImagePrefixName;

//当前提示的索引，例如0为第一个提示
@property (nonatomic, assign) NSInteger currentIndex;

//当前被指引的数组
@property (nonatomic, strong) NSArray <UIView *>*beGuidedViewsArray;

@end

@implementation GuideMask

static GuideMask *instance;

+ (instancetype)shareGuide
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //全屏
        instance = [[GuideMask alloc] init];
        
        UIView *bView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        instance.bgView = bView;
        
        //添加背景遮罩图层
        UIImageView *maskImageView = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [bView addSubview:maskImageView];
        
        //添加提示图片
        UIImageView *tipImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [bView addSubview:tipImageView];
        
        instance.bgImageView = maskImageView;
        instance.tipImageView = tipImageView;
        instance.currentIndex = 0;
    });
    
    return instance;
}

-(void)addGuideViews:(NSArray *)beGuidedViews imagePrefixName:(NSString *)prefixName{
    if(beGuidedViews.count == 0)return;
    //添加到视图
    [[UIApplication sharedApplication].delegate.window addSubview:self.bgView];
    self.beGuidedViewsArray = beGuidedViews;
    self.tipImagePrefixName = prefixName;
    //更换背景和提示图片
    [self changeTips];
}

#pragma mark - 更换背景和提示图片
-(void)changeTips{
    if(self.currentIndex >= self.beGuidedViewsArray.count){
        [self.bgView removeFromSuperview];
        return;
    }
    
    UIView *tempView = (UIView *)self.beGuidedViewsArray[self.currentIndex];
    //坐标转换,以提示控件的坐标原点为原点，且和提示控件一样大小（bounds）的图案在window中的位置
    CGRect rect = [tempView convertRect:tempView.bounds toView:[UIApplication sharedApplication].delegate.window];
    
    //获取遮罩图形
    UIImage *maskImg = [self imageWithTipRect:rect tipRectRadius:GuideMaskMargin];
    //获取提示图片
    NSString *imgName = [NSString stringWithFormat:@"%@%d",self.tipImagePrefixName,(int)self.currentIndex];
    UIImage *tipImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imgName ofType:@"png"]];
    if (tipImg == nil) {
        tipImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imgName ofType:@"PNG"]];
    }
    
    //设置遮罩图形
    self.bgImageView.image = maskImg;
    //设置提示图片
    self.tipImageView.image = tipImg;
    
    if (tipImg != nil) {
        //提示图片位置，可根据图片尺寸计算，与提示框居中对齐
        CGFloat scale = [UIScreen mainScreen].scale;
        CGFloat tipW = tipImg.size.width / scale;
        CGFloat tipH = tipImg.size.height / scale;
        //中心对齐
        CGFloat tipX = rect.origin.x + (rect.size.width - tipW) * 0.5;
        CGFloat tipY = rect.origin.y + rect.size.height + GuideMaskMargin;
        //如果设置了自定义位置，就按照设定的位置
        if (self.tipImageLocation.count > 0) {
            [self changeTipImageViewLocation:CGRectMake(tipX, tipY, tipW, tipH) guideRect:rect];
        }else{
            //默认在下方
            self.tipImageView.frame = [self checkOverEdge:CGRectMake(tipX, tipY, tipW, tipH)];
        }
    }else{
        self.tipImageView.frame = CGRectZero;
    }
    
    //给遮罩图层添加点击动作
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    //给遮罩添加手势，点击切换
    self.bgImageView.userInteractionEnabled = YES;
    [self.bgImageView addGestureRecognizer:tapGesture];
}

//越界检查
-(CGRect)checkOverEdge:(CGRect)orginRect{
    CGFloat GuideScreenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat GuideScreenH = [UIScreen mainScreen].bounds.size.height;
    
    CGFloat tipW = orginRect.size.width;
    CGFloat tipH = orginRect.size.height;
    CGFloat tipX = orginRect.origin.x;
    CGFloat tipY = orginRect.origin.y;
    //越界计算
    tipX = tipX < 0 ? 0 : tipX;
    tipX = tipX + tipW > GuideScreenW ? GuideScreenW - tipW : tipX;
    tipY = tipY < 0 ? 0 : tipY;
    tipY = tipY + tipH > GuideScreenH ? GuideScreenH - tipH : tipY;
    
    return CGRectMake(tipX, tipY, tipW, tipH);
}


/**
 改变提示图片的位置

 @param tipRect 提示图片位置
 @param guideRect 被提示的位置
 */
-(void)changeTipImageViewLocation:(CGRect)tipRect guideRect:(CGRect)guideRect{
    if(self.currentIndex >= self.tipImageLocation.count) return;
    GuideMaskPosition currentP = [self.tipImageLocation[self.currentIndex] integerValue];
    switch (currentP) {
        case GuideMaskPositionUp:{
            tipRect.origin.y = guideRect.origin.y - tipRect.size.height - GuideMaskMargin;
            self.tipImageView.frame = [self checkOverEdge:tipRect];
        }
            break;
        case GuideMaskPositionDown:{
            self.tipImageView.frame = [self checkOverEdge:tipRect];
        }
            break;
        case GuideMaskPositionLeft:{
            tipRect.origin.y = guideRect.origin.y + (guideRect.size.height - tipRect.size.height) * 0.5;
            tipRect.origin.x = guideRect.origin.x - tipRect.size.width - GuideMaskMargin;
            self.tipImageView.frame = [self checkOverEdge:tipRect];
        }
            break;
        case GuideMaskPositionRight:{
            tipRect.origin.y = guideRect.origin.y + (guideRect.size.height - tipRect.size.height) * 0.5;
            tipRect.origin.x = guideRect.origin.x +guideRect.size.width + GuideMaskMargin;
            self.tipImageView.frame = [self checkOverEdge:tipRect];
        }
            break;
        case GuideMaskPositionLeftUp:{
            tipRect.origin.y = guideRect.origin.y - tipRect.size.height - GuideMaskMargin;
            tipRect.origin.x = guideRect.origin.x + guideRect.size.width * 0.5 - tipRect.size.width;
            self.tipImageView.frame = [self checkOverEdge:tipRect];
        }
            break;
        case GuideMaskPositionLeftDown:{
            tipRect.origin.x = guideRect.origin.x + guideRect.size.width * 0.5 - tipRect.size.width;
            self.tipImageView.frame = [self checkOverEdge:tipRect];
        }
            break;
        case GuideMaskPositionRightUp:{
            tipRect.origin.y = guideRect.origin.y - tipRect.size.height - GuideMaskMargin;
            tipRect.origin.x = guideRect.origin.x + guideRect.size.width * 0.5;
            self.tipImageView.frame = [self checkOverEdge:tipRect];
        }
            break;
        case GuideMaskPositionRightDown:{
            tipRect.origin.x = guideRect.origin.x + guideRect.size.width * 0.5;
            self.tipImageView.frame = [self checkOverEdge:tipRect];
        }
            break;
        default:{
            self.tipImageView.frame = [self checkOverEdge:tipRect];
        }
            break;
    }
    
}


#pragma mark - 识别遮罩图层点击手势的回调方法
- (void)tap
{
    //如果当前展示的提示未到最后一个，继续遍历
    if (self.currentIndex < self.beGuidedViewsArray.count - 1) {
        self.currentIndex += 1;
        //更换背景和提示图片
        [self changeTips];
    }else{
        [self.bgView removeFromSuperview];
    }
}

#pragma mark - 提示的遮罩背景图片
-(UIImage *)imageWithTipRect:(CGRect)tipRect tipRectRadius:(CGFloat)tipRectRadius{
    
    //开启当前的图形上下文
    UIGraphicsBeginImageContextWithOptions([UIScreen mainScreen].bounds.size, NO, 0.0);
    
    // 获取图形上下文，画板
    CGContextRef cxtRef = UIGraphicsGetCurrentContext();
    
    //将提示框增大，并保持居中显示，默认增大尺寸为切圆角的半径，需要特殊处理改下面尺寸
    CGFloat plusSize = tipRectRadius;
    CGRect tipRectPlus = CGRectMake(tipRect.origin.x - plusSize * 0.5, tipRect.origin.y - plusSize * 0.5, tipRect.size.width + plusSize, tipRect.size.height + plusSize);
    
    //绘制提示路径
    UIBezierPath *tipRectPath = [UIBezierPath bezierPathWithRoundedRect:tipRectPlus cornerRadius:tipRectRadius];
    
    //绘制蒙版
    UIBezierPath *screenPath = [UIBezierPath bezierPathWithRect:[UIScreen mainScreen].bounds];
    
    //填充色，默认为半透明，灰黑色背景
    if (self.bgColor) {
        CGContextSetFillColorWithColor(cxtRef, self.bgColor.CGColor);
    }else{
        CGContextSetFillColorWithColor(cxtRef, [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.2].CGColor);
    }
    
    //添加路径到图形上下文
    CGContextAddPath(cxtRef, tipRectPath.CGPath);
    CGContextAddPath(cxtRef, screenPath.CGPath);
    
    //渲染，选择奇偶模式
    CGContextDrawPath(cxtRef, kCGPathEOFill);
    
    //从画布总读取图形
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //关闭图形上下文
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - 重写set，防止设置顺序引起的异常
-(void)setBgColor:(UIColor *)bgColor{
    _bgColor = bgColor;
    if (self.beGuidedViewsArray.count > 0) {
        //重新生成背景
        UIView *tempView = (UIView *)self.beGuidedViewsArray[self.currentIndex];
        //坐标转换,以提示控件的坐标原点为原点，且和提示控件一样大小（bounds）的图案在window中的位置
        CGRect rect = [tempView convertRect:tempView.bounds toView:[UIApplication sharedApplication].delegate.window];
        //获取遮罩图形
        UIImage *maskImg = [self imageWithTipRect:rect tipRectRadius:GuideMaskMargin];
        self.bgImageView.image = maskImg;
    }
}

-(void)setTipImageLocation:(NSArray *)tipImageLocation{
    _tipImageLocation = tipImageLocation;
    if (self.beGuidedViewsArray.count > 0) {
        //如果设置了自定义位置，就按照设定的位置
        if (tipImageLocation.count > 0) {
            if(self.currentIndex >= tipImageLocation.count) return;
            //重新生成背景
            UIView *tempView = (UIView *)self.beGuidedViewsArray[self.currentIndex];
            //坐标转换,以提示控件的坐标原点为原点，且和提示控件一样大小（bounds）的图案在window中的位置
            CGRect rect = [tempView convertRect:tempView.bounds toView:[UIApplication sharedApplication].delegate.window];
            //重新设置一下位置
            [self changeTipImageViewLocation:self.tipImageView.frame guideRect:rect];
        }
    }
}



@end
