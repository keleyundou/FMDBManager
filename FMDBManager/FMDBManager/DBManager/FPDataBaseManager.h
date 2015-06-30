//
//  FPDataBaseManager.h
//  FMDBManager
//
//  Created by 冰点 on 15/6/30.
//  Copyright (c) 2015年 冰点. All rights reserved.
//

#import "FPDataBaseMethods.h"

@interface FPDataBaseManager : FPDataBaseMethods

/**
 *  数据库管理类
 *
 *  @return self
 */
+ (id)manager;

/**
 *  创建数据库
 *
 *  @param db_file_name 存放数据库的文件夹
 *  @param objc         属性列表
 */
- (void) creatTableWithDatabaseFilename:(NSString *)db_file_name withObject:(NSObject*)objc;

/******************增 删 改 查******************/

/**
 *  增一条记录
 *
 *  @param objc 属性列表
 *
 *  @return 是否增加成功！
 */
- (BOOL) addOneRecord:(NSObject*)objc;

/**
 *  默认删除一条记录
 *
 *  @param objc        属性列表
 *  @param isDeleteAll 判断是否删除所有记录 默认为NO
 *
 *  @return 是否删除成功！
 */
- (BOOL) deleteOneRecord:(NSObject*)objc withAllDeleteRecord:(BOOL)isDeleteAll;

/**
 *  更新一条记录
 *
 *  @param objc 属性列表
 *
 *  @return 是否更新成功！
 */
- (BOOL) updateOneRecord:(NSObject*)objc;

/**
 *  获取所有记录
 *
 *  @param objc 属性列表
 *
 *  @return 返回查询后的结果
 */
- (id) getAllRecord:(NSObject*)objc;

/**
 *  根据条件获取记录
 *
 *  @param objc 属性列表
 *  @param idx  属性索引，idx同数组下标规范且>0 
 *
 *  @return 返回查询后的结果
 */
- (id)accordingToTheConditionGetRecord:(NSObject*)objc indexForObj_property_ts:(NSInteger)idx;
@end
