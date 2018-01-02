//
//  ViewController.m
//  YWChooseAddress
//
//  Created by Candy on 2018/1/2.
//  Copyright © 2018年 com.zhiweism. All rights reserved.
//

#import "ViewController.h"

#import "YWNewAddressViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setUp];
}

#pragma mark - setUp UI
- (void)setUp {
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"YWChooseAddress";
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.bounds = CGRectMake(0, 0, 120, 50);
    btn.center = self.view.center;
    [btn setTitle:@"添加新地址" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor lightGrayColor]];
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

#pragma mark - action
- (void)btnAction {
    YWNewAddressViewController *newAddressVC = [[YWNewAddressViewController alloc] init];
    [self.navigationController pushViewController:newAddressVC animated:YES];
}

@end
