//
//  YWAddressViewController.m
//  YWChooseAddress
//
//  Created by Candy on 2018/2/8.
//  Copyright © 2018年 com.zhiweism. All rights reserved.
//

#import "YWAddressViewController.h"

#import "YWChooseAddressView.h"
#import "YWAddressDataTool.h"
#import <AddressBookUI/AddressBookUI.h>
#import <ContactsUI/ContactsUI.h>

#import "YWAddressTableViewCell1.h"
#import "YWAddressTableViewCell2.h"
#import "YWAddressTableViewCell3.h"

#define CELL_IDENTIFIER1     @"YWAddressTableViewCell1"
#define CELL_IDENTIFIER2     @"YWAddressTableViewCell2"
#define CELL_IDENTIFIER3     @"YWAddressTableViewCell3"

@interface YWAddressViewController ()<UITableViewDelegate, UITableViewDataSource, NSURLSessionDelegate,UIGestureRecognizerDelegate, CNContactViewControllerDelegate, CNContactPickerDelegate> {
    NSString            * _nameStr;
    NSString            * _phoneStr;
    NSString            * _areaAddress;
    NSString            * _detailAddress;
    NSString            * _isDefault;
}

@property (nonatomic, strong) UITableView         * tableView;
@property (nonatomic, strong) NSArray             * dataSource;
@property (nonatomic, strong) UITextView          * detailTextViw;

@property (nonatomic,strong) YWChooseAddressView  * chooseAddressView;
@property (nonatomic,strong) UIView               * coverView;



- (void)initUserInterface;  /**< 初始化用户界面 */
- (void)initUserDataSource;  /**< 初始化数据源 */

@end

@implementation YWAddressViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUserDataSource];
    [self initUserInterface];
    
}

- (void)initUserInterface {
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(navRightItem)];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.coverView];
    
}
- (void)initUserDataSource {
    self.title = @"添加新地址";
    _dataSource = @[@[@"收货人", @"联系电话", @"所在地区"],
                    @[@"设为默认"]];
    _areaAddress = @"请选择";
    
    if (self.model) {
        self.title = @"编辑地址";
        _phoneStr = _model.phoneStr;
        _nameStr = _model.nameSrt;
        _areaAddress = _model.areaAddress;
        _detailAddress = [_model.detailAddress isEqual:[NSNull null]] ? @"" :
        _model.detailAddress;
        self.chooseAddressView.address = _areaAddress;
    }
}

#pragma mark *** 导航栏右上角 - 保存按钮 ***
- (void)navRightItem {
    NSLog(@"保存收货地址");
    YWAddressTableViewCell1 *nameCell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    YWAddressTableViewCell1 *phoneCell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    YWAddressTableViewCell3 *defaultCell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    _nameStr = nameCell.textField.text;
    _phoneStr = phoneCell.textField.text;
    _detailAddress = _detailTextViw.text;
    
    // 是否设置为默认地址
    _isDefault = defaultCell.rightSwitch.isOn ? @"true":@"false";
    
    if (_nameStr.length == 0) {
        NSLog(@"请填写收货人姓名！");
        return;
    } else if (_phoneStr.length == 0) {
        NSLog(@"请填写收货人电话！");
        return;
    } else if (_phoneStr.length != 11) {
        NSLog(@"手机号为11位，如果为座机请加上区号");
        return;
    } else if ([_areaAddress isEqualToString:@"请选择"]) {
        NSLog(@"请选择所在地区");
        return;
    } else if (_detailAddress.length == 0 || _detailAddress.length < 5) {
        NSLog(@"请填写详细地址，不少与5字");
        return;
    }
    
    // 添加新地址
    [self newAddressRequest];
}

#pragma mark *** 添加新地址网络请求 & 编辑地址网络请求 ***
// 添加新地址网络请求
- (void)newAddressRequest {
    NSLog(@"添加新地址网络请求");
    NSDictionary *parameter = @{@"收货人姓名":_nameStr,
                                @"收货人电话":_phoneStr,
                                @"所在地区":_areaAddress,
                                @"详细地址":_detailAddress,
                                @"设为默认":_isDefault};
    NSLog(@"填写信息：%@", parameter);
}

#pragma mark *** 弹出选择地区视图 ***
- (void)chooseAddress {
    WeakSelf;
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        weakSelf.coverView.frame = CGRectMake(0, 0, YWScreenW, YWScreenH);
        weakSelf.chooseAddressView.hidden = NO;
    } completion:^(BOOL finished) {
        // 动画结束之后添加阴影
        weakSelf.coverView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    }];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint point = [gestureRecognizer locationInView:gestureRecognizer.view];
    if (CGRectContainsPoint(_chooseAddressView.frame, point)){
        return NO;
    }
    return YES;
}


- (void)tapCover:(UITapGestureRecognizer *)tap {
    if (_chooseAddressView.chooseFinish) {
        _chooseAddressView.chooseFinish();
    }
}

#pragma mark *** 从通讯录选择联系人 电话 & 姓名 ***
//用户点击 加号按钮 - 选择联系人
- (void)selectContactAction {
    // 弹出联系人列表 - 此方法只使用于 iOS 9.0以后
    CNContactPickerViewController * pickerVC = [[CNContactPickerViewController alloc]init];
    pickerVC.navigationItem.title = @"选择联系人";
    pickerVC.delegate = self;
    [self presentViewController:pickerVC animated:YES completion:nil];
}

//这个方法在用户取消选择时调用
- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker; {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - CNContactPickerDelegate
// 这个方法在用户选择一个联系人后调用
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact {
    // 1.获取姓名
    NSString *firstname = contact.givenName;
    NSString *lastname = contact.familyName;
    NSLog(@"%@%@", lastname, firstname);
    
    //通过姓名寻找联系人
    NSMutableString *fullName = [[NSMutableString alloc] init];
    if ( lastname != nil || lastname.length > 0 ) {
        [fullName appendString:lastname];
    }
    if ( firstname != nil || firstname.length > 0 ) {
        [fullName appendString:firstname];
    }
    
    // 2.获取电话号码
    NSArray *phones = contact.phoneNumbers;
    NSMutableArray *phoneNumbers = [NSMutableArray array];
    // 3.遍历电话号码
    for (CNLabeledValue *labelValue in phones) {
        CNPhoneNumber *phoneNumber = labelValue.value;
        //把 -、+86、空格 这些过滤掉
        NSString *phoneStr = [phoneNumber.stringValue stringByReplacingOccurrencesOfString:@"-" withString:@""];
        phoneStr = [phoneStr stringByReplacingOccurrencesOfString:@"+86" withString:@""];
        phoneStr = [phoneStr stringByReplacingOccurrencesOfString:@" " withString:@""];
        [phoneNumbers addObject:phoneStr];
    }
    
    NSLog(@"选择的姓名：%@， 电话号码：%@", fullName, phoneNumbers.firstObject);
    _nameStr = fullName;
    // 这里直接取第一个电话号码，如果有多个请自行添加选择器
    _phoneStr = phoneNumbers.firstObject;
    [_tableView reloadData];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark *** UITableViewDataSource & UITableViewDelegate ***
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.model.isDefaultAddress) {
        // 如果该地址已经是默认地址，则无需再显示 "设为默认" 这个按钮，即隐藏
        return 1;
    }
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeakSelf;
    if (indexPath.section == 0) {
        if (indexPath.row < 2) {
            YWAddressTableViewCell1 *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER1 forIndexPath:indexPath];
            cell.rightBtn.hidden = YES;
            cell.placehodlerStr = @"填写收货人姓名";
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.leftStr = _dataSource[indexPath.section][indexPath.row];
            if (_nameStr.length > 0) {
                cell.textFieldStr = _nameStr;
            }
            if (indexPath.row == 1) {
                cell.rightBtn.hidden = NO;
                cell.placehodlerStr = @"填写收货人电话";
                cell.textField.keyboardType = UIKeyboardTypePhonePad;
                if (_phoneStr.length > 0) {
                    cell.textFieldStr = _phoneStr;
                }
                cell.contactBlock = ^{
                    [weakSelf selectContactAction];
                };
            }
            return cell;
        } else {
            YWAddressTableViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER2 forIndexPath:indexPath];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.leftStr = _dataSource[indexPath.section][indexPath.row];
            cell.rightStr = _areaAddress;
            if (![_areaAddress isEqualToString:@""] && ![_areaAddress isEqualToString:@"请选择"]) {
                cell.rightLabel.textColor = [UIColor blackColor];
            } else {
                cell.rightLabel.textColor = [UIColor lightGrayColor];
            }
            return cell;
        }
    } else {
        YWAddressTableViewCell3 *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER3 forIndexPath:indexPath];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.leftStr = _dataSource[indexPath.section][indexPath.row];
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        UIView *footerView = [[UIView alloc] init];
        footerView.backgroundColor = YWCOLOR(240, 240, 240, 1);
        [footerView addSubview:self.detailTextViw];
        return footerView;
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 90;
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 取消cell选中效果
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && indexPath.row == 2) {
        // 选择地区
        [self chooseAddress];
    }
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, YWScreenW, YWScreenH) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = YWCOLOR(240, 240, 240, 1);
        _tableView.rowHeight = 50;
        _tableView.tableFooterView = [UIView new];
        // 设置分割线
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
        // 注册cell
        [_tableView registerNib:[UINib nibWithNibName:CELL_IDENTIFIER1 bundle:nil] forCellReuseIdentifier:CELL_IDENTIFIER1];
        [_tableView registerNib:[UINib nibWithNibName:CELL_IDENTIFIER2 bundle:nil] forCellReuseIdentifier:CELL_IDENTIFIER2];
        [_tableView registerNib:[UINib nibWithNibName:CELL_IDENTIFIER3 bundle:nil] forCellReuseIdentifier:CELL_IDENTIFIER3];
    }
    return _tableView;
}

- (UITextView *)detailTextViw {
    if (!_detailTextViw) {
        _detailTextViw = [[UITextView alloc] initWithFrame:CGRectMake(0, 1, YWScreenW, 80)];
        // 这里由于项目用的QMUI框架，所以没有做提示语（QMUITextView）自带 placeholder 属性
        // _detailTextViw.placeholder = @"请填写详细地址（尽量精确到单元楼或门牌号)";
        _detailTextViw.textContainerInset = UIEdgeInsetsMake(5, 15, 5, 15);
        _detailTextViw.font = [UIFont systemFontOfSize:14];
        if (self.model.detailAddress.length > 0) {
            _detailTextViw.text = _detailAddress;
        }
    }
    return _detailTextViw;
}

- (YWChooseAddressView *)chooseAddressView {
    if (!_chooseAddressView) {
        WeakSelf;
        _chooseAddressView = [[YWChooseAddressView alloc]initWithFrame:CGRectMake(0, YWScreenH - 350, YWScreenW, 350)];
        // 设置默认
        // _chooseAddressView.address = @"四川省成都市武侯区";
        // _chooseAddressView.areaCode = @"510107";
        _chooseAddressView.chooseFinish = ^{
            weakSelf.coverView.backgroundColor = [UIColor clearColor];
            NSLog(@"选择的地区为：%@", weakSelf.chooseAddressView.address);
            _areaAddress = weakSelf.chooseAddressView.address;
            if (_areaAddress.length == 0) {
                _areaAddress = @"请选择";
            }
            [weakSelf.tableView reloadData];
            // 隐藏视图 - 动画
            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                weakSelf.coverView.frame = CGRectMake(0, YWScreenH, YWScreenW, YWScreenH);
                weakSelf.chooseAddressView.hidden = NO;
            } completion:nil];
        };
    }
    return _chooseAddressView;
}

- (UIView *)coverView {
    if (!_coverView) {
        _coverView = [[UIView alloc]initWithFrame:CGRectMake(0, YWScreenH, YWScreenW, YWScreenH)];
        [_coverView addSubview:self.chooseAddressView];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCover:)];
        [_coverView addGestureRecognizer:tap];
        tap.delegate = self;
    }
    return _coverView;
}

@end

