//
//  YWAddressInfoModel.h
//  YWChooseAddress
//
//  Created by Candy on 2018/2/8.
//  Copyright © 2018年 com.zhiweism. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YWAddressInfoModel : NSObject

@property (nonatomic, copy) NSString * phoneStr;            // 电话
@property (nonatomic, copy) NSString * nameStr;             // 姓名
@property (nonatomic, copy) NSString * areaAddress;         // 地区（四川省成都市武侯区）
@property (nonatomic, copy) NSString * detailAddress;       // 详细地址（如：红牌楼街道下一站都市B座406）
@property (nonatomic, assign) BOOL     isDefaultAddress;    // 是否是默认地址

@end
