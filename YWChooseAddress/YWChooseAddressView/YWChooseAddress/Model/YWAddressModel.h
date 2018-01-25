//
//  YWAddressModel.h
//  YWChooseAddressView
//
//  Created by 90Candy on 17/12/26.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YWAddressModel : NSObject

@property (nonatomic,copy) NSString * code;
@property (nonatomic,copy) NSString * sheng;
@property (nonatomic,copy) NSString * di;
@property (nonatomic,copy) NSString * xian;
@property (nonatomic,copy) NSString * name;
@property (nonatomic,copy) NSString * level;
@property (nonatomic,assign) BOOL  isSelected;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
