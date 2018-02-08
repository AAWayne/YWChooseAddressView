//
//  YWAddressTableViewCell3.m
//  clever
//
//  Created by Candy on 2017/12/29.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "YWAddressTableViewCell3.h"

@implementation YWAddressTableViewCell3

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

// 设置默认地址
- (IBAction)onRightSwitch:(UISwitch *)sender {


}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setLeftStr:(NSString *)leftStr {
    _leftStr = leftStr;
    _leftLabel.text = _leftStr;
}

@end
