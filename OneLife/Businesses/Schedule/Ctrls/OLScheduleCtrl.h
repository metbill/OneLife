//
//  OLScheduleCtrl.h
//  OneLife
//
//  Created by wkun on 2017/10/21.
//  Copyright © 2017年 wkun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OLEnums.h"

@interface OLScheduleCtrl : UIViewController

- (void)reloadData;

@end


@interface OLScheduleCtrl(RootCtrl)
+ (UIViewController*)getRootCtrl;
@end

@interface OLScheduleData : NSObject
@property (nonatomic, strong) NSArray *datas;
//Index of the first unfinished schedule,如果没有未完成的事项，则为-1
@property (nonatomic, assign) NSInteger firstIndexForUnfinishSchedule;

- (void)updateModelStatus:(OLScheduleStatus)status atIndex:(NSUInteger)index;
@end
