//
//  ViewController.h
//  FMDBManager
//
//  Created by 冰点 on 15/6/30.
//  Copyright (c) 2015年 冰点. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (nonatomic,strong) NSNumber * ID;//数据库默认主键，此属性不能省略

@property (nonatomic,strong) NSNumber * stu_id;
@property (nonatomic,strong) NSString * stu_name;
@property (nonatomic,strong) NSString * stu_sex;
@property (nonatomic,strong) NSNumber * stu_age;

@end

