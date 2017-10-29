//
//  OLScheduleModel.m
//  OneLife
//
//  Created by wkun on 2017/10/22.
//  Copyright © 2017年 wkun. All rights reserved.
//

#import "OLScheduleModel.h"
#import "OLScheduleDataModel.h"

@implementation OLScheduleModel

- (NSComparisonResult)compare:(OLScheduleModel *)model{
    NSComparisonResult cr = [self.dm.startDate compare:model.dm
                             .startDate];
    if( cr == NSOrderedSame ){
        return [self.dm.createTime compare:model.dm.createTime];
    }
    return cr;
}

@end
