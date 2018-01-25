//
//  YWAddressTableViewCell.m
//  YWChooseAddressView
//
//  Created by 90Candy on 17/12/26.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "YWAddressTableViewCell.h"
#import "YWAddressModel.h"
#import "UIView+YWFrame.h"

static  CGFloat  const  YWFontH = 22; //地址字体高度限制

@interface YWAddressTableViewCell ()

@property (strong, nonatomic) UILabel       *addressNameLabel;    // 地址名称
@property (strong, nonatomic) UIImageView   *selectFlagImageView; // 选中标志

@end

@implementation YWAddressTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self addSubview:self.addressNameLabel];
        [self addSubview:self.selectFlagImageView];
    }
    return self;
}


- (void)setItem:(YWAddressModel *)item {
    
    _item = item;
    _addressNameLabel.text = item.name;
    CGSize fontSize = [UIView getSizeByString:item.name sizeConstraint:CGSizeMake(YWScreenW, YWFontH) font:[UIFont systemFontOfSize:16]];
    _addressNameLabel.frame = CGRectMake(20, 10, fontSize.width, YWFontH);
    _addressNameLabel.textColor = item.isSelected ? YWCOLOR(255, 85, 0, 1) : [UIColor blackColor];
    _selectFlagImageView.hidden = !item.isSelected;
    _selectFlagImageView.frame = CGRectMake(CGRectGetMaxX(_addressNameLabel.frame) + 5, 14.5, 15, 15);
}

- (UILabel *)addressNameLabel {
    if (!_addressNameLabel) {
        _addressNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100, YWFontH)];
        _addressNameLabel.font = [UIFont systemFontOfSize:16];
        _addressNameLabel.textColor = [UIColor blackColor];
    }
    return _addressNameLabel;
}

- (UIImageView *)selectFlagImageView {
    if (!_selectFlagImageView) {
        _selectFlagImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_check"]];
        _selectFlagImageView.frame = CGRectMake(CGRectGetMaxX(self.addressNameLabel.frame) + 5, 14.5, 15, 15);
        _selectFlagImageView.hidden = YES;
    }
    return _selectFlagImageView;
}

@end

