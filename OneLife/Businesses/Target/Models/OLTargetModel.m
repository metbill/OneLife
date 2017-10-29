//
//  OLTargetModel.m
//  OneLife
//
//  Created by wkun on 2017/10/23.
//  Copyright © 2017年 wkun. All rights reserved.
//

#import "OLTargetModel.h"

@implementation OLTargetModel

+ (OLTargetModel *)targetModelWithDm:(OLTargetDataModel *)dm{
    if( [dm isKindOfClass:[OLTargetDataModel class]] ==NO ) return nil;
    
    OLTargetModel *tm = [OLTargetModel new];
    tm.name = dm.name;
    tm.endDate = [NSString stringWithFormat:@"截止日期:%@",dm.endDate];
    tm.needHours = [NSString stringWithFormat:@"%@/%@h",@"25",dm.needHours];
    tm.status = (OLTargetStatus)(dm.status.integerValue);
    return tm;
}

@end
