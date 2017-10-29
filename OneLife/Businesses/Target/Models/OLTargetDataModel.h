//
//  OLTargetDataModel.h
//  OneLife
//
//  Created by hitomedia on 2017/10/24.
//  Copyright © 2017年 wkun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OLTargetDataModel : NSObject
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *needHours;
@property (nonatomic, strong) NSString *endDate;
@property (nonatomic, strong) NSString *createTime;
@end
