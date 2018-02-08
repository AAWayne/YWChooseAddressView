//
//  YWAddressTableViewCell1.m
//  clever
//
//  Created by Candy on 2017/12/29.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "YWAddressTableViewCell1.h"

@implementation YWAddressTableViewCell1

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setLeftStr:(NSString *)leftStr {
    _leftStr = leftStr;
    _leftLabel.text = _leftStr;
}

// 设置水印字体
- (void)setPlacehodlerStr:(NSString *)placehodlerStr {
    _placehodlerStr = placehodlerStr;
    _textField.placeholder = _placehodlerStr;
}

- (void)setTextFieldStr:(NSString *)textFieldStr {
    _textFieldStr = textFieldStr;
    _textField.text = _textFieldStr;
}

// 加号按钮 - 从通讯录选择联系人
- (IBAction)contactBtn:(id)sender {
    if (_contactBlock) {
        _contactBlock();
    }
}

@end
