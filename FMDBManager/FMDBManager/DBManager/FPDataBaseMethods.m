//
//  FPDataBaseMethods.m
//  FMDBManager
//
//  Created by 冰点 on 15/6/30.
//  Copyright (c) 2015年 冰点. All rights reserved.
//

#import "FPDataBaseMethods.h"

#import "FMDatabase.h"
#import <objc/runtime.h>

@implementation FPDataBaseMethods
{
    FMDatabase * fmdb;
}

- (NSString *)getDataBasePath:(NSString*)file_name {
    NSString * dataBase_name = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@",file_name];
    NSLog(@"数据库的路径：%@",dataBase_name);
    return dataBase_name;
}

//创建一个表
- (void)createTable:(NSString*)sql dataBaseName:(NSString*)file_name{
    NSString * db_fileName = [self getDataBasePath:file_name];
    fmdb = [FMDatabase databaseWithPath:db_fileName];
    //打开数据库
    BOOL ret = [fmdb open];
    if (ret == NO) {
        NSLog(@"打开数据库失败");
        NSLog(@"%@",fmdb.lastErrorMessage);
    }else{
        BOOL ret = [fmdb executeUpdate:sql];
        if (ret == NO) {
            NSLog(@"创建表失败");
            NSLog(@"%@",fmdb.lastErrorMessage);
        }
        [fmdb close];
        NSLog(@"创建表成功");
        
    }
}
//执行SQL语句，主要完成增加、修改、删除
- (BOOL)executeUpdate:(NSString *)sql {
    BOOL ret = [fmdb open];
    if (ret) {
        ret = [fmdb executeUpdate:sql];
        if (ret) {
            return YES;
        } else {
            NSLog(@"执行SQL语句失败Error:%@",fmdb.lastError);
            [fmdb close];
            return NO;
        }
    } else {
        NSLog(@"打开数据库失败Error:%@",fmdb.lastError);
        return NO;
    }
}
//执行SQL语句，主要完成增加、修改、删除
- (BOOL)executeUpdate:(NSObject *)obj withInsert:(NSString *)insert_sql withUpdate:(NSString *)update_sql {
    //open db
    BOOL ret = [fmdb open];
    if (ret == NO) {
        NSLog(@"打开数据库失败Error:%@",fmdb.lastError);
        return NO;
    }
    NSString * sql = [self createexecuteQuerySql:obj];
    FMResultSet * resultSet = [fmdb executeQuery:sql];
    ret = NO;
    while ([resultSet next]) {
        ret = YES;
    }
    if (!ret) {
        resultSet = [fmdb executeQuery:sql];
        while ([resultSet next]) {
            ret = YES;
        }
    }
    if (!ret) {
        //若表内没有重复的记录 则插入
        ret = [fmdb executeUpdate:insert_sql];
    } else {
        ret = [fmdb executeUpdate:update_sql];
    }
    
    if (ret == NO) {
        NSLog(@"执行SQL语句失败Error:%@",fmdb.lastError);
        [fmdb close];
        return NO;
    }
    return YES;
}


//选择数据
- (id)executeQuery:(NSString *)sql withObject:(NSObject *)obj {
    unsigned int count;
    objc_property_t * objc_property_ts = class_copyPropertyList([obj class], &count);
    BOOL ret = [fmdb open];
    if (ret == NO) {
        NSLog(@"打开数据库失败Error:%@",fmdb.lastError);
        return nil;
    }
    FMResultSet * resultSet = [fmdb executeQuery:sql];
    NSMutableArray * responseObject = [NSMutableArray array];//存放查询后的数据
    while ([resultSet next]) {
        NSMutableDictionary * resultDictonary = [NSMutableDictionary dictionary];
        for (int i = 0; i < count; i++) {
            objc_property_t property = objc_property_ts[i];
            NSString * property_name = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
            id property_value = [resultSet objectForColumnName:property_name];
            if (property_value) {
                [resultDictonary setObject:property_value forKey:property_name];
            }
        }
        [responseObject addObject:resultDictonary];
    }
    [fmdb close];
    NSLog(@"查询完！");
    NSDictionary * data = @{@"ret":@(0),
                            @"count":@(responseObject.count),
                            @"data":responseObject
                            };
    return data;
}
//
- (NSString*)createexecuteQuerySql:(NSObject*)obj {
    unsigned int count;
    NSString * table_name = [NSString stringWithUTF8String:object_getClassName(obj)];
    objc_property_t * objc_property_ts = class_copyPropertyList([obj class], &count);
    objc_property_t property = objc_property_ts[1];
    NSString * property_name = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
    id property_value = [obj valueForKey:property_name];
    NSString * sql = [NSString stringWithFormat:@"select * from '%@' where %@='%@';",table_name,property_name,property_value];
    return sql;
}
@end
