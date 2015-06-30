FMDBManager
===========

![License MIT](https://go-shields.herokuapp.com/license-MIT-blue.png)


使用简单方便，只需创建继承NSObject对象并添加属性即可根据属性名自动创建SQL语句，不用每次去写冗长的SQL语句。

注意：属性名须包含主键

```
@property (nonatomic,strong) NSNumber * ID;
```

##使用方法

#####增加一条数据

```
 FPDataBaseManager * manager = [FPDataBaseManager manager];
 //创建数据库文件
 [manager creatTableWithDatabaseFilename:@"sutdent.db" withObject:self];
 //增加一条数据
 [manager addOneRecord:self];
 
```

#####更新一条数据

```
 [manager updateOneRecord:self];
```

#####删除所有数据

```
[manager deleteOneRecord:self withAllDeleteRecord:YES];
```
#####更具条件获取数据

```
[manager accordingToTheConditionGetRecord:self indexForObj_property_ts:1];
```