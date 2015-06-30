//
//  FPDataBaseManager.m
//  FMDBManager
//
//  Created by 冰点 on 15/6/30.
//  Copyright (c) 2015年 冰点. All rights reserved.
//

#import "FPDataBaseManager.h"

#import <objc/runtime.h>

@implementation FPDataBaseManager

+ (id)manager{
    static FPDataBaseManager * db_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        db_manager = [[self alloc] init];
    });
    return db_manager;
}

#pragma mark - public

//TODO:创建数据库
- (void)creatTableWithDatabaseFilename:(NSString *)db_file_name withObject:(NSObject*)objc{
    NSString * sql = [self theDatabaseSQLToCreateSyntax:objc];
    NSLog(@"\\ create : \\%@",sql);
    [self createTable:sql dataBaseName:db_file_name];
}

//TODO:增一条记录
- (BOOL)addOneRecord:(NSObject *)objc {
    NSString * insert_sql = [self theDatabaseSQLToInsertSyntax:objc];
    NSString * update_sql = [self theDatabaseSQLToUpdateSyntax:objc];
    return [self executeUpdate:objc withInsert:insert_sql withUpdate:update_sql];
}

//TODO:默认删除一条记录
- (BOOL)deleteOneRecord:(NSObject *)objc withAllDeleteRecord:(BOOL)isDeleteAll{
    if (isDeleteAll) {
        NSString * table_name = [NSString stringWithUTF8String:object_getClassName(objc)];
        NSString * sql = [NSString stringWithFormat:@"delete from '%@';",table_name];
        NSLog(@"\\ delete all : \\ %@",sql);
        return [self executeUpdate:sql];
    }
    NSString * sql = [self theDatabaseSQLToDeleteSyntax:objc];
    NSLog(@"\\ delete : \\%@",sql);
    return [self executeUpdate:sql];
}

//TODO:更新一条记录
- (BOOL)updateOneRecord:(NSObject*)objc {
    NSString * sql = [self theDatabaseSQLToUpdateSyntax:objc];
    NSLog(@"\\ update : \\%@",sql);
    return [self executeUpdate:sql];
}

//TODO:获取所有记录
- (id)getAllRecord:(NSObject*)objc {
    NSString * sql = [self theDatabaseSQLToSelectSyntax:objc];
    NSLog(@"\\ select all: \\%@",sql);
    return [self executeQuery:sql withObject:objc];
}

//TODO:根据条件获取记录
- (id)accordingToTheConditionGetRecord:(NSObject*)objc indexForObj_property_ts:(NSInteger)idx{
    NSString * sql = [self createexecuteQuerySql:objc indexForObj_property_ts:idx];
    return [self executeQuery:sql withObject:objc];
}

#pragma mark - private
//默认创建添加主键ID
- (NSString*)theDatabaseSQLToCreateSyntax:(NSObject*)obj{
    //表名
    NSString * table_name = [NSString stringWithUTF8String:object_getClassName(obj)];
    NSMutableString * db_sql = [NSMutableString stringWithFormat:@"create table if not exists %@ (",table_name];
    unsigned int count;
    objc_property_t * objc_property_ts = class_copyPropertyList([obj class], &count);
    for (int i = 0; i < count; i++) {
        objc_property_t property = objc_property_ts[i];
        NSString * property_name = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        if (i == 0) {
#if 0
            [db_sql appendFormat:@"'%@' integer primary key autoincrement,",property_name];
#else
            [db_sql appendFormat:@"ID integer primary key autoincrement,"];
#endif
            
        } else {
            if (i == (count-1)) {
                [db_sql appendFormat:@"%@);",property_name];
            } else {
                [db_sql appendFormat:@"%@,",property_name];
            }
        }
    }
    return db_sql;
}

//TODO:add one record into Database
- (NSString*)theDatabaseSQLToInsertSyntax:(NSObject*)obj {
    unsigned int count;
    objc_property_t * objc_property_ts = class_copyPropertyList([obj class], &count);
    NSString * table_name = [NSString stringWithUTF8String:object_getClassName(obj)];
    NSMutableString * db_sql = [[NSMutableString alloc] initWithFormat:@"insert into '%@' (",table_name];
    for (int i = 1; i < count; i++) {
        objc_property_t property = objc_property_ts[i];
        NSString * property_name = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        if (i == (count-1)) {
            [db_sql appendFormat:@"%@) values (",property_name];
            int n = 1;
            while (n < count) {
                property = objc_property_ts[n];
                property_name = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
                id property_value = [obj valueForKey:property_name];
                if (property_value) {
                    if (n == (count-1)) {
                        [db_sql appendFormat:@"'%@');",property_value];
                    } else {
                        [db_sql appendFormat:@"'%@',",property_value];
                    }
                }
                n++;
            }
            
        } else {
            [db_sql appendFormat:@"%@,",property_name];
        }
    }
    return db_sql;
}

//TODO:delete one record into Database 根据 (stu_id) 删除某一条记录
- (NSString*)theDatabaseSQLToDeleteSyntax:(NSObject*)obj {
    unsigned int count;
    objc_property_t * objc_property_ts = class_copyPropertyList([obj class], &count);
    objc_property_t property = objc_property_ts[1];
    NSString * property_name = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
    id property_value = [obj valueForKey:property_name];
    NSString * table_name = [NSString stringWithUTF8String:object_getClassName(obj)];
    if (property_value) {
        NSString * db_sql = [[NSString alloc] initWithFormat:@"delete from '%@' where %@='%@';",table_name,property_name,property_value];
        return db_sql;
    }
    return nil;
}

//TODO:update one record into database 根据 (stu_id) 更新某一条记录
- (NSString*)theDatabaseSQLToUpdateSyntax:(NSObject*)obj {
    unsigned int count;
    objc_property_t * objc_property_ts = class_copyPropertyList([obj class], &count);
    NSString * table_name = [NSString stringWithUTF8String:object_getClassName(obj)];
    NSMutableString * db_sql = [[NSMutableString alloc] initWithFormat:@"update '%@' set ",table_name];
    NSString * where_sql;
    for (int i = 1; i < count; i++) {
        objc_property_t property = objc_property_ts[i];
        NSString * property_name = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        id property_value = [obj valueForKey:property_name];
        if (property_value) {
            if (i == 1) {
                where_sql = [NSString stringWithFormat:@"where %@='%@';",property_name,property_value];
            }
            if (i == (count-1)) {
                [db_sql appendFormat:@"%@='%@' %@",property_name,property_value,where_sql];
            } else {
                [db_sql appendFormat:@"%@='%@', ",property_name,property_value];
            }
        }
    }
    return db_sql;
}

//TODO:get all record 获取所有的数据
- (NSString*)theDatabaseSQLToSelectSyntax:(NSObject*)obj {
    NSString * table_name = [NSString stringWithUTF8String:object_getClassName(obj)];
    NSString * db_sql = [NSString stringWithFormat:@"select * from '%@';",table_name];
    return db_sql;
}

- (NSString*)createexecuteQuerySql:(NSObject*)obj indexForObj_property_ts:(NSInteger)idx{
    unsigned int count;
    NSString * table_name = [NSString stringWithUTF8String:object_getClassName(obj)];
    objc_property_t * objc_property_ts = class_copyPropertyList([obj class], &count);
    if (idx<=0) {idx = 1;}
    objc_property_t property = objc_property_ts[idx];
    NSString * property_name = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
    id property_value = [obj valueForKey:property_name];
    NSString * sql = [NSString stringWithFormat:@"select * from '%@' where %@='%@';",table_name,property_name,property_value];
    return sql;
}
@end
