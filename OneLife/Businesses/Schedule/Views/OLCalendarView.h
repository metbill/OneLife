//
//  OLCalendarView.h
//  OneLife
//
//  Created by wkun on 2017/10/21.
//  Copyright © 2017年 wkun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OLCalendarViewDelegate;

@interface OLCalendarView : UIView

//时间范围
@property (nonatomic, assign) NSUInteger nextDaysOfToday;          //今天的前多少天,默认30
@property (nonatomic, assign) NSUInteger prevDaysOfToday;          //今天的后多少天，默认30

@property (nonatomic, assign) id<OLCalendarViewDelegate> delegate;

/**
 *  导航栏的背景色。当Translucent 为YES时，需要设置.
 */
@property (nonatomic, strong) UIColor *navigationBarBgColorWhenTranslucentIsYes;

/**
 是否多选，默认为NO
 */
@property (nonatomic, assign) BOOL allowMultiSelect;

@property (nonatomic, strong) NSArray<NSDate*> *selectedDates;
@property (nonatomic, strong) NSDate *currDate;

/**
 最大的日期选择数量，默认为3
 */
@property (nonatomic, assign) NSUInteger maxDateCount;


- (NSString*)stringFromDate:(NSDate*)date format:(NSString*)format;

@end


@protocol OLCalendarViewDelegate <NSObject>

@optional

/**
 选择日期
 
 @param ctrl
 @param date 选择的日期
 */
- (void)calendar:(OLCalendarView*)ctrl didSelectDate:(NSDate *)date;

/**
 选择多个日期的回调
 
 @param ctrl
 @param dates
 */
- (void)calendar:(OLCalendarView *)ctrl didSelectDates:(NSArray<NSDate*>*)dates;

@end
