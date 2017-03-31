//
//  SecondViewController.m
//  testTabbarController
//
//  Created by tb on 17/3/30.
//  Copyright © 2017年 com.tb. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *testTableView;

@property (nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor cyanColor];
    
    self.dataArr = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14"].mutableCopy;
    
    self.testTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WDTabbarScreenWidth, WDTabbarScreenHeight - WDTabbarWidthRatio * 170 - 64 - 5) style:UITableViewStyleGrouped];
    self.testTableView.delegate = self;
    self.testTableView.dataSource = self;
    [self.view addSubview:self.testTableView];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.dataArr[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 50.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WDTabbarScreenWidth, 50)];
    footerView.backgroundColor = [UIColor lightGrayColor];
    
    UIButton *btn = [[UIButton alloc]init];
    btn.frame = CGRectMake(10, 0, WDTabbarScreenWidth - 20, 44);
    [btn setTitle:@"click to next page" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:btn];
    
    return footerView;
}

- (void)clickAction:(UIButton *)btn {
    [self.delegate clickButtonWithinController:self index:1 toViewControllerIndex:2];
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"page 2 view will appear");
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
