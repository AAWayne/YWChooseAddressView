//
//  ViewController.m
//  YWChooseAddress
//
//  Created by Candy on 2018/1/2.
//  Copyright © 2018年 com.zhiweism. All rights reserved.
//

#import "ViewController.h"

#import "YWAddressViewController.h"
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
    self.title = @"地区选择器 功能展示";
    
    // 开启异步线程初始化数据
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 预加载地区信息到本地数据库（避免UI卡顿）
        [[YWAddressDataTool sharedManager] requestGetData];
    });
    
    // 添加新地址
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(50, 350, 100, 50);
    [addBtn setTitle:@"添加新地址" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addBtn setBackgroundColor:[UIColor orangeColor]];
    [addBtn addTarget:self action:@selector(addBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];
    
    // 编辑地址
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    editBtn.frame = CGRectMake(YWScreenW - 150, 350, 100, 50);
    [editBtn setTitle:@"编辑地址" forState:UIControlStateNormal];
    [editBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [editBtn setBackgroundColor:[UIColor orangeColor]];
    [editBtn addTarget:self action:@selector(editBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:editBtn];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:nil];
    
}

#pragma mark - action
- (void)addBtnAction {
    
    YWAddressViewController *addressVC = [[YWAddressViewController alloc] init];
    // 保存后的地址回调
    addressVC.addressBlock = ^(YWAddressInfoModel *model) {
        NSLog(@"用户地址信息填写回调：");
        NSLog(@"姓名：%@", model.nameStr);
        NSLog(@"电话：%@", model.phoneStr);
        NSLog(@"地区：%@", model.areaAddress);
        NSLog(@"详细地址：%@", model.detailAddress);
        NSLog(@"是否设为默认：%@", model.isDefaultAddress ? @"是" : @"不是");
    };
    [self.navigationController pushViewController:addressVC animated:YES];
}

- (void)editBtnAction {
    
    // 这里传入需要编辑的地址信息，例如:
    YWAddressViewController *addressVC = [[YWAddressViewController alloc] init];
    YWAddressInfoModel *model = [YWAddressInfoModel alloc];
    model.phoneStr = @"18888888888";
    model.nameStr = @"袁伟";
    model.areaAddress = @"四川省成都市武侯区";
    model.detailAddress = @"下一站都市B座406";
    model.isDefaultAddress = NO; // 如果是默认地址则传入YES
    addressVC.model = model;
    // 保存后的地址回调
    addressVC.addressBlock = ^(YWAddressInfoModel *model) {
        NSLog(@"用户地址信息填写回调：");
        NSLog(@"姓名：%@", model.nameStr);
        NSLog(@"电话：%@", model.phoneStr);
        NSLog(@"地区：%@", model.areaAddress);
        NSLog(@"详细地址：%@", model.detailAddress);
        NSLog(@"是否设为默认：%@", model.isDefaultAddress ? @"是" : @"不是");
    };
    
    [self.navigationController pushViewController:addressVC animated:YES];
}

@end
