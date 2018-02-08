//
//  YWTool.m
//  YWChooseAddress
//
//  Created by Candy on 2018/2/8.
//  Copyright © 2018年 com.zhiweism. All rights reserved.
//

#import "YWTool.h"

@implementation YWTool

+ (void)showAlterWithViewController:(UIViewController *)viewController Message:(NSString *)message {
    UIAlertController *shareController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    shareController.message = message;
    [viewController presentViewController:shareController animated:YES completion:nil];
    [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(timeAction:) userInfo:shareController repeats:NO];
}
+ (void)timeAction:(NSTimer *)timer {
    UIAlertController *alter = (UIAlertController *)[timer userInfo];
    [alter dismissViewControllerAnimated:YES completion:nil];
}

@end
