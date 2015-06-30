//
//  FPDataBaseMethods.h
//  FMDBManager
//
//  Created by 冰点 on 15/6/30.
//  Copyright (c) 2015年 冰点. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FPDataBaseMethods : NSObject
/**
 *  创建一个表
 *
 *  @param sql       执行的SQL语句
 *  @param file_name 数据库所在的文件夹名称
 */
- (void)createTable:(NSString*)sql dataBaseName:(NSString*)file_name;

/**
 *  执行SQL语句，主要完成增加、修改、删除
 *
 *  @param sql 执行的SQL语句
 *
 *  @return 是否执行成功
 */
- (BOOL)executeUpdate:(NSString*)sql;
/**
 *  执行SQL语句，主要完成增加、修改、删除
 *
 *  @param obj        属性列表
 *  @param insert_sql 插入语句
 *  @param update_sql 更新语句
 *
 *  @return 是否执行成功
 */
- (BOOL)executeUpdate:(NSObject*)obj withInsert:(NSString*)insert_sql withUpdate:(NSString*)update_sql;

/**
 *  选择数据
 *
 *  @param sql 执行的SQL语句
 *  @param obj 属性列表
 *
 *  @return 查询后的数据结果
 */
- (id)executeQuery:(NSString*)sql withObject:(NSObject*)obj;
@end
