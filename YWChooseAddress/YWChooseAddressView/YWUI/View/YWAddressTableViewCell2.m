//
//  YWAddressTableViewCell2.m
//  clever
//
//  Created by Candy on 2017/12/29.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "YWAddressTableViewCell2.h"

@implementation YWAddressTableViewCell2

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _rightLabel.lineBreakMode = NSLineBreakByCharWrapping;    //以字符为显示单位显示，后面部分省略不显示。  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setLeftStr:(NSString *)leftStr {
    _leftStr = leftStr;
    _leftLabel.text = _leftStr;
}

- (void)setRightStr:(NSString *)rightStr {
    _rightStr = rightStr;
    _rightLabel.text = rightStr;
}

@end
