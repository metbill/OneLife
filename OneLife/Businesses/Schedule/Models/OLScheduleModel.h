//
//  OLScheduleModel.h
//  OneLife
//
//  Created by wkun on 2017/10/22.
//  Copyright © 2017年 wkun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OLEnums.h"

@class OLScheduleDataModel;
@interface OLScheduleModel : NSObject
@property (nonatomic, assign) OLScheduleStatus scheduleStatus; //延期 进行中 已完成 未开始
@property (nonatomic, strong) NSString *scheduleContent;
@property (nonatomic, strong) NSString *remark;  //备注内容
@property (nonatomic, assign) BOOL isDelayed;    //是否延期
@property (nonatomic, strong) OLScheduleDataModel *dm;

//比较大小，返回值：本对象大于model,返回NSOrderedDescending,相等，返回NSOrderedSame,小于返回NSOrderedAscending
- (NSComparisonResult)compare:(OLScheduleModel*)model;

@end
