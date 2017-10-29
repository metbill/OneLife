//
//  KDatePicker.h
//  RRTY
//
//  Created by 端倪 on 15/6/14.
//  Copyright (c) 2015年 RRTY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KDatePicker;
typedef void(^SelectDateBlock)(NSDate *date);
typedef void(^TapPickerBlock)(KDatePicker *datePicker);

//若frame 宽高为0，则为默认高度 宽度
@interface KDatePicker : UIView

@property (nonatomic) UIDatePickerMode datePickerMode;
@property (nonatomic, copy) SelectDateBlock selectDateBlock;

@property (nonatomic, retain) NSDate *currDate;
// specify min/max date range.
//default is nil. When min > max, the values are ignored. Ignored in countdown timer mode
@property (nonatomic, retain) NSDate *minimumDate;
@property (nonatomic, retain) NSDate *maximumDate;

@end
