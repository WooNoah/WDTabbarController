//
//  WDTabbarController.m
//  testTabbarController
//
//  Created by tb on 17/3/30.
//  Copyright © 2017年 com.tb. All rights reserved.
//

#import "WDTabbarController.h"
#import <Masonry.h>

@interface WDTabbarController () <WDTabbarSubControllerDelegate>

@property (nonatomic,strong) UIView *headerView;

@property (nonatomic,strong) UIView *contentContainerView;

//进度条背景
@property (nonatomic,strong) UIView *indicateBackView;

//图片之间的间距  如果4个状态，则padding为 （屏幕总宽 - 图片宽度 * 4）/5
@property (nonatomic,assign) CGFloat padding;
//图片的宽度
@property (nonatomic,assign) CGFloat buttonWidth;

@end

@implementation WDTabbarController

- (instancetype)init {
    if (self == [super init]) {
        [self createHeaderView];
        [self createContainerView];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
 
    NSLog(@"viewDidLoad");
    self.view.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //默认选中第一个页面
    self.selectedIndex = 0;
    [self changeIntoCompleteStatusWithButtonIndex:0];
    [self selectSpecificLabelWithIndex:0];
    
    
    //进行网络请求，看用户当前状态,然后根据状态，设置相应的参数
//    [self addAnimationToIndicatorBarWithCurrentCompleteIndex:1];
//    self.maxIndex = 1;
//    self.selectedIndex = 1;
}

- (void)createHeaderView {
    NSLog(@"createHeaderView");
    self.headerView = [[UIView alloc]init];
    //750 * 170
    self.headerView.frame = CGRectMake(0, 64, self.view.bounds.size.width, WDTabbarScreenWidth * 170 / 750);
    self.headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.headerView];
}

- (void)createContainerView {
    NSLog(@"createContainerView");
    self.contentContainerView = [[UIView alloc]init];
    self.contentContainerView.frame = CGRectMake(0, 5 + 64 + WDTabbarScreenWidth * 170 / 750, WDTabbarScreenWidth, WDTabbarScreenHeight - 64 - WDTabbarScreenWidth * 170 / 750);
    self.contentContainerView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.contentContainerView];
}

- (void)setViewControllers:(NSArray <WDTabbarSubController *>*)newViewControllers {
    NSLog(@"set ViewControllers");
    NSAssert([newViewControllers count] == self.titles.count, @"传入参数有误");
    
    UIViewController *oldSelectedVC = self.selectedViewController;
    
    // Remove the old child view controllers.
    for (UIViewController *viewController in _viewControllers)
    {
        [viewController willMoveToParentViewController:nil];
        [viewController removeFromParentViewController];
    }
    
    _viewControllers = [newViewControllers copy];
    
    NSUInteger newIndex = [_viewControllers indexOfObject:oldSelectedVC];
    if (newIndex != NSNotFound)
        _selectedIndex = newIndex;
    else if (newIndex < [_viewControllers count])
        _selectedIndex = newIndex;
    else
        _selectedIndex = 0;
    
    for (WDTabbarSubController *viewController in _viewControllers)
    {
        viewController.delegate = self;
        [self addChildViewController:viewController];
        [viewController didMoveToParentViewController:self];
    }
    
    if ([self isViewLoaded])
        [self refreshTopButtons];
}

- (void)refreshTopButtons {
    NSLog(@"refreshTopButtons");
    [self removeTopButtons];
    [self addTopButtons];
}

- (void)removeTopButtons
{
    NSLog(@"removeTopButtons");
    while ([self.headerView.subviews count] > 0)
    {
        [[self.headerView.subviews lastObject] removeFromSuperview];
    }
}

- (void)addTopButtons {
    NSLog(@"addTopButtons");
    //70 * 70
    self.padding = (WDTabbarScreenWidth - self.viewControllers.count * WDTabbarWidthRatio * 70)/(self.viewControllers.count + 1);
    self.buttonWidth = WDTabbarWidthRatio * 70;
    CGFloat yOffset = (self.headerView.frame.size.height/2 - self.buttonWidth * 2/3);
    
    self.indicateBackView = [[UIView alloc]init];
    self.indicateBackView.frame = CGRectMake(self.padding + self.buttonWidth / 2, yOffset + self.buttonWidth/2 - 4/2, WDTabbarScreenWidth - 2 * self.padding - self.buttonWidth, 4);
    self.indicateBackView.backgroundColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1];
    [self.headerView addSubview:self.indicateBackView];
    
    
    self.indicateView = [[UIView alloc]init];
    self.indicateView.frame = CGRectMake(self.padding + self.buttonWidth / 2, yOffset + self.buttonWidth/2 - 4/2, 0, 4);
//    self.indicateView.backgroundColor = [UIColor colorWithRed:247/255.0 green:158/255.0 blue:7/255.0 alpha:1];
    self.indicateView.backgroundColor = self.barTintColor;
    [self.headerView addSubview:self.indicateView];
    
    for (int i = 0; i < self.viewControllers.count; i++) {
        UIButton *button = [[UIButton alloc]init];
        button.frame = CGRectMake(self.padding * (i + 1) + self.buttonWidth * i, yOffset, self.buttonWidth, self.buttonWidth);
        [button setTitle:self.innerTitles[i] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"dark_button"] forState:UIControlStateNormal];
        button.adjustsImageWhenHighlighted = NO;
        button.tag = ButtonTagOffset + i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.headerView addSubview:button];
        
        UILabel *title = [[UILabel alloc]init];
        title.text = self.titles[i];
        title.tag = LabelTagOffset + i;
        title.font = [UIFont systemFontOfSize:12.f];
        title.textColor = [UIColor blackColor];
        [self.headerView addSubview:title];
        
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(button.mas_bottom).offset(3);
            make.centerX.equalTo(button);
        }];
    }
}

- (void)buttonClick:(UIButton *)btn {
    NSLog(@"buttonClick");
    NSLog(@"%d",self.maxIndex);
    if (btn.tag - ButtonTagOffset > self.maxIndex) {
        NSLog(@"超过最大index限制！！！！！！");
        return;
    }
    
    [self selectSpecificLabelWithIndex:btn.tag - ButtonTagOffset];
    self.selectedIndex = btn.tag - ButtonTagOffset;
}

- (void)setSelectedIndex:(NSUInteger)newSelectedIndex {
    NSLog(@"setSelectedIndex");
    NSAssert(newSelectedIndex < [self.viewControllers count], @"View controller index out of bounds");
    
    if (![self isViewLoaded]) {
        _selectedIndex = newSelectedIndex;
    }
    else if (_selectedIndex != newSelectedIndex) {
        UIViewController *fromViewController;
        UIViewController *toViewController;
        
        if (_selectedIndex != NSNotFound)
        {
            UIButton *fromButton = (UIButton *)[self.headerView viewWithTag:ButtonTagOffset + _selectedIndex];
            fromViewController = self.selectedViewController;
        }
        
        NSUInteger oldSelectedIndex = _selectedIndex;
        _selectedIndex = newSelectedIndex;
        
        UIButton *toButton;
        if (_selectedIndex != NSNotFound)
        {
            toButton = (UIButton *)[self.headerView viewWithTag:ButtonTagOffset + _selectedIndex];
            toViewController = self.selectedViewController;
        }
        
        if (toViewController == nil)  // don't animate
        {
            [fromViewController.view removeFromSuperview];
        }
        else if (fromViewController == nil)  // don't animate
        {
            toViewController.view.frame = _contentContainerView.bounds;
            [_contentContainerView addSubview:toViewController.view];
        }
        else  // not animated
        {
            [fromViewController.view removeFromSuperview];
            
            toViewController.view.frame = _contentContainerView.bounds;
            [_contentContainerView addSubview:toViewController.view];
        }
    }
    else {
        UIViewController *toViewController;
        
        toViewController = self.selectedViewController;
        
        toViewController.view.frame = _contentContainerView.bounds;
        [_contentContainerView addSubview:toViewController.view];
    }
}


- (UIViewController *)selectedViewController
{
    NSLog(@"selectedViewController");
    if (self.selectedIndex != NSNotFound)
        return (self.viewControllers)[self.selectedIndex];
    else
        return nil;
}

- (void)setSelectedViewController:(UIViewController *)newSelectedViewController {
    NSLog(@"setSelectedViewController");
    NSUInteger index = [self.viewControllers indexOfObject:newSelectedViewController];
    if (index != NSNotFound) self.selectedIndex = index;
}

#pragma mark - WDTabbarSubControllerDelegate
- (void)clickButtonWithinController:(id)controller index:(NSUInteger)vcIndex toViewControllerIndex:(NSUInteger)toIndex {

    if (self.maxIndex < toIndex) {
        self.selectedIndex = toIndex;
        [self addAnimationToIndicatorBarWithCurrentCompleteIndex:toIndex];
    }

}

/* 给进度条添加动画*/
- (void)addAnimationToIndicatorBarWithCurrentCompleteIndex:(NSUInteger)idx {
    
    CGFloat barTotalWidth = WDTabbarScreenWidth - 2 * self.padding - self.buttonWidth;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect previousFrame = self.indicateView.frame;
        previousFrame.size.width = idx * barTotalWidth / (self.viewControllers.count - 1);
        self.indicateView.frame = previousFrame;
    } completion:^(BOOL finished) {
        //修改状态
        [self changeIntoCompleteStatusWithButtonIndex:idx];
        [self selectSpecificLabelWithIndex:idx];
        
        
        
        //设置能选择的最大页面
        if (idx >= self.maxIndex) {
            self.maxIndex = idx;
        }
    }];
}

/* 改变对应按钮的状态*/
- (void)changeIntoCompleteStatusWithButtonIndex:(NSUInteger)idx {
    UIButton *orderBtn = [self.headerView viewWithTag:(ButtonTagOffset + idx)];
    [orderBtn setBackgroundImage:[UIImage imageNamed:@"highlight_button"] forState:UIControlStateNormal];
}


/* 改变选中按钮下边title的颜色*/
- (void)selectSpecificLabelWithIndex:(NSUInteger)idx {
    //全部label颜色修正
    for (int i = 0; i < self.viewControllers.count; i ++) {
        UILabel *label = [self.headerView viewWithTag:LabelTagOffset + i];
        label.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    }
    //设置当前选中label颜色
    UILabel *label = [self.headerView viewWithTag:LabelTagOffset + idx];
    label.textColor = self.barTintColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
