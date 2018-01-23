//
//  YWAddressTableViewCell.m
//  YWChooseAddressView
//
//  Created by 90Candy on 17/12/26.
//  Copyright © 2017年 apple. All rights reserved.
//
#define COLOR_ORANGE(_R,_G,_B,_A) [UIColor colorWithRed:_R/255.0 green:_G/255.0 blue:_B/255.0 alpha:_A]

#import "YWAddressTableViewCell.h"
#import "YWAddressModel.h"


@interface YWAddressTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectFlag;
@end
@implementation YWAddressTableViewCell

- (void)setItem:(YWAddressModel *)item {
    
    _item = item;
    _addressLabel.text = item.name;
    _addressLabel.textColor = item.isSelected ? COLOR_ORANGE(255, 85, 0, 1) : [UIColor blackColor];
    _selectFlag.hidden = !item.isSelected;
}
@end
