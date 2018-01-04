//
//  ViewController.m
//  YWChooseAddress
//
//  Created by Candy on 2018/1/2.
//  Copyright © 2018年 com.zhiweism. All rights reserved.
//

#import "ViewController.h"

#import "YWNewAddressViewController.h"
#import "YWAddressDataTool.h"

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
    
    // 开启异步线程初始化数据
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 预加载地区信息到本地数据库（避免UI卡顿）
        [[YWAddressDataTool sharedManager] requestGetData];
    });
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.bounds = CGRectMake(0, 0, 120, 50);
    btn.center = self.view.center;
    [btn setTitle:@"添加新地址" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor orangeColor]];
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

#pragma mark - action
- (void)btnAction {
    YWNewAddressViewController *newAddressVC = [[YWNewAddressViewController alloc] init];
    [self.navigationController pushViewController:newAddressVC animated:YES];
}

@end
