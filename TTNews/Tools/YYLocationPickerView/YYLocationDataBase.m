//
//  YYLocationDataBase.m
//  YYPickerViewDemo
//
//  Created by 房俊杰 on 2017/2/26.
//  Copyright © 2017年 上海涵予信息科技有限公司. All rights reserved.
//

#import "YYLocationDataBase.h"

#import "FMDatabase.h"

@interface YYLocationDataBase ()
/** 单例数据库 */
@property (nonatomic,strong) FMDatabase *dataBase;

@end

@implementation YYLocationDataBase

static YYLocationDataBase *_sharedDataBase;


+ (YYLocationDataBase *)sharedDataBase
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedDataBase = [[YYLocationDataBase alloc] init];
    });
    return _sharedDataBase;
}

//创建数据库
- (void)createDataBase
{
    self.dataBase = [[FMDatabase alloc] initWithPath:[[NSBundle mainBundle] pathForResource:@"YYLocationPickerView.bundle/location"ofType:@"db"]];
    if([self.dataBase open])
    {
        NSLog(@"区域选择数据库创建打开成功");
    }
    else
    {
        NSLog(@"区域选择数据库创建打开失败");
    }
}

//查询数据
- (NSArray *)selectValueWithPid:(NSString *)pid
{
    [self.dataBase open];
    FMResultSet *res;
    if([pid integerValue] == 0)
    {
        res = [self.dataBase executeQuery:@"select *from location where level=1 order by id asc"];
    }
    else
    {
        res = [self.dataBase executeQuery:@"select *from location where upid=?",pid];
    }
    NSMutableArray *array = [[NSMutableArray alloc] init];
    while ([res next]) {
        YYLocationDataBaseModel *model = [[YYLocationDataBaseModel alloc] init];
        model.ID = [res stringForColumn:@"id"];
        model.title = [res stringForColumn:@"name"];
        model.pid = [res stringForColumn:@"upid"];
        [array addObject:model];
    }
    [self.dataBase close];
    return array;
}

-(NSString *)GetAddressName:(NSInteger)pid{
    [self.dataBase open];
    FMResultSet *res;
    NSString* address = @"";
    res = [self.dataBase executeQuery:@"select *from location where id=%@",pid];
    while ([res next]) {
        address = [res stringForColumn:@"name"];
        break;
    }
    [self.dataBase close];
    return address;
}

-(NSInteger) GetAddressID:(NSString* )addressName{
    [self.dataBase open];
    FMResultSet *res;
    NSInteger ID = 0;
    NSString * str = [NSString stringWithFormat:@"select * from location where name like \"%@\"",addressName];
    res = [self.dataBase
           executeQuery:str];
    while ([res next]) {
        ID = [[res stringForColumn:@"id"] integerValue];
        break;
    }
    [self.dataBase close];
    return ID;
}

@end

@implementation YYLocationDataBaseModel

- (instancetype)initWithID:(NSString *)ID andTitle:(NSString *)title andPid:(NSString *)pid
{
    self = [super init];
    if (self) {
        
        self.ID = ID;
        self.title = title;
        self.pid = pid;
    }
    return self;
}
@end

