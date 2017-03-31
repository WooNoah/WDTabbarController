//
//  WDTabbarController.h
//  testTabbarController
//
//  Created by tb on 17/3/30.
//  Copyright © 2017年 com.tb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDTabbarSubController.h"

static const NSInteger ButtonTagOffset = 4422;
static const NSInteger LabelTagOffset  = 2244;

@interface WDTabbarController : UIViewController

//头视图 图标上的文字
@property (nonatomic,strong) NSArray *innerTitles;

//头视图上 各项的标题
@property (nonatomic,strong) NSArray *titles;

//附加的子类
@property (nonatomic,strong) NSArray *viewControllers;

//渲染颜色
@property (nonatomic,strong) UIColor *barTintColor;

//选择的页面
@property (nonatomic,weak) UIViewController *selectedViewController;

//选择的坐标索引
@property (nonatomic,assign) NSUInteger selectedIndex;

//能选择的最大坐标
@property (nonatomic,assign) NSUInteger maxIndex;

//进度条
@property (nonatomic,strong) UIView *indicateView;

/* 改变对应按钮的状态*/
- (void)changeIntoCompleteStatusWithButtonIndex:(NSUInteger)idx;


@end
