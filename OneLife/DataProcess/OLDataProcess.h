//
//  OLDataProcess.h
//  OneLife
//
//  Created by hitomedia on 2017/10/24.
//  Copyright © 2017年 wkun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OLEnums.h"

@class OLRecordTimeModel;
@interface OLDataProcess : NSObject
+ (OLDataProcess*)shareDataProcess;

#pragma mark - Target
- (BOOL)addTargetWithName:(NSString*)name description:(NSString*)des endDate:(NSString*)endDate needHours:(NSInteger)needHours;

- (NSArray*)targetListWithType;

#pragma mark - TimeRecord
- (BOOL)addRecordWithStartTime:(NSString*)startTime endTime:(NSString*)endTime content:(NSString*)content type:(OLTimeType)type targetId:(NSString*)targetId targetName:(NSString*)targetName date:(NSDate*)date;

- (NSArray*)recordDataWithDate:(NSDate*)date;

- (OLRecordTimeModel*)lastRecordWithDate:(NSDate*)date;

@end
