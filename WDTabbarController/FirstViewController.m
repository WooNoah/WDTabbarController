//
//  FirstViewController.m
//  testTabbarController
//
//  Created by tb on 17/3/30.
//  Copyright © 2017年 com.tb. All rights reserved.
//

#import "FirstViewController.h"
#import <Masonry.h>

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    UILabel *label = [[UILabel alloc]init];
    label.text = @"dsaklfhdskjafhaskjdfhasldkjfsda";
    [self.view addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"页面一按钮" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor brownColor];
    [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(label);
        make.top.equalTo(label.mas_bottom).offset(10);
        make.height.mas_equalTo(44);
    }];
}

- (void)buttonClick:(UIButton *)btn {
    NSLog(@"页面1按钮点击事件");
//    if ([self.delegate performSelector:@selector(clickButtonWithinController:index:toViewControllerIndex:)]) {
        [self.delegate clickButtonWithinController:self index:0 toViewControllerIndex:1];
//    }
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"page one view will appear");
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
