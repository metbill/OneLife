//
//  OLRecordTimeDataModel.h
//  OneLife
//
//  Created by hitomedia on 2017/10/27.
//  Copyright © 2017年 wkun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OLRecordTimeDataModel : NSObject
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, strong) NSString *targetName;
@property (nonatomic, strong) NSString *targetId;
@property (nonatomic, strong) NSString *type; //时间类型
@property (nonatomic, strong) NSString *date;
@end
