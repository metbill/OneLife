//
//  OLDataProcess.m
//  OneLife
//
//  Created by hitomedia on 2017/10/24.
//  Copyright © 2017年 wkun. All rights reserved.
//

#import "OLDataProcess.h"
#import "OLDataBase.h"
#import "NSString+Ext.h"

@implementation OLDataProcess{
    OLDataBase *_dataBase;
    NSString *_uid;
}
+ (OLDataProcess *)shareDataProcess{
    static OLDataProcess *dp = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dp = [OLDataProcess new];
    });
    return dp;
}

- (id)init{
    self = [super init];
    if( self ){
        _dataBase = [OLDataBase shareDataBase];
        _uid = @"21";
    }
    return self;
}

#pragma mark - Target
- (BOOL)addTargetWithName:(NSString *)name description:(NSString *)des endDate:(NSString *)endDate needHours:(NSInteger)needHours{
    return
    [_dataBase addTargetWithName:name description:des endDate:endDate needHours:needHours userId:_uid];
}

- (NSArray *)targetListWithType{

    return 
    [_dataBase targetList];
}

#pragma mark - TimeRecord
- (BOOL)addRecordWithStartTime:(NSString *)startTime endTime:(NSString *)endTime content:(NSString *)content type:(OLTimeType)type targetId:(NSString *)targetId targetName:(NSString *)targetName date:(NSDate *)date{
    return
    [_dataBase addRecordWithStartTime:startTime endTime:endTime content:content type:@(type).stringValue targetId:targetId targetName:targetName date:[NSString stringWithDate:date format:@"yyyy-MM-dd"] userId:_uid];
}

- (NSArray *)recordDataWithDate:(NSDate *)date{
    return
    [_dataBase recordDataWithDate:[NSString stringWithDate:date format:@"yyyy-MM-dd"]];
}

- (OLRecordTimeModel *)lastRecordWithDate:(NSDate *)date {
    return
    [_dataBase lastRecordTimeModelWithDate:[NSString stringWithDate:date format:@"yyyy-MM-dd"] userId:_uid];
}

@end


