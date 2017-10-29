//
//  OLRecordTimeModel.m
//  OneLife
//
//  Created by hitomedia on 2017/10/23.
//  Copyright © 2017年 wkun. All rights reserved.
//

#import "OLRecordTimeModel.h"
#import "OLRecordTimeDataModel.h"
#import "NSDate+Ext.h"
#import <CoreGraphics/CoreGraphics.h>

@implementation OLRecordTimeModel
+ (OLRecordTimeModel*)recordTimeModelWithDm:(OLRecordTimeDataModel *)dm{
    if( ![dm isKindOfClass:[OLRecordTimeDataModel class]] ) return nil;
    
    OLRecordTimeModel *tm = [OLRecordTimeModel new];
    tm.time = [tm timeWithDm:dm];
    tm.content = dm.content;
    tm.type = dm.type.integerValue;
    tm.typeStr = [tm typeTextWithDm:dm];
    tm.howLong = [tm howlongWithDm:dm];
    tm.dm = dm;
    
    return tm;
}

- (NSString *)typeTextWithDm:(OLRecordTimeDataModel*)dm{
    NSString *typeText = nil;
    OLTimeType type = dm.type.integerValue;
    switch (type) {
        case OLTimeTypeWaste:
            typeText = @"浪费";
            break;
        case OLTimeTypeSleep:
            typeText = @"睡眠";
            break;
        case OLTimeTypeInvestment:{
            typeText = dm.targetName;
            if( typeText==nil || [typeText isEqualToString:@""] ){
                typeText = @"投资";
            }
            break;
        }
        case OLTimeTypeRoutine:
            typeText = @"固定";
            break;
        default:
            break;
    }
    return typeText;
}

- (NSString*)howlongWithDm:(OLRecordTimeDataModel*)dm{
    NSString *fmt = @"yyyy-MM-dd HH:mm";
    NSDate *stDate = [NSDate dateWithString:dm.startTime format:fmt];
    NSDate *etDate = [NSDate dateWithString:dm.endTime format:fmt];
    NSTimeInterval ti = [etDate timeIntervalSinceDate:stDate];
    NSInteger mints = ti/60;
    CGFloat hours = mints/60.0;
    
    
    return [NSString stringWithFormat:@"%.1fh",hours];
}

- (NSString*)timeWithDm:(OLRecordTimeDataModel*)dm{
    NSString *stTime = [self getTimeByDateTime:dm.startTime];
    NSString *etTime = [self getTimeByDateTime:dm.endTime];
    if( stTime.length && etTime.length ){
        return [NSString stringWithFormat:@"%@-%@",stTime,etTime];
    }
    
    return @"";
}

- (NSString*)getTimeByDateTime:(NSString*)dateTime{
    if( [dateTime isKindOfClass:[NSString class]] ){
        NSArray *arr = [dateTime componentsSeparatedByString:@" "];
        if( arr.count > 1 ){
            return arr[1];
        }
    }
    return nil;
}

@end
