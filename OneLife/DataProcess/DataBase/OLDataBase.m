//
//  OLDataBase.m
//  OneLife
//
//  Created by hitomedia on 2017/10/23.
//  Copyright © 2017年 wkun. All rights reserved.
//

#import "OLDataBase.h"
#import <sqlite3.h>
#import "NSString+Ext.h"
#import "OLTargetModel.h"
#import "OLTargetDataModel.h"
#import "OLRecordTimeModel.h"
#import "OLRecordTimeDataModel.h"

//表名
static NSString * const tableUserInfo = @"table_user_info";
static NSString * const tableSchedule = @"table_schedule_list";//日程表
static NSString * const tableScheduleState = @"table_schedule_status"; //日程状态表
static NSString * const tableTimeRecord = @"table_time_record";//时间记录表
static NSString * const tableTarget = @"table_target";  //目标表
static NSString * const tableTargetInvestmentTime = @"table_target_investment"; //目标投入时间表

@interface OLDataBase ()
@property (nonatomic, assign) sqlite3 *oneLifeDB; //计划表数据库
@end

@implementation OLDataBase

+ (OLDataBase *)shareDataBase{
    static OLDataBase *db = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        db = [OLDataBase new];
    });
    return db;
}

#pragma mark - 计划表

- (BOOL)addTargetWithName:(NSString *)name description:(NSString *)des endDate:(NSString *)endDate needHours:(NSInteger)needHours userId:(NSString *)uid{
    sqlite3_stmt *statement;
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@(name,content,endDate, createTime,needHours, type, state, userId) VALUES (?,?,?,?,?,?,?,?)", tableTarget];
    int success = sqlite3_prepare(self.oneLifeDB, [sql UTF8String], -1, &statement, NULL);
    if( success != SQLITE_OK ){
        return NO;
    }
    
    //绑定问号对应变量
    sqlite3_bind_text(statement, 1, [name UTF8String], -1, SQLITE_TRANSIENT);
    NSString *cnt = des;
    if( cnt==nil ) cnt = @"";
    sqlite3_bind_text(statement, 2, [cnt UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(statement, 3, [endDate UTF8String], -1, SQLITE_TRANSIENT);
    NSString *ctime = [NSString stringWithDate:[NSDate new] format:@"yyyy-MM-dd HH:mm:ss"];
    sqlite3_bind_text(statement, 4, [ctime UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int (statement, 5, (int)needHours);
    sqlite3_bind_int (statement, 6, 0);
    sqlite3_bind_int (statement, 7, 0);
    sqlite3_bind_int (statement, 8, (int)uid);
    
    //执行插入
    success = sqlite3_step(statement);
    //释放statement
    sqlite3_finalize(statement);
    
    if( success == SQLITE_ERROR )
        return NO;
    
    return YES;
}
//state Integer, name text, content text, createTime text, endDate text, needHours Integer, type Integer, userId Integer
- (NSArray*)targetList{
    NSMutableArray *arr = [NSMutableArray array];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ order by endDate ASC",tableTarget];
    sqlite3_stmt *statement;
    const char *err;
    
    if( sqlite3_prepare_v2(self.oneLifeDB, [sql UTF8String], -1, &statement, &err) == SQLITE_OK){
//        int i=0;
        while (sqlite3_step(statement) == SQLITE_ROW ) {

            OLTargetDataModel *tm = [OLTargetDataModel new];
            tm.ID = [self sqliteColumnIntWithStatement:statement index:0];
            tm.status = [self sqliteColumnIntWithStatement:statement index:1];
            tm.name = [self sqlietColumnTextWithStatement:statement index:2];
            tm.content = [self sqlietColumnTextWithStatement:statement index:3];
            tm.createTime = [self sqlietColumnTextWithStatement:statement index:4];
            tm.endDate = [self sqlietColumnTextWithStatement:statement index:5];
            tm.needHours = [self sqliteColumnIntWithStatement:statement index:6];
            tm.type = [self sqliteColumnIntWithStatement:statement index:7];
            
//            int iditify = sqlite3_column_int(statement, 0);
//            sqlite3_value *sv = sqlite3_column_value(statement, 0);
//            sqlite3_value *sv1 = sqlite3_column_value(statement, 2);
////            [arr addObject:dm];
//            unsigned char *sv1text1 = sqlite3_value_text(sv);
//            unsigned char *sv1text = sqlite3_value_text(sv1);
//            int svInt = sqlite3_value_int(sv);
//            int svO = sqlite3_value_int(sv1);
            OLTargetModel *model = [OLTargetModel targetModelWithDm:tm];
            if( model )
                [arr addObject:model];
            
//            i++;
        }
    }
    
    sqlite3_finalize(statement);
    if( arr.count <=0  )
        arr = nil;
    return arr;

}
//create table if not exists %@ (ID Integer PRIMARY KEY AUTOINCREMENT, content text,  startTime text, endTime text, targetID int,targetName text, type int, date text,userId int
#pragma mark - 时间记录表
- (BOOL)addRecordWithStartTime:(NSString *)startTime endTime:(NSString *)endTime content:(NSString *)content type:(NSString *)type targetId:(NSString *)targetId targetName:(NSString *)targetName date:(NSString*)date userId:(NSString*)uid{

    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@(content,startTime,endTime,targetID,targetName,type,date,userId) VALUES (?,?,?,?,?,?,?,?)",tableTimeRecord];
    sqlite3_stmt *stmt;
    int sucess = sqlite3_prepare(self.oneLifeDB, [sql UTF8String], -1, &stmt, NULL);
    if( sucess != SQLITE_OK ){
        return NO;
    }
    
    //绑定问号对应的变量
    [self sqliteBindText:content statement:stmt index:1];
    [self sqliteBindText:startTime statement:stmt index:2];
    [self sqliteBindText:endTime statement:stmt index:3];
    sqlite3_bind_int(stmt,4, targetId.intValue);
    [self sqliteBindText:targetName statement:stmt index:5];
    sqlite3_bind_int(stmt,6, type.intValue);
    [self sqliteBindText:date statement:stmt index:7];
    sqlite3_bind_int(stmt, 8,uid.intValue);
    //执行插入
    sucess = sqlite3_step(stmt);
    
    sqlite3_finalize(stmt);
    if( sucess == SQLITE_ERROR )
        return NO;
    return YES;
}
//"create table if not exists %@ (ID Integer PRIMARY KEY AUTOINCREMENT, content text,  startTime text, endTime text, targetID int,targetName text, type int, date text)
- (NSArray *)recordDataWithDate:(NSString *)date{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@",tableTimeRecord];
    if( date.length ){
        sql = [NSString stringWithFormat:@"%@ WHERE date='%@'",sql,date];
    }
    sqlite3_stmt *stmt;
    int success = sqlite3_prepare(self.oneLifeDB, sql.UTF8String, -1, &stmt, NULL);
    if( success != SQLITE_OK){
        return nil;
    }
    
    NSMutableArray *arr = [NSMutableArray new];
    while( sqlite3_step(stmt) == SQLITE_ROW ){
        OLRecordTimeDataModel *dm = [OLRecordTimeDataModel new];
        dm.ID = [self sqliteColumnIntWithStatement:stmt index:0];
        dm.content = [self sqlietColumnTextWithStatement:stmt index:1];
        dm.startTime = [self sqlietColumnTextWithStatement:stmt index:2];
        dm.endTime = [self sqlietColumnTextWithStatement:stmt index:3];
        dm.targetId = [self sqliteColumnIntWithStatement:stmt index:4];
        dm.targetName = [self sqlietColumnTextWithStatement:stmt index:5];
        dm.type = [self sqliteColumnIntWithStatement:stmt index:6];
        dm.date = [self sqlietColumnTextWithStatement:stmt index:7];
        
        OLRecordTimeModel *tm = [OLRecordTimeModel recordTimeModelWithDm:dm];
        if( tm ) [arr addObject:tm];
    }
    sqlite3_finalize(stmt);
    
    if( arr.count )
        return  arr;
    return nil;
}

- (OLRecordTimeModel *)lastRecordTimeModelWithDate:(NSString *)date userId:(NSString *)uid{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE date='%@' AND userId=%@ AND endTime=(SELECT MAX(endTime) FROM %@)",tableTimeRecord,date,uid,tableTimeRecord];
    sqlite3_stmt *stmt;
    int success = sqlite3_prepare(self.oneLifeDB, sql.UTF8String, -1, &stmt, NULL);
    if( success != SQLITE_OK ){
        return nil;
    }
    OLRecordTimeModel *tm =nil;
    while (sqlite3_step(stmt)==SQLITE_ROW ) {
        OLRecordTimeDataModel *dm = [OLRecordTimeDataModel new];
        dm.ID = [self sqliteColumnIntWithStatement:stmt index:0];
        dm.content = [self sqlietColumnTextWithStatement:stmt index:1];
        dm.startTime = [self sqlietColumnTextWithStatement:stmt index:2];
        dm.endTime = [self sqlietColumnTextWithStatement:stmt index:3];
        dm.targetId = [self sqliteColumnIntWithStatement:stmt index:4];
        dm.targetName = [self sqlietColumnTextWithStatement:stmt index:5];
        dm.type = [self sqliteColumnIntWithStatement:stmt index:6];
        dm.date = [self sqlietColumnTextWithStatement:stmt index:7];
        
        tm = [OLRecordTimeModel recordTimeModelWithDm:dm];
    }
    sqlite3_finalize(stmt);
    
    return tm;
}

#pragma mark - Private

- (NSString *)getDbPathWithName:(NSString *)name{
    return [self getDbPathWithName:name isCommonDir:NO];
}

/**
 获取数据库的目录
 
 @param name 数据库的名字
 @param iscommon 是否放在公用目录下。是则放在所用用户公用目录，否则放在当前用户目录下。
 @return 数据库目录
 */
-(NSString*)getDbPathWithName:(NSString*)name isCommonDir:(BOOL)iscommon{
    if( name == nil || name.length == 0 )  return nil;
    
    NSString *pathPrefix  = @"21";//_userModel.userId;
    if( pathPrefix==nil || pathPrefix.length ==0 ){
        pathPrefix = @"defaultUserName";
    }
    if( iscommon ){
        pathPrefix = @"AllUserCommon";
    }
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dir = [NSString stringWithFormat:@"%@/%@/database",docPath,pathPrefix];
    NSFileManager *fm = [NSFileManager defaultManager];
    if( [fm fileExistsAtPath:dir] == NO ){
        [fm createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *dbPath = [dir stringByAppendingPathComponent:name];
    return dbPath;
}

-(sqlite3*)openDataBase:(sqlite3*)dbInfo path:(NSString*)path sql:(NSString*)sqlStr{
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL find = [fm fileExistsAtPath:path];
    //如果数据库存在，则用sqlite3_open直接打开
    if( find ){
        //打开数据库
        if( sqlite3_open([path UTF8String], &dbInfo) != SQLITE_OK ){
            sqlite3_close(dbInfo);
            return nil;
        }
        return dbInfo;
    }
    
    //如果发现数据库不存在则利用sqlite3_open创建数据库
    int ret = sqlite3_open([path UTF8String], &dbInfo);
    
    if( ret == SQLITE_OK ){
        //创建新表
        if([self createTable:dbInfo sql:[sqlStr UTF8String]]){
            return dbInfo;
        }
    }else{
        //如果创建并打开数据库失败则关闭数据库
        sqlite3_close(dbInfo);
        return nil;
    }
    return nil;
}

//创建表
-(BOOL)createTable:(sqlite3*)db sql:(const char*)sql{
    sqlite3_stmt *statement;
    //sqlite3_prepare_v2 接口把一条SQL语句解析到statement结构里去，使用该接口访问数据库是当前比较好的一种办法
    NSInteger sqlRet = sqlite3_prepare_v2(db, sql, -1, &statement, nil);
    //如果SQL语句解析出错的话，程序返回
    if( sqlRet != SQLITE_OK )
        return NO;
    //执行SQL语句
    int success = sqlite3_step(statement);
    //释放sqlite3_stmt
    sqlite3_finalize(statement);
    //执行SQL语句失败
    if( success != SQLITE_DONE ){
        return NO;
    }
    return YES;
}

/**
 *  删除ID小于MaxId 的数据，若maxId <=0 则删除所有数据
 *
 *  @param maxId 待删除的数据ID的最大值
 *  @param table 待删除的数据的表
 *  @param db    待删除的数据的数据库文件
 *
 *  @return 成功YES 失败NO
 */
- (BOOL)deleteDataWithMaxId:(NSInteger)maxId table:(NSString*)table dataBase:(sqlite3*)db{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE ID<%ld",table,maxId];
    if( maxId <=0 ){
        sql = [NSString stringWithFormat:@"DELETE FROM %@",table];
    }
    sqlite3_stmt *statement ;
    int success = sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, NULL);
    if( success != SQLITE_OK ){
        return NO;
    }
    
    //执行
    char *errMsg = nil;
    success = sqlite3_exec(db, [sql UTF8String], NULL, NULL, &errMsg);
    //释放statement
    sqlite3_finalize(statement);
    
    return (success == SQLITE_OK);
}

/**
 *  创建数据库文件及表
 *
 *  @param sql    创建表语句
 *  @param dbName 数据库名字
 *  @param db     数据库文件对象
 *
 *  @return 表对应的数据库对象
 */
- (sqlite3*)createTableWithSql:(NSString*)sql dataBaseName:(NSString*)dbName dateBase:(sqlite3*)db{
    NSString *dbPath = [self getDbPathWithName:dbName isCommonDir:NO];
    
    return  [self openDataBase:db path:dbPath sql:sql];
}

/*
 * 查询某个数据是否存在数据库。存在则直接删除并返回NO
 * @param db 要查询的数据库
 * @param tableName 要查询的表的名字
 * @param segementName 字段的名字。要查询的值对应的字段
 * @param value 要查询的数据
 *
 * @return 存在 返回YES ，不存在No
 */
- (BOOL)isExistInDataBase:(sqlite3*)db tableName:(NSString*)tableName segmentName:(NSString*)segementName value:(NSString*)value{
    
    if( db == nil || tableName ==nil || segementName.length ==0 || value.length == 0 ){
        //        不插入
        return YES;
    }
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@='%@' order by id DESC",tableName,segementName,value];
    sqlite3_stmt *statement;
    const char *err;
    
    BOOL isExist = NO;
    int ret = sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, &err);
    if( ret == SQLITE_OK){
        while (sqlite3_step(statement) == SQLITE_ROW ) {
            int iditify = sqlite3_column_int(statement, 0);
            //若存在则删除
            BOOL delRet = [self deleteDataWithID:iditify dataBase:db table:tableName];
            if( !delRet ){
                isExist = YES;
            }
        }
    }
    
    sqlite3_finalize(statement);
    
    return isExist;
}

- (BOOL)deleteValuesOfExistInDataBase:(sqlite3*)db tableName:(NSString*)tableName segmentNames:(NSArray<NSString*>*)segementNames values:(NSArray<NSString*>*)values{
    
    if( db == nil || tableName ==nil || segementNames.count ==0 || values.count == 0 || segementNames.count != values.count ){
        //删除失败
        return NO;
    }
    
    NSString *segsAndValuesStr = nil;
    for( NSUInteger i=0; i<segementNames.count; i++ ){
        NSString *segName = segementNames[i];
        NSString *value= values[i];
        if( [NSString stringWithObj:segName] ){
            if( segsAndValuesStr == nil ){
                segsAndValuesStr = [NSString stringWithFormat:@"%@='%@'",segName,value];
            }
            else{
                segsAndValuesStr = [NSString stringWithFormat:@"%@ and %@='%@'",segsAndValuesStr,segName,value];
            }
        }
    }
    
    if( segsAndValuesStr == nil )
        return NO;
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ order by id DESC",tableName,segsAndValuesStr];
    sqlite3_stmt *statement;
    const char *err;
    
    BOOL isExist = NO;
    int ret = sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, &err);
    if( ret == SQLITE_OK){
        while (sqlite3_step(statement) == SQLITE_ROW ) {
            int iditify = sqlite3_column_int(statement, 0);
            //若存在则删除
            BOOL delRet = [self deleteDataWithID:iditify dataBase:db table:tableName];
            if( !delRet ){
                isExist = YES;
            }
        }
    }
    
    sqlite3_finalize(statement);
    
    return isExist;
}

- (BOOL)deleteDataWithID:(int)dataID dataBase:(sqlite3*)db table:(NSString*)table{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE ID=%d",table,dataID];
    sqlite3_stmt *statement ;
    int success = sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, NULL);
    if( success != SQLITE_OK ){
        //释放statement
        sqlite3_finalize(statement);
        return NO;
    }
    
    //执行
    char *errMsg = nil;
    success = sqlite3_exec(db, [sql UTF8String], NULL, NULL, &errMsg);
    //释放statement
    sqlite3_finalize(statement);
    
    return (success == SQLITE_OK);
}

- (void)sqliteBindText:(NSString*)text statement:(sqlite3_stmt *)statement index:(int)index{
    NSString *textStr = [NSString stringWithObj:text];
    if( [textStr isKindOfClass:[NSString class]] ){
        sqlite3_bind_text(statement, index, [textStr UTF8String], -1, SQLITE_TRANSIENT);
    }
}

- (NSString*)sqlietColumnTextWithStatement:(sqlite3_stmt*)statement index:(int)index{
    char *name = (char*)sqlite3_column_text(statement, index);
    if( name != NULL ){
        return [NSString stringWithUTF8String:name];
    }
    return nil;
}

- (NSString*)sqliteColumnIntWithStatement:(sqlite3_stmt*)statement index:(int)index{
    int name = sqlite3_column_int(statement, index);

    return @(name).stringValue;
}

//- (void)deleteExistSchoolData{
//    NSString *fp = [self getDbPathWithName:@"au_all_univercitys.db"];
//    if( [fp isKindOfClass:[NSString class]] ){
//        NSError *err = nil;
//        [[NSFileManager defaultManager] removeItemAtPath:fp error:&err];
//
//        sqlite3_close(_allUnivercitysDB);
//        _allUnivercitysDB = nil;
//    }
//}

#pragma mark - Propertys

- (sqlite3*)oneLifeDB{
    if( !_oneLifeDB ){
        
        /** tableSchedule表字段说明
         dateType: 日期类型(0 单日，1 多日，2 截止，3 重复)
         dateRepeatType: 日期重复类型(0 天，1 每月， 2 每周， 3每年）
         date: dateType==0时, 为单日期，如：2017-07-09
               dateType==1时，为多个日期,以逗号分隔 如：2017-07-09,2017-07-10,2017-09-09
               dateType==2时，为两个日期，即开始和截止日期,逗号分隔。如：2017-09-09,2018-09-09
               dateType==3 a. dateRepeatType=0时，date为单日期，如：2017-07-09
                           b. dateRepeatType=1时，date为多个日期，此时同dateType==1时相同
                           c. dateRepeatType=2时，date为多个星期数字，以逗号分隔，如: 1,2,3
                              即表示每周的周一，周二，周三重复
                           d. dateRepeatType=3时，同其为0时。
         */
        NSString *sqlCreateTable = [NSString stringWithFormat:@"create table if not exists %@ (ID Integer PRIMARY KEY AUTOINCREMENT, content text, needAlarm Integer, alarmTime text, dateType Integer, dateRepeatType Integer, date text, createTime text,targetId Integer,userId Integer)",tableSchedule];
        _oneLifeDB = [self createTableWithSql:sqlCreateTable
                                   dataBaseName:@"onelife.db"
                                       dateBase:_oneLifeDB];
        
        if( _oneLifeDB ){
            //创建时间事项状态表
            NSString *sqlTimeTable = [NSString stringWithFormat:@"create table if not exists %@ (ID Integer PRIMARY KEY AUTOINCREMENT, date text, status Integer, schedleId Integer)",tableScheduleState];
            [self createTable:_oneLifeDB sql:sqlTimeTable.UTF8String];
            
            //创建时间记录表
            /**字段说明
             type: 时间类型，共四种。0投资，1浪费，2睡眠，3固定。
             targetId：目标id。无目标则传-1
             targetName:目标名字，无目标，则传@""
             */
            NSString *sqlPlanContentTable =
            [NSString stringWithFormat:@"create table if not exists %@ (ID Integer PRIMARY KEY AUTOINCREMENT, content text,  startTime text, endTime text, targetID int,targetName text, type int, date text,userId int)",tableTimeRecord];
            [self createTable:_oneLifeDB sql:sqlPlanContentTable.UTF8String];
            
            //创建目标表
            
            /** 目标表字段说明
             name 目标名字
             content 目标描述
             state 目标状态：0 进行中， 1已完成 ，2已过期
             endDate 目标完成截止日期：如：2020-10-10
             needHours 完成目标需要的小时。如1000小时
             type 目标类型，0 普通目标， 1 浪费的时间，2 固定的时间，3睡觉的时间，把这三类花费的时间，成为非常规目标
             */
            NSString *sqlPlanResultTable =
            [NSString stringWithFormat:@"create table if not exists %@ (ID Integer PRIMARY KEY AUTOINCREMENT, state Integer, name text, content text, createTime text, endDate text, needHours Integer, type Integer, userId Integer)",tableTarget];
            [self createTable:_oneLifeDB sql:sqlPlanResultTable.UTF8String];
            
            /** 目标时间投入表 字段说明
             targetId 目标的ID
             minutes 投入的分钟数
             date 投入的日期
             */
            NSString *sqlTargetInvestTable =
            [NSString stringWithFormat:@"create table if not exists %@ (ID Integer PRIMARY KEY AUTOINCREMENT, targetId int, minutes int, date text)",tableTargetInvestmentTime];
            [self createTable:_oneLifeDB sql:sqlTargetInvestTable.UTF8String];
        }
    }
    return _oneLifeDB;
}

@end
