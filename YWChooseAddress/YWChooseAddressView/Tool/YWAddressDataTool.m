//
//  YWAddressDataTool.m
//  YWChooseAddressView
//
//  Created by 90Candy on 17/12/25.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "YWAddressDataTool.h"
#import "FMDB.h"
#import "YWAddressModel.h"

static NSString * const dbName = @"YWAddressDB.db";
static NSString * const locationTabbleName = @"addressTabble";

@interface YWAddressDataTool ()
@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic, strong) FMDatabase *fmdb;
@end

@implementation YWAddressDataTool

static YWAddressDataTool *shareInstance = nil;

#pragma mark - Singleton
+ (YWAddressDataTool *)sharedManager {
    @synchronized (self) {
        if (!shareInstance) {
            shareInstance = [[self alloc] init];
        }
    }
    return shareInstance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    @synchronized (self) {
        if (!shareInstance) {
            shareInstance = [super allocWithZone:zone];
        }
    }
    return shareInstance;
}

- (id)copy {
    return shareInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        [self creatDB];
    }
    return self;
}

// 创建数据库
- (void)creatDB {
    
    NSString *dbPath = [self pathForName:dbName];
    self.fmdb = [FMDatabase databaseWithPath:dbPath];
}
- (void)deleteDB {
    NSString *dbPath = [self pathForName:dbName];
    [[NSFileManager defaultManager] removeItemAtPath:dbPath error:nil];
}

//获得指定名字的文件的全路径
- (NSString *)pathForName:(NSString *)name {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths lastObject];
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:name];
    NSLog(@"数据库地址：\n%@", dbPath);
    return dbPath;
}

// 判断是否存在表
- (BOOL) isTableOK {
    BOOL openSuccess = [self.fmdb open];
    if (!openSuccess) {
        NSLog(@"地址数据库打开失败");
    } else {
        NSLog(@"地址数据库打开成功");
        FMResultSet *rs = [self.fmdb executeQuery:@"SELECT count(*) as 'count' FROM sqlite_master WHERE type ='table' and name = ?", locationTabbleName];
        while ([rs next]) {
            // just print out what we've got in a number of formats.
            NSInteger count = [rs intForColumn:@"count"];
            if (0 == count) {
                [self.fmdb close];
                return NO;
            } else {
                [self.fmdb close];
                return YES;
            }
        }
    }
    [self.fmdb close];
    return NO;
}


//发送网络请求，获取省市区数据，这里用的是本地json数据
- (void)requestGetData {
    // 开启异步线程初始化数据
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([self isTableOK]) {
            return;
        }
        
        NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"Cities" ofType:@"json"];
        NSData *data=[NSData dataWithContentsOfFile:jsonPath];
        NSError *error;
        NSArray * jsonObjectArray =[NSJSONSerialization JSONObjectWithData:data
                                                                   options:kNilOptions
                                                                     error:&error];
        
        for (NSDictionary * dict in jsonObjectArray) {
            YWAddressModel * item = [[YWAddressModel alloc] initWithDict:dict];
            [self.dataArray addObject:item];
        }
        if(self.dataArray.count > 0  && [self createTable]) {
            
            [self insertRecords];
        }
    });
}

//往表插入数据
- (void)insertRecords {
    
    NSDate *startTime = [NSDate date];
    // 开启事务
    if ([self.fmdb open] && [self.fmdb beginTransaction]) {
        
        BOOL isRollBack = NO;
        @try {
            for (YWAddressModel * item in self.dataArray) {
                
                if (item.level.intValue == 3 && [item.name isEqualToString:@"市辖区"]) {
                    continue;
                }
                
                NSString *insertSql= [NSString stringWithFormat:
                                      @"INSERT INTO %@ ('code','sheng','di','xian','name', 'level') VALUES ('%@','%@','%@','%@','%@','%@')",
                                      locationTabbleName,item.code, item.sheng,item.di,item.xian ,item.name, item.level];
                BOOL a = [self.fmdb executeUpdate:insertSql];
                if (!a) {
                    NSLog(@"插入地址信息数据失败");
                }
                else {
                    NSLog(@"批量插入地址信息数据成功！");
                    
                }
            }
            NSDate *endTime = [NSDate date];
            NSTimeInterval a = [endTime timeIntervalSince1970] - [startTime timeIntervalSince1970];
            NSLog(@"使用事务批量插入地址信息用时%.3f秒",a);
            
        }
        @catch (NSException *exception) {
            isRollBack = YES;
            [self.fmdb rollback];
        }
        @finally {
            if (!isRollBack) {
                [self.fmdb commit];
            }
        }
        [self.fmdb close];
        
    } else {
        [self insertRecords];
    }
}


// 删除表
- (BOOL)deleteTable {
    
    BOOL openSuccess = [self.fmdb open];
    if (!openSuccess) {
        NSLog(@"地址数据库打开失败");
    } else {
        NSLog(@"地址数据库打开成功");
        NSString *sqlstr = [NSString stringWithFormat:@"DROP TABLE %@", locationTabbleName];
        
        if (![self.fmdb executeUpdate:sqlstr])
        {
            [self.fmdb close];
            return NO;
        }
    }
    [self.fmdb close];
    return YES;
}

//创建表
- (BOOL)createTable {
    
    BOOL result = NO;
    BOOL openSuccess = [self.fmdb open];
    if (!openSuccess) {
        NSLog(@"地址数据库打开失败");
    } else {
        //'code','sheng','di','xian','name', 'level'
        NSString *sql = [NSString stringWithFormat:@"create table if not exists %@ (code text primary key,sheng text,di text,xian text,name text,level text);",locationTabbleName];
        result = [self.fmdb executeUpdate:sql];
        if (!result) {
            NSLog(@"创建地址表失败");
            
        } else {
            NSLog(@"创建地址表成功");
        }
    }
    [self.fmdb close];
    return result;
}

//根据areaLevel 查询
- (NSMutableArray *)queryAllProvince {
    if ([self.fmdb  open]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE `level` = 1", locationTabbleName];
        FMResultSet *result = [self.fmdb  executeQuery:sql];
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
        //'code','sheng','di','xian','name', 'level'
        while ([result next]) {
            YWAddressModel *model = [[YWAddressModel alloc] init];
            model.code = [result stringForColumn:@"code"];
            model.sheng = [result stringForColumn:@"sheng"];
            model.di = [result stringForColumn:@"di"];
            model.xian = [result stringForColumn:@"xian"];
            model.name = [result stringForColumn:@"name"];
            model.level = [result stringForColumn:@"level"];
            [array addObject:model];
        }
        [self.fmdb close];
        return array;
    }
    return nil;
}

//根据areaCode, 查询地址
- (NSString *)queryAllRecordWithAreaCode:(NSString *)areaCode {
    if ([self.fmdb  open]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE  `code` = %@"  , locationTabbleName,areaCode];
        FMResultSet *result = [self.fmdb  executeQuery:sql];
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
        //'code','sheng','di','xian','name', 'level'
        while ([result next]) {
            YWAddressModel *model = [[YWAddressModel alloc] init];
            model.code = [result stringForColumn:@"code"];
            model.sheng = [result stringForColumn:@"sheng"];
            model.di = [result stringForColumn:@"di"];
            model.xian = [result stringForColumn:@"xian"];
            model.name = [result stringForColumn:@"name"];
            model.level = [result stringForColumn:@"level"];
            [array addObject:model];
        }
        [self.fmdb close];
        if (array.count > 0) {
            YWAddressModel * model = array.firstObject;
            return model.name;
        }
    }
    return nil;
}

//根据areaLevel级别，省ID 查询 市
- (NSMutableArray *)queryAllRecordWithSheng:(NSString *)sheng {
    if ([self.fmdb  open]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE `level` = 2 AND  `sheng` = %@"  , locationTabbleName,sheng];
        FMResultSet *result = [self.fmdb  executeQuery:sql];
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
        //'code','sheng','di','xian','name', 'level'
        while ([result next]) {
            YWAddressModel *model = [[YWAddressModel alloc] init];
            model.code = [result stringForColumn:@"code"];
            model.sheng = [result stringForColumn:@"sheng"];
            model.di = [result stringForColumn:@"di"];
            model.xian = [result stringForColumn:@"xian"];
            model.name = [result stringForColumn:@"name"];
            model.level = [result stringForColumn:@"level"];
            [array addObject:model];
        }
        [self.fmdb close];
        return array;
    }
    return nil;
}

//根据areaLevel级别,省ID(sheng)  ,查询 市
- (NSMutableArray *)queryAllRecordWithShengID:(NSString *)sheng {
    
    if ([self.fmdb  open]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE `level` = 2 AND  `sheng` = %@ "  , locationTabbleName,sheng];
        FMResultSet *result = [self.fmdb  executeQuery:sql];
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
        while ([result next]) {
            YWAddressModel *model = [[YWAddressModel alloc] init];
            model.code = [result stringForColumn:@"code"];
            model.sheng = [result stringForColumn:@"sheng"];
            model.di = [result stringForColumn:@"di"];
            model.xian = [result stringForColumn:@"xian"];
            model.name = [result stringForColumn:@"name"];
            model.level = [result stringForColumn:@"level"];
            [array addObject:model];
        }
        [self.fmdb close];
        return array;
    }
    return nil;
    
}


//根据areaLevel级别,省ID(sheng) , 市ID(di) ,查询 县
- (NSMutableArray *)queryAllRecordWithShengID:(NSString *)sheng cityID:(NSString *)di {
    
    if ([self.fmdb  open]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE `level` = 3 AND  `sheng` = %@  AND `di` = '%@'"  , locationTabbleName,sheng,di];
        FMResultSet *result = [self.fmdb  executeQuery:sql];
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
        while ([result next]) {
            YWAddressModel *model = [[YWAddressModel alloc] init];
            model.code = [result stringForColumn:@"code"];
            model.sheng = [result stringForColumn:@"sheng"];
            model.di = [result stringForColumn:@"di"];
            model.xian = [result stringForColumn:@"xian"];
            model.name = [result stringForColumn:@"name"];
            model.level = [result stringForColumn:@"level"];
            [array addObject:model];
        }
        [self.fmdb close];
        return array;
    }
    return nil;

}

- (NSMutableArray *)dataArray {
    
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

@end
