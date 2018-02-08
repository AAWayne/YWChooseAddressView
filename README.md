# YWChooseAddressView

> 高仿京东地区选择器、高仿淘宝新增地址UI

### 一、UI效果图
<div align="center">    
	<img src = "./UI效果图1.jpeg" width = "240" height = "430" alt="图片名称" align = center />
	<img src = "./UI效果图2.jpeg" width = "240" height = "430" alt="图片名称" align = center />
	<img src = "./UI效果图3.jpeg" width = "240" height = "430" alt="图片名称" align = center />
</div>

### 二、具体功能：

**1、可直接从通讯录获取联系人信息（姓名、电话）**

**2、可是用封装好的高仿淘宝UI直接进行新增或编辑地址信息**


### 三、推荐使用`CocoaPods`方式集成
**1、在podfile文件中添加，然后执行 `pod install`操作**

```
pod 'YWChooseAddressView', '~> 1.0.7'
```

**2、在基类或者将要使用的界面导入`YWAddressDataTool`，本地初始化地区信息数据库**

```
#import "YWAddressDataTool.h"

- (void)viewDidLoad {
    [super viewDidLoad];
    // 开启异步线程初始化数据
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 预加载地区信息到本地数据库（避免UI卡顿）
        [[YWAddressDataTool sharedManager] requestGetData];
    });
}

```
**3、如果使用`高仿淘宝UI`则直接导入YWUI文件夹中的`YWAddressViewController.h`**

```
// 这里传入需要编辑的地址信息（如果为新增地址则无需传入model）
YWAddressViewController *addressVC = [[YWAddressViewController alloc] init];
YWAddressInfoModel *model = [YWAddressInfoModel alloc];
model.phoneStr = @"18888888888";
model.nameSrt = @"袁伟";
model.areaAddress = @"四川省成都市武侯区";
model.detailAddress = @"下一站都市B座406";
model.isDefaultAddress = YES; // 如果是默认地址则传入YES
addressVC.model = model;
[self.navigationController pushViewController:addressVC animated:YES];
```

**4、如果使用`高仿淘宝UI`则还需在`Info.plist`中添加通讯录权限**

```
key值：Privacy - Contacts Usage Description
value值：如果不允许，则无法从通讯录中选择联系人信息
```

**简书地址：https://www.jianshu.com/p/cd7b97a53603**

<div align="center">    
	<img src = "http://upload-images.jianshu.io/upload_images/2822163-b2da3cbb19aa123f.png" width = "300" height = "100" alt="图片名称" align = center />
</div>
