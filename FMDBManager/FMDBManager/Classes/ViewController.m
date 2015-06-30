//
//  ViewController.m
//  FMDBManager
//
//  Created by 冰点 on 15/6/30.
//  Copyright (c) 2015年 冰点. All rights reserved.
//

#import "ViewController.h"

#import "FPDataBaseManager.h"
@interface ViewController ()

@end

@implementation ViewController

-(NSNumber *)stu_id{
    return @(20150630);
}
-(NSString *)stu_name{
    return @"冰点";
}
-(NSString *)stu_sex{
    return @"m";
}
-(NSNumber *)stu_age{
    return @(23);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self operation];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//TODO:...
- (void)operation {
    FPDataBaseManager * manager = [FPDataBaseManager manager];
    [manager creatTableWithDatabaseFilename:@"sutdent.db" withObject:self];
    [manager addOneRecord:self];
    //    [manager updateOneRecord:self];
    //    [manager deleteOneRecord:self withAllDeleteRecord:YES];
    id result =/* [manager getAllRecord:self]*/[manager accordingToTheConditionGetRecord:self indexForObj_property_ts:1];
    
    NSLog(@"%@",result);
}

@end
