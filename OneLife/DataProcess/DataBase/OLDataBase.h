//
//  OLDataBase.h
//  OneLife
//
//  Created by hitomedia on 2017/10/23.
//  Copyright © 2017年 wkun. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OLRecordTimeModel;
@interface OLDataBase : NSObject
+ (OLDataBase*)shareDataBase;

#pragma mark - Target
- (BOOL)addTargetWithName:(NSString*)name description:(NSString*)des endDate:(NSString*)endDate needHours:(NSInteger)needHours userId:(NSString*)uid;
- (NSArray*)targetList;

#pragma mark - 时间记录表

/**
 新建记录

 @param startTime 起始时间：如：2017-10-10 18:55
 @param endTime 截止时间：如：2017-10-10 20:23
 @param content 记录的内容
 @param type 记录的类型
 @param targetId 目标ID
 @param targetName 目标名称
 @param date 记录的日期，是哪一天的记录
 @return 成功YES 失败NO
 */
- (BOOL)addRecordWithStartTime:(NSString*)startTime endTime:(NSString*)endTime content:(NSString*)content type:(NSString*)type targetId:(NSString*)targetId targetName:(NSString*)targetName date:(NSString*)date userId:(NSString*)uid;

/**
 时间记录数据

 @param date 日期，如果为nil，则查询所有
 @return OLRecordTimeModel实例集合
 */
- (NSArray*)recordDataWithDate:(NSString*)date;

- (OLRecordTimeModel*)lastRecordTimeModelWithDate:(NSString*)date userId:(NSString*)uid;
@end

