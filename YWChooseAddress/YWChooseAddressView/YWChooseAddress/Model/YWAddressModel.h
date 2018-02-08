//
//  YWAddressModel.h
//  YWChooseAddressView
//
//  Created by 90Candy on 17/12/26.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YWAddressModel : NSObject

@property (nonatomic, copy) NSString * code;        // 总地址码（相当于id）
@property (nonatomic, copy) NSString * sheng;       // 省级地址码
@property (nonatomic, copy) NSString * di;          // 市级地址码
@property (nonatomic, copy) NSString * xian;        // 区县级地址码
@property (nonatomic, copy) NSString * name;        // 对应的名称（如：四川省、成都市、武侯区等）
@property (nonatomic, copy) NSString * level;       // 等级(1为省级、2为市级、4为区县级)
@property (nonatomic, assign) BOOL  isSelected;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
