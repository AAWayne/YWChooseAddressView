//
//  YWAddressView.m
//  YWChooseYWAddressView
//
//  Created by 90Candy on 17/12/25.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "YWAddressView.h"
#import "UIView+YWFrame.h"

static  CGFloat  const  HYBarItemMargin = 20;
@interface YWAddressView ()
@property (nonatomic,strong) NSMutableArray * btnArray;
@end

@implementation YWAddressView

- (void)layoutSubviews {
   
    [super layoutSubviews];
    
    for (NSInteger i = 0; i <= self.btnArray.count - 1 ; i++) {
        
        UIView * view = self.btnArray[i];
        if (i == 0) {
            view.left = HYBarItemMargin;
        }
        if (i > 0) {
            UIView * preView = self.btnArray[i - 1];
            view.left = HYBarItemMargin  + preView.right;
        }
      
    }
}

- (NSMutableArray *)btnArray {
    
    NSMutableArray * mArray  = [NSMutableArray array];
    for (UIView * view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [mArray addObject:view];
        }
    }
    _btnArray = mArray;
    return _btnArray;
}

@end
