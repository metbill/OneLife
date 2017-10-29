//
//  OLTargetModel.h
//  OneLife
//
//  Created by wkun on 2017/10/23.
//  Copyright © 2017年 wkun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OLEnums.h"
#import "OLTargetDataModel.h"

@interface OLTargetModel : NSObject
@property (nonatomic ,strong) NSString *name;
@property (nonatomic, strong) NSString *endDate;
@property (nonatomic, strong) NSString *needHours;
@property (nonatomic, assign) OLTargetStatus status;
@property (nonatomic, strong) OLTargetDataModel *dm;

//****************** 时间记录时用到 ********************//
@property (nonatomic, assign) OLTimeType timeType; //时间类型。

+ (OLTargetModel*)targetModelWithDm:(OLTargetDataModel*)dm;

@end
