//
//  YWAddressTableViewCell2.h
//  clever
//
//  Created by Candy on 2017/12/29.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YWAddressTableViewCell2 : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel * leftLabel;
@property (strong, nonatomic) IBOutlet UILabel * rightLabel;

@property (nonatomic, strong) NSString         * leftStr;
@property (nonatomic, strong) NSString         * rightStr;

@end
