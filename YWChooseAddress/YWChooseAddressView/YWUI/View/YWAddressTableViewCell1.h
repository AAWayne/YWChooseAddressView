//
//  YWAddressTableViewCell1.h
//  clever
//
//  Created by Candy on 2017/12/29.
//  Copyright © 2017年 apple. All rights reserved.
//

typedef void(^ContactBlock)(void);

#import <UIKit/UIKit.h>


@interface YWAddressTableViewCell1 : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel      * leftLabel;
@property (strong, nonatomic) IBOutlet UITextField  * textField;
@property (strong, nonatomic) IBOutlet UIButton     * rightBtn;

@property (nonatomic, strong) NSString         * leftStr;
@property (nonatomic, strong) NSString         * placehodlerStr;
@property (nonatomic, strong) NSString         * textFieldStr;

@property (nonatomic, copy) ContactBlock         contactBlock;

@end
