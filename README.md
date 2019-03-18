# GuideMask

[![CI Status](https://img.shields.io/travis/muzipiao/GuideMask.svg?style=flat)](https://travis-ci.org/muzipiao/GuideMask)
[![Version](https://img.shields.io/cocoapods/v/GuideMask.svg?style=flat)](https://cocoapods.org/pods/GuideMask)
[![License](https://img.shields.io/cocoapods/l/GuideMask.svg?style=flat)](https://cocoapods.org/pods/GuideMask)
[![Platform](https://img.shields.io/cocoapods/p/GuideMask.svg?style=flat)](https://cocoapods.org/pods/GuideMask)

`GuideMask ` 可快速添加新功能提示，只需传入相应的 View 和新功能小图片名称即可。

> 当 App 更新版本，增加新功能时，往往会在进入相应界面时，高亮显示`新功能`，提示用户；通常做法是由 UI 做出全屏的图片，全屏放置在 View 上面。
> 
> 这样的缺点是移除图片时，图片上面高亮的部分往往和移除后实际的不一致；全屏图片想要高清，压缩后也有上百 KB，如果新功能提示较多，App 安装包体积会明显增大。
> 
> 观察发现，后面蒙版除了高亮位置不一样外，其他大同小异，我们可以通过代码生成蒙版。因此只需放入提示的`小图片`即可，这样高亮的位置准确，图片体积也减少很多。

[![](https://raw.githubusercontent.com/muzipiao/GitHubImages/master/GuideMaskImages/GuideMaskImages_Small/guidemask0.png)](https://raw.githubusercontent.com/muzipiao/GitHubImages/master/GuideMaskImages/GuideMaskImages_Big/guidemask0.png)
[![](https://raw.githubusercontent.com/muzipiao/GitHubImages/master/GuideMaskImages/GuideMaskImages_Small/guidemask1.png)](https://raw.githubusercontent.com/muzipiao/GitHubImages/master/GuideMaskImages/GuideMaskImages_Big/guidemask1.png)
[![](https://raw.githubusercontent.com/muzipiao/GitHubImages/master/GuideMaskImages/GuideMaskImages_Small/guidemask2.png)](https://raw.githubusercontent.com/muzipiao/GitHubImages/master/GuideMaskImages/GuideMaskImages_Big/guidemask2.png)
[![](https://raw.githubusercontent.com/muzipiao/GitHubImages/master/GuideMaskImages/GuideMaskImages_Small/guidemask3.png)](https://raw.githubusercontent.com/muzipiao/GitHubImages/master/GuideMaskImages/GuideMaskImages_Big/guidemask3.png)
[![](https://raw.githubusercontent.com/muzipiao/GitHubImages/master/GuideMaskImages/GuideMaskImages_Small/guidemask4.png)](https://raw.githubusercontent.com/muzipiao/GitHubImages/master/GuideMaskImages/GuideMaskImages_Big/guidemask4.png)

**NOTE:** 点击上面的小图片可查看高清大图。

## 环境需求

`GuideMask ` 工作环境为 iOS 7+  和 ARC 编译环境，并包含以下 iOS 官方类库:

* Foundation.framework
* UIKit.framework

开发默认包含以上这两个类库

`GuideMask ` Demo 编译环境为 Xcode 10.1

## 添加 GuideMask 至你的项目

### CocoaPods

[CocoaPods](http://cocoapods.org) 是集成`GuideMask `最简单的方式。

1. 编辑 Podfile 文件，增加行 `pod 'GuideMask'`。
2. 未安装 CocoaPods，命令行输入 `pod install`安装。
3. 使用时导入头文件 `#import "GuideMask.h"`即可。

### 源文件直接拖入方式

直接将 `GuideMask.h` 和 `GuideMask.m` 源文件拖入项目，在需要的地方导入头文件`#import "GuideMask.h"`即可。

## 用法

`GuideMask`默认为单例，灰黑色半透明背景，提示图片展示在待提示功能下方。

假设提示图片依次命名为 arrow0，arrow1，arrow2，arrow3...

```objective-c
#import "GuideMask.h"

//创建提示
GuideMask *mask = [GuideMask shareGuide];
//将待提示的View和提示小图片名称导入
[mask addGuideViews:@[self.richTextBtn,self.dateBtn,self.refreshBtn,self.fmdbBtn] imagePrefixName:@"arrow"];
```

当然你可以自定义背景颜色和透明度，和每张图片的位置，位置分为上，下，左，右，左上，左下，右上，右下，中心对齐，图片全屏覆盖手机等几种，能满足大部分需求。

```objective-c
//-------------------------可选----------------
//指定位置，默认在正下方
mask.tipImageLocation = @[@(GuideMaskPositionUp),@(GuideMaskPositionDown),@(GuideMaskPositionLeft),@(GuideMaskPositionRight),@(GuideMaskPositionLeftUp),@(GuideMaskPositionRightUp),@(GuideMaskPositionLeftDown),@(GuideMaskPositionRightDown)];
/**
* 某个位置微调；@{@"位置0,1,2..":@"{水平偏移,竖直偏移}"}
* 以数组元素索引为key，UIOffset(horizontal, vertical)为偏移量
* eg:@{@"2":@"{10,-5}"}表示第3张提示图片水平方向向右偏移10，竖直防线向上偏移5
*/
mask.offsetDict = @{@"0":@"{0,-5}",@"1":@"{-40,0}", @"2":@"{0,20}", @"3":@"{0,8}"};
//背景色
mask.bgColor = [UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:0.7];
```

## 许可

OOB在MIT许可下可用。有关详细信息，请参阅LICENSE文件。


如果您觉得有所帮助，请在[GitHub GuideMaskDemo](https://github.com/muzipiao/GuideMask)上赏个Star ⭐️，您的鼓励是我前进的动力
