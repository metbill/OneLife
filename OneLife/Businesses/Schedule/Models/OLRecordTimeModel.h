//
//  OLRecordTimeModel.h
//  OneLife
//
//  Created by hitomedia on 2017/10/23.
//  Copyright © 2017年 wkun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OLEnums.h"

@class OLRecordTimeDataModel;

@interface OLRecordTimeModel : NSObject
@property (nonatomic, strong) NSString *time; //开始时间和截止时间如：07：00-09：00
@property (nonatomic, strong) NSString *typeStr; //多长时间 如：3h5min
@property (nonatomic, strong) NSString *howLong;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) OLTimeType type;
@property (nonatomic, strong) OLRecordTimeDataModel *dm;

+ (OLRecordTimeModel*)recordTimeModelWithDm:(OLRecordTimeDataModel*)dm;
@end
