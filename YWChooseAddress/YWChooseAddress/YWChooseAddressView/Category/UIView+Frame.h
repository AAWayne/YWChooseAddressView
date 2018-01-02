//
//  UIView+Frame.h
//  YWChooseAddressView
//
//  Created by 90Candy on 17/12/25.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    SKOscillatoryAnimationToBigger,
    SKOscillatoryAnimationToSmaller,
} SKOscillatoryAnimationType;

@interface UIView (Frame)
@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;
@property (nonatomic) CGPoint origin;
@property (nonatomic) CGSize size;
@property (nonatomic, readonly) CGFloat screenX;
@property (nonatomic, readonly) CGFloat screenY;

+ (void)showOscillatoryAnimationWithLayer:(CALayer *)layer type:(SKOscillatoryAnimationType)type;
@end
