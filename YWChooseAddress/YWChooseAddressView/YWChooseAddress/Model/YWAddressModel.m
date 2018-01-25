//
//  YWAddressModel.m
//  YWChooseAddressView
//
//  Created by 90Candy on 17/12/26.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "YWAddressModel.h"

@implementation YWAddressModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {

}

@end
