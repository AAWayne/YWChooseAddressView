//
//  UIView+YWFrame.h
//  YWChooseAddress
//
//  Created by Candy on 2018/1/25.
//  Copyright © 2018年 com.zhiweism. All rights reserved.
//

#import <UIKit/UIKit.h>

#define WeakSelf                __weak typeof(self) weakSelf = self
#define YWScreenW               [UIScreen mainScreen].bounds.size.width
#define YWScreenH               [UIScreen mainScreen].bounds.size.height
#define YWCOLOR(_R,_G,_B,_A)    [UIColor colorWithRed:_R/255.0 green:_G/255.0 blue:_B/255.0 alpha:_A]

typedef enum : NSUInteger {
    SKOscillatoryAnimationToBigger,
    SKOscillatoryAnimationToSmaller,
} SKOscillatoryAnimationType;

@interface UIView (YWFrame)
@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;
@property (nonatomic) CGPoint origin;
@property (nonatomic) CGSize  size;
@property (nonatomic, readonly) CGFloat screenX;
@property (nonatomic, readonly) CGFloat screenY;


+ (void)showOscillatoryAnimationWithLayer:(CALayer *)layer type:(SKOscillatoryAnimationType)type;

// 根据预设的限制大小，计算字符串宽度
+ (CGSize)getSizeByString:(NSString *)string sizeConstraint:(CGSize)sizeConstraint font:(UIFont *)font;

@end
