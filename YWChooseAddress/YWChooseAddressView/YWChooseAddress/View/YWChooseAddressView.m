//
//  YWChooseAddressView.m
//  YWChooseAddressView
//
//  Created by 90Candy on 17/12/22.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "YWChooseAddressView.h"
#import "YWAddressView.h"
#import "YWAddressTableViewCell.h"
#import "YWAddressModel.h"
#import "YWAddressDataTool.h"

static  CGFloat  const  kHYTopViewHeight = 40; //顶部视图的高度
static  CGFloat  const  kHYTopTabbarHeight = 30; //地址标签栏的高度

@interface YWChooseAddressView ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
@property (nonatomic,weak) YWAddressView        * topTabbar;
@property (nonatomic,weak) UIScrollView         * contentView;
@property (nonatomic,weak) UIView               * underLine;
@property (nonatomic,strong) NSArray            * dataSouce;
@property (nonatomic,strong) NSArray            * cityDataSouce;
@property (nonatomic,strong) NSArray            * districtDataSouce;
@property (nonatomic,strong) NSMutableArray     * tableViews;
@property (nonatomic,strong) NSMutableArray     * topTabbarItems;
@property (nonatomic,weak) UIButton             * selectedBtn;
@end

@implementation YWChooseAddressView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

#pragma mark - setUp UI

- (void)setUp {
    
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, kHYTopViewHeight)];
    [self addSubview:topView];
    UILabel * titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"选择您所在地区";
    [titleLabel sizeToFit];
    [topView addSubview:titleLabel];
    titleLabel.centerY = topView.height * 0.5;
    titleLabel.centerX = topView.width * 0.5;
    UIView * separateLine = [self separateLine];
    [topView addSubview: separateLine];
    separateLine.top = topView.height - separateLine.height;
    topView.backgroundColor = [UIColor whiteColor];

    
    YWAddressView * topTabbar = [[YWAddressView alloc]initWithFrame:CGRectMake(0, topView.height, self.frame.size.width, kHYTopViewHeight)];
    [self addSubview:topTabbar];
    _topTabbar = topTabbar;
    [self addTopBarItem];
    UIView * separateLine1 = [self separateLine];
    [topTabbar addSubview: separateLine1];
    separateLine1.top = topTabbar.height - separateLine.height;
    [_topTabbar layoutIfNeeded];
    topTabbar.backgroundColor = [UIColor whiteColor];
    
    UIView * underLine = [[UIView alloc] initWithFrame:CGRectZero];
    [topTabbar addSubview:underLine];
    _underLine = underLine;
    underLine.height = 2.0f;
    UIButton * btn = self.topTabbarItems.lastObject;
    [self changeUnderLineFrame:btn];
    underLine.top = separateLine1.top - underLine.height;
    
    _underLine.backgroundColor = [UIColor orangeColor];
    UIScrollView * contentView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(topTabbar.frame), self.frame.size.width, self.height - kHYTopViewHeight - kHYTopTabbarHeight)];
    contentView.contentSize = CGSizeMake(YWScreenW, 0);
    [self addSubview:contentView];
    _contentView = contentView;
    _contentView.pagingEnabled = YES;
    _contentView.backgroundColor = [UIColor whiteColor];
    [self addTableView];
    _contentView.delegate = self;
}


- (void)addTableView {

    UITableView * tabbleView = [[UITableView alloc]initWithFrame:CGRectMake(self.tableViews.count * YWScreenW, 0, YWScreenW, _contentView.height)];
    [_contentView addSubview:tabbleView];
    [self.tableViews addObject:tabbleView];
    tabbleView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tabbleView.delegate = self;
    tabbleView.dataSource = self;
    tabbleView.contentInset = UIEdgeInsetsMake(0, 0, 80, 0);
    tabbleView.rowHeight = 44;
    [tabbleView registerClass:[YWAddressTableViewCell class] forCellReuseIdentifier:@"YWAddressTableViewCell"];
}

- (void)addTopBarItem {
    
    UIButton * topBarItem = [UIButton buttonWithType:UIButtonTypeCustom];
    [topBarItem setTitle:@"请选择" forState:UIControlStateNormal];
    [topBarItem setTitleColor:YWCOLOR(43, 43, 43, 1) forState:UIControlStateNormal];
    [topBarItem setTitleColor:YWCOLOR(255, 85, 0, 1) forState:UIControlStateSelected];
    [topBarItem sizeToFit];
     topBarItem.centerY = _topTabbar.height * 0.5;
    [self.topTabbarItems addObject:topBarItem];
    [_topTabbar addSubview:topBarItem];
    [topBarItem addTarget:self action:@selector(topBarItemClick:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - TableViewDatasouce

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if([self.tableViews indexOfObject:tableView] == 0){
        return self.dataSouce.count;
    } else if ([self.tableViews indexOfObject:tableView] == 1) {
        return self.cityDataSouce.count;
    } else if ([self.tableViews indexOfObject:tableView] == 2) {
        return self.districtDataSouce.count;
    }
    return self.dataSouce.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    YWAddressTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YWAddressTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    YWAddressModel * item;
    //省级别
    if([self.tableViews indexOfObject:tableView] == 0){
        item = self.dataSouce[indexPath.row];
    //市级别
    } else if ([self.tableViews indexOfObject:tableView] == 1){
        item = self.cityDataSouce[indexPath.row];
    //县级别
    } else if ([self.tableViews indexOfObject:tableView] == 2){
        item = self.districtDataSouce[indexPath.row];
    }
    cell.item = item;
    return cell;
}

#pragma mark - TableViewDelegate
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if([self.tableViews indexOfObject:tableView] == 0){
        

        //1.1 获取下一级别的数据源(市级别,如果是直辖市时,下级则为区级别)
        YWAddressModel * provinceItem = self.dataSouce[indexPath.row];
        self.cityDataSouce = [[YWAddressDataTool sharedManager] queryAllRecordWithShengID:[provinceItem.code substringWithRange:(NSRange){0,2}]];
        if(self.cityDataSouce.count == 0) {
            for (int i = 0; i < self.tableViews.count && self.tableViews.count != 1; i++) {
                [self removeLastItem];
            }
            [self setUpAddress:provinceItem.name];
            return indexPath;
        }
        //1.1 判断是否是第一次选择,不是,则重新选择省,切换省.
        NSIndexPath * indexPath0 = [tableView indexPathForSelectedRow];

        if ([indexPath0 compare:indexPath] != NSOrderedSame && indexPath0) {
            
            for (int i = 0; i < self.tableViews.count && self.tableViews.count != 1; i++) {
                [self removeLastItem];
            }
            [self addTopBarItem];
            [self addTableView];
            [self scrollToNextItem:provinceItem.name];
            return indexPath;
            
        } else if ([indexPath0 compare:indexPath] == NSOrderedSame && indexPath0) {
            
            for (int i = 0; i < self.tableViews.count && self.tableViews.count != 1 ; i++) {
                [self removeLastItem];
            }
            [self addTopBarItem];
            [self addTableView];
            [self scrollToNextItem:provinceItem.name];
            return indexPath;
        }

        //之前未选中省，第一次选择省
        [self addTopBarItem];
        [self addTableView];
        YWAddressModel * item = self.dataSouce[indexPath.row];
        [self scrollToNextItem:item.name ];
        
    } else if ([self.tableViews indexOfObject:tableView] == 1) {
        
        YWAddressModel * cityItem = self.cityDataSouce[indexPath.row];
        self.districtDataSouce = [[YWAddressDataTool sharedManager] queryAllRecordWithShengID:cityItem.sheng cityID:cityItem.di];
        NSIndexPath * indexPath0 = [tableView indexPathForSelectedRow];
        
        if ([indexPath0 compare:indexPath] != NSOrderedSame && indexPath0) {
            
            for (int i = 0; i < self.tableViews.count - 1; i++) {
                [self removeLastItem];
            }
            [self addTopBarItem];
            [self addTableView];
            [self scrollToNextItem:cityItem.name];
            return indexPath;

        } else if ([indexPath0 compare:indexPath] == NSOrderedSame && indexPath0) {
        
            [self scrollToNextItem:cityItem.name];
            return indexPath;
        }
        
        [self addTopBarItem];
        [self addTableView];
        YWAddressModel * item = self.cityDataSouce[indexPath.row];
        [self scrollToNextItem:item.name];
        
    } else if ([self.tableViews indexOfObject:tableView] == 2) {
        
        YWAddressModel * item = self.districtDataSouce[indexPath.row];
        [self setUpAddress:item.name];
    }
    return indexPath;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YWAddressModel * item;
    if([self.tableViews indexOfObject:tableView] == 0) {
       item = self.dataSouce[indexPath.row];
    } else if ([self.tableViews indexOfObject:tableView] == 1) {
       item = self.cityDataSouce[indexPath.row];
    } else if ([self.tableViews indexOfObject:tableView] == 2) {
       item = self.districtDataSouce[indexPath.row];
    }
    item.isSelected = YES;
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YWAddressModel * item;
    if([self.tableViews indexOfObject:tableView] == 0) {
        item = self.dataSouce[indexPath.row];
    } else if ([self.tableViews indexOfObject:tableView] == 1) {
        item = self.cityDataSouce[indexPath.row];
    } else if ([self.tableViews indexOfObject:tableView] == 2) {
        item = self.districtDataSouce[indexPath.row];
    }
    item.isSelected = NO;
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

}



#pragma mark - private 

//点击按钮,滚动到对应位置
- (void)topBarItemClick:(UIButton *)btn {
    
    NSInteger index = [self.topTabbarItems indexOfObject:btn];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.contentView.contentOffset = CGPointMake(index * YWScreenW, 0);
        [self changeUnderLineFrame:btn];
    }];
}

//调整指示条位置
- (void)changeUnderLineFrame:(UIButton  *)btn {
    
    _selectedBtn.selected = NO;
    btn.selected = YES;
    _selectedBtn = btn;
    _underLine.left = btn.left;
    _underLine.width = btn.width;
}

//完成地址选择,执行chooseFinish代码块
- (void)setUpAddress:(NSString *)address {

    NSInteger index = self.contentView.contentOffset.x / YWScreenW;
    UIButton * btn = self.topTabbarItems[index];
    [btn setTitle:address forState:UIControlStateNormal];
    [btn sizeToFit];
    [_topTabbar layoutIfNeeded];
    [self changeUnderLineFrame:btn];
    NSMutableString * addressStr = [[NSMutableString alloc] init];
    for (UIButton * btn  in self.topTabbarItems) {
        if ([btn.currentTitle isEqualToString:@"县"] || [btn.currentTitle isEqualToString:@"市辖区"] ) {
            continue;
        }
        [addressStr appendString:btn.currentTitle];
        // [addressStr appendString:@" "]; // 省市区地址间加空格或者其他间隔符号
    }
    self.address = addressStr;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.hidden = YES;
        if (self.chooseFinish) {
            self.chooseFinish();
        }
    });
}

//当重新选择省或者市的时候，需要将下级视图移除。
- (void)removeLastItem {

    [self.tableViews.lastObject performSelector:@selector(removeFromSuperview) withObject:nil withObject:nil];
    [self.tableViews removeLastObject];
    
    [self.topTabbarItems.lastObject performSelector:@selector(removeFromSuperview) withObject:nil withObject:nil];
    [self.topTabbarItems removeLastObject];
}

//滚动到下级界面,并重新设置顶部按钮条上对应按钮的title
- (void)scrollToNextItem:(NSString *)preTitle {
    
    NSInteger index = self.contentView.contentOffset.x / YWScreenW;
    UIButton * btn = self.topTabbarItems[index];
    [btn setTitle:preTitle forState:UIControlStateNormal];
    [btn sizeToFit];
    [_topTabbar layoutIfNeeded];
    [UIView animateWithDuration:0.25 animations:^{
        self.contentView.contentSize = (CGSize){self.tableViews.count * YWScreenW,0};
        CGPoint offset = self.contentView.contentOffset;
        self.contentView.contentOffset = CGPointMake(offset.x + YWScreenW, offset.y);
        [self changeUnderLineFrame: [self.topTabbar.subviews lastObject]];
    }];
}


#pragma mark - <UIScrollView>
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if(scrollView != self.contentView) return;
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        NSInteger index = scrollView.contentOffset.x / YWScreenW;
        UIButton * btn = weakSelf.topTabbarItems[index];
        [weakSelf changeUnderLineFrame:btn];
    }];
}

#pragma mark - 开始就有地址时.

- (void)setAreaCode:(NSString *)areaCode {
    
    _areaCode = areaCode;
    //2.1 添加市级别,地区级别列表
    [self addTableView];
    [self addTableView];

    self.cityDataSouce = [[YWAddressDataTool sharedManager] queryAllRecordWithShengID:[self.areaCode substringWithRange:(NSRange){0,2}]];
    self.districtDataSouce = [[YWAddressDataTool sharedManager] queryAllRecordWithShengID:[self.areaCode substringWithRange:(NSRange){0,2}] cityID:[self.areaCode substringWithRange:(NSRange){2,2}]];
  
    //2.3 添加底部对应按钮
    [self addTopBarItem];
    [self addTopBarItem];
    
    NSString * code = [self.areaCode stringByReplacingCharactersInRange:(NSRange){2,4} withString:@"0000"];
    NSString * provinceName = [[YWAddressDataTool sharedManager] queryAllRecordWithAreaCode:code];
    UIButton * firstBtn = self.topTabbarItems.firstObject;
    [firstBtn setTitle:provinceName forState:UIControlStateNormal];
    
    NSString * cityName = [[YWAddressDataTool sharedManager] queryAllRecordWithAreaCode:[self.areaCode stringByReplacingCharactersInRange:(NSRange){4,2} withString:@"00"]];
    UIButton * midBtn = self.topTabbarItems[1];
    [midBtn setTitle:cityName forState:UIControlStateNormal];
    
     NSString * districtName = [[YWAddressDataTool sharedManager] queryAllRecordWithAreaCode:self.areaCode];
    UIButton * lastBtn = self.topTabbarItems.lastObject;
    [lastBtn setTitle:districtName forState:UIControlStateNormal];
    [self.topTabbarItems makeObjectsPerformSelector:@selector(sizeToFit)];
    [_topTabbar layoutIfNeeded];
    
    
    [self changeUnderLineFrame:lastBtn];
    
    //2.4 设置偏移量
    self.contentView.contentSize = (CGSize){self.tableViews.count * YWScreenW,0};
    CGPoint offset = self.contentView.contentOffset;
    self.contentView.contentOffset = CGPointMake((self.tableViews.count - 1) * YWScreenW, offset.y);

    [self setSelectedProvince:provinceName andCity:cityName andDistrict:districtName];
}

//初始化选中状态
- (void)setSelectedProvince:(NSString *)provinceName andCity:(NSString *)cityName andDistrict:(NSString *)districtName {
    
    for (YWAddressModel * item in self.dataSouce) {
        if ([item.name isEqualToString:provinceName]) {
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:[self.dataSouce indexOfObject:item] inSection:0];
            UITableView * tableView  = self.tableViews.firstObject;
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
            [self tableView:tableView didSelectRowAtIndexPath:indexPath];
            break;
        }
    }
    
    for (int i = 0; i < self.cityDataSouce.count; i++) {
        YWAddressModel * item = self.cityDataSouce[i];
        
        if ([item.name isEqualToString:cityName]) {
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            UITableView * tableView  = self.tableViews[1];
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
            [self tableView:tableView didSelectRowAtIndexPath:indexPath];
            break;
        }
    }
    
    for (int i = 0; i <self.districtDataSouce.count; i++) {
        YWAddressModel * item = self.districtDataSouce[i];
        if ([item.name isEqualToString:districtName]) {
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            UITableView * tableView  = self.tableViews[2];
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
            [self tableView:tableView didSelectRowAtIndexPath:indexPath];
            break;
        }
    }
}

#pragma mark - getter 方法

//分割线
- (UIView *)separateLine {
    
    UIView * separateLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1 / [UIScreen mainScreen].scale)];
    separateLine.backgroundColor = YWCOLOR(222, 222, 222, 1);
    return separateLine;
}

- (NSMutableArray *)tableViews {
    
    if (!_tableViews) {
        _tableViews = [NSMutableArray array];
    }
    return _tableViews;
}

- (NSMutableArray *)topTabbarItems {
    if (!_topTabbarItems) {
        _topTabbarItems = [NSMutableArray array];
    }
    return _topTabbarItems;
}


//省级别数据源
- (NSArray *)dataSouce {
    
    if (!_dataSouce) {
       
        _dataSouce = [[YWAddressDataTool sharedManager] queryAllProvince];
    }
    return _dataSouce;
}
@end
