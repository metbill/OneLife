//
//  OLCalendarView.m
//  OneLife
//
//  Created by wkun on 2017/10/21.
//  Copyright © 2017年 wkun. All rights reserved.
//

#import "OLCalendarView.h"
#import <FSCalendar.h>
#import "UIView+LayoutMethods.h"
#import "UIColor+Ext.h"
#import "UILabel+Ext.h"
#import "NSDate+Ext.h"

@interface OLCalendarView()<FSCalendarDelegate,FSCalendarDataSource>

@property (nonatomic, strong) FSCalendar *calendar;
@property (strong, nonatomic) NSCalendar *lunarCalendar;
@property (strong, nonatomic) NSArray    *lunarChars;
@property (strong, nonatomic) UIButton   *previousButton;
@property (strong, nonatomic) UIButton   *nextButton;
@property (strong, nonatomic) NSDate     *maximumDate;
@property (strong, nonatomic) NSDate     *minimumDate;

@property (nonatomic, strong) UIView *naviBgView;
@property (nonatomic, strong) UIView *topWeekDayView;

@end

@implementation OLCalendarView

#pragma mark - Init

- (instancetype)init{
    self = [super init];
    if( self ){
        _lunarCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
        _lunarCalendar.locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
        _lunarChars = @[@"初一",@"初二",@"初三",@"初四",@"初五",@"初六",@"初七",@"初八",@"初九",@"初十",@"十一",@"十二",@"十三",@"十四",@"十五",@"十六",@"十七",@"十八",@"十九",@"二十",@"二一",@"二二",@"二三",@"二四",@"二五",@"二六",@"二七",@"二八",@"二九",@"三十"];
        _prevDaysOfToday = 30;
        _nextDaysOfToday = 30;
        _allowMultiSelect = NO;
        _maxDateCount = 3;
        
//        self.calendar.currentPage = [NSDate date];
        
        _currDate = [NSDate date];
        [self.calendar selectDate:_currDate];
        self.calendar.allowsMultipleSelection = _allowMultiSelect;
//        if( _allowMultiSelect ){
//            [self addRightBarItemWithTitle:@"确定" action:@selector(handleSureBtn)];
//            
//            for( NSDate *sd in _selectedDates ){
//                if( [sd isKindOfClass:[NSDate class]] ){
//                    [_calendar selectDate:sd scrollToDate:YES];
//                }
//            }
//        }
        [self addSubview:self.calendar];
        [self updateBtnStatus];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
//    self.calendar.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), self.height);
}

#pragma mark - Public Methods

- (NSString *)stringFromDate:(NSDate *)date format:(NSString *)format{
    return [self.calendar stringFromDate:date format:format];
}

#pragma mark - FSCalendarDelegate

- (nullable NSString *)calendar:(FSCalendar *)calendar subtitleForDate:(NSDate *)date{
    NSInteger day = [_lunarCalendar components:NSCalendarUnitDay fromDate:date].day;
    return _lunarChars[day-1];
}

- (NSString *)calendar:(FSCalendar *)calendar titleForDate:(NSDate *)date
{
    return [calendar isDateInToday:date] ? @"今天" : nil;
}

- (NSDate *)minimumDateForCalendar:(FSCalendar *)calendar
{
    return self.minimumDate;
}

- (NSDate *)maximumDateForCalendar:(FSCalendar *)calendar
{
    return self.maximumDate;
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date
{
    if( _allowMultiSelect ){
        if( calendar.selectedDates.count > _maxDateCount ){
            [self showErrAlertWithMaxDateCount:_maxDateCount];
            [calendar deselectDate:date];
        }
        return;
    }
    
    _currDate = date;
    
    if( _delegate && [_delegate respondsToSelector:@selector(calendar:didSelectDate:)] ){
        
        [_delegate calendar:self didSelectDate:date];
    }
    
//    NSLog(@"did select date %@",[calendar stringFromDate:date format:@"yyyy/MM/dd"]);
//    CGRect frame = [self.calendar frameForDate:date];
//    NSLog(@"%@",NSStringFromCGRect(frame));
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)),
//                   dispatch_get_main_queue(), ^{
//                       [self.navigationController popViewControllerAnimated:YES];
//                       
//                       if( _delegate && [_delegate respondsToSelector:@selector(calendar:didSelectDate:) ]){
//                           [_delegate calendar:self didSelectDate:date];
//                       }
//                       
//                   });
}

- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar
{
    NSLog(@"did change to page %@",[calendar stringFromDate:calendar.currentPage format:@"MMMM yyyy"]);
    [self updateBtnStatus];
}

#pragma mark - TouchEvents

- (void)previousClicked:(id)sender
{
    NSDate *currentMonth = self.calendar.currentPage;
    NSDate *previousMonth = [self.calendar dateBySubstractingMonths:1 fromDate:currentMonth];
    [self.calendar setCurrentPage:previousMonth animated:YES];
    
    [self updateBtnStatus];
}

- (void)nextClicked:(id)sender
{
    NSDate *currentMonth = self.calendar.currentPage;
    NSDate *nextMonth = [self.calendar dateByAddingMonths:1 toDate:currentMonth];
    [self.calendar setCurrentPage:nextMonth animated:YES];
    
    [self updateBtnStatus];
}

- (void)handleSureBtn{
    
    if( _allowMultiSelect == NO ) return;
    
    _selectedDates = _calendar.selectedDates;
    if( _selectedDates.count > _maxDateCount ){
        [self showErrAlertWithMaxDateCount:_maxDateCount];
        return;
    }
    
//    [self.navigationController popViewControllerAnimated:YES];
//    if( _delegate && [_delegate respondsToSelector:@selector(calendar:didSelectDates:) ]){
//        [_delegate calendar:self didSelectDates:_calendar.selectedDates];
//    }
}

#pragma mark - Private Methods

//- (void)updateNaviBgColor:(UIColor*)nbColor{
//    if( nbColor ){
//        CGRect fr = self.previousButton.frame;
//        fr.origin.y += self.naviBgView.bottom;
//        self.previousButton.frame = fr;
//        
//        fr = self.nextButton.frame;
//        fr.origin.y = self.previousButton.y;
//        self.nextButton.frame = fr;
//        
//        self.topWeekDayView.frame = CGRectMake(0, self.naviBgView.bottom, SCREEN_WIDTH, [self topWeekViewH]);
//        
//        fr = self.calendar.frame;
//        fr.origin.y += self.topWeekDayView.bottom;
//        fr.size.height = SCREEN_HEIGHT-fr.origin.y;
//        self.calendar.frame = fr;
//        
//        self.edgesForExtendedLayout = UIRectEdgeAll;
//    }
//    else{
//        self.previousButton = nil;
//        self.nextButton = nil;
//        self.calendar = nil;
//        CGFloat iw = 45;
//        self.previousButton.frame = CGRectMake(0, 5, iw, 34);
//        self.nextButton.frame = CGRectMake(CGRectGetWidth(self.view.frame)-iw, 5, iw, 34);
//        self.topWeekDayView.frame = CGRectMake(0, 0, SCREEN_WIDTH, [self topWeekViewH]);
//        CGFloat iy = _topWeekDayView.bottom;
//        self.calendar.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), SCREEN_HEIGHT-NAVGATION_VIEW_HEIGHT-iy);
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//    }
//}

- (void)updateBtnStatus{
    if( [self.calendar monthOfDate:self.calendar.currentPage] == [self.calendar monthOfDate:self.minimumDate] ){
        self.previousButton.enabled = NO;
    }
    else{
        self.previousButton.enabled = YES;
    }
    
    if( [self.calendar monthOfDate:self.calendar.currentPage] == [self.calendar monthOfDate:self.maximumDate] ){
        self.nextButton.enabled = NO;
    }
    else{
        self.nextButton.enabled = YES;
    }
}

- (void)showErrAlertWithMaxDateCount:(NSUInteger)cnt{
    NSString *msg = [NSString stringWithFormat:@"最多可添加%ld个日期",cnt];
//    [self showAlertViewWithTitle:nil msg:msg okBlock:^{
//        
//    } cancleBlock:nil];
}

- (CGFloat)topWeekViewH{
    return 20.0;
}

#pragma mark - Propertys
- (FSCalendar *)calendar{
    if( !_calendar ){
        
        FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300)];
        calendar.dataSource = self;
        calendar.delegate = self;
        calendar.backgroundColor = [UIColor whiteColor];
        calendar.appearance.headerMinimumDissolvedAlpha = 0;
        calendar.appearance.caseOptions = FSCalendarCaseOptionsWeekdayUsesSingleUpperCase;
        [self addSubview:calendar];
        [calendar setScope:FSCalendarScopeWeek];
        calendar.headerHeight = 0;
        _calendar = calendar;
        
        
//        _calendar = [[FSCalendar alloc] init];
//
//        _calendar.delegate = self;
//        _calendar.dataSource = self;
//        _calendar.appearance.cellShape = FSCalendarCellShapeRectangle;
//        
//        _calendar.pagingEnabled = NO;
//        _calendar.appearance.caseOptions = FSCalendarCaseOptionsHeaderUsesUpperCase;
        _calendar.appearance.adjustsFontSizeToFitContentSize = NO;
        _calendar.appearance.weekdayTextColor = [UIColor colorWithRgb102];
        _calendar.appearance.weekdayFont = [UIFont systemFontOfSize:12.0];
        
//        _calendar.appearance.headerTitleFont = [UIFont systemFontOfSize:15.0];
//        _calendar.appearance.headerTitleColor = [UIColor colorWithRgb51];
//        _calendar.appearance.subtitleDefaultColor = [UIColor colorWithRgb_24_148_209];
//        _calendar.appearance.headerMinimumDissolvedAlpha = 0;
//        _calendar.appearance.titleFont = [UIFont systemFontOfSize:14.0];
//        _calendar.appearance.subtitleFont = [UIFont systemFontOfSize:9.0];
//        _calendar.appearance.titleDefaultColor = [UIColor colorWithRgb_24_148_209];
//        _calendar.appearance.headerDateFormat = @"yyyy年MM月";
        _calendar.appearance.selectionColor = [UIColor colorWithRgb_24_148_209];
        _calendar.appearance.todayColor = [UIColor clearColor];
        _calendar.appearance.titleTodayColor = [UIColor colorWithRgb_250_100_92];
        _calendar.appearance.subtitleTodayColor = [UIColor colorWithRgb_250_100_92];
//        _calendar.appearance.subtitleVerticalOffset = 3.0;
//        _calendar.backgroundColor = [UIColor whiteColor];
//        [_calendar setScope:FSCalendarScopeWeek animated:YES];
//        
//        _calendar.weekdayHeight = 0.0;
        
    }
    return _calendar;
}

- (NSDate *)minimumDate{
    return [NSDate dateByAddDays:-60 toDate:[NSDate new]];//[self.calendar dateBySubstractingDays:self.prevDaysOfToday fromDate:[NSDate date]];
}

- (NSDate *)maximumDate{
    return [NSDate dateByAddDays:60 toDate:[NSDate new]];
    return [NSDate new];;//[self.calendar dateByAddingDays:self.nextDaysOfToday toDate:[NSDate date]];
}

//- (UIButton *)previousButton {
//    if( !_previousButton ){
//        CGFloat iw = 45;
//        UIButton *previousButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        previousButton.frame = CGRectMake(0, 5, iw, 34);
//        previousButton.backgroundColor = [UIColor whiteColor];
//        [previousButton setImage:[UIImage imageNamed:@"pc_date_prev"] forState:UIControlStateNormal];
//        [previousButton setImage:[UIImage imageNamed:@"pc_date_prev_unable"] forState:UIControlStateDisabled];
//        [previousButton addTarget:self action:@selector(previousClicked:) forControlEvents:UIControlEventTouchUpInside];
//        //        [self.view addSubview:previousButton];
//        _previousButton = previousButton;
//    }
//    return _previousButton;
//}
//
//- (UIButton *)nextButton {
//    if( !_nextButton ){
//        UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        CGFloat iw = self.previousButton.width;
//        nextButton.frame = CGRectMake(CGRectGetWidth(self.frame)-iw, 5, iw, 34);
//        nextButton.backgroundColor = [UIColor whiteColor];
//        
//        [nextButton setImage:[UIImage imageNamed:@"pc_date_next"] forState:UIControlStateNormal];
//        [nextButton setImage:[UIImage imageNamed:@"pc_date_next_unable"] forState:UIControlStateDisabled];
//        [nextButton addTarget:self action:@selector(nextClicked:) forControlEvents:UIControlEventTouchUpInside];
//        
//        _nextButton = nextButton;
//        //        [self.view addSubview:_nextButton];
//    }
//    return _nextButton;
//}

- (UIView *)naviBgView {
    if( !_naviBgView ){
        _naviBgView = [[UIView alloc] init];
        CGFloat navH = NAVGATION_VIEW_HEIGHT;
        _naviBgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, navH);
        _naviBgView.backgroundColor = [UIColor colorWithRgb_24_148_209];
        
        [self addSubview:_naviBgView];
    }
    return _naviBgView;
}

//- (UIView *)topWeekDayView {
//    if( !_topWeekDayView ){
//        _topWeekDayView = [[UIView alloc] init];
//        _topWeekDayView.backgroundColor = [UIColor colorWithRgb_24_148_209];
//        [self addSubview:_topWeekDayView];
//        
//        //添加Lable
//        NSArray *weekDayTitles =
//        @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
//        NSUInteger i=0;
//        CGFloat ih = [self topWeekViewH];
//        for( NSString *title in weekDayTitles ){
//            CGFloat iw = SCREEN_WIDTH/weekDayTitles.count;
//            CGFloat ix = iw*i;
//            UILabel *lbl =
//            [UILabel getLabelWithTextColor:[UIColor whiteColor]
//                                      font:[UIFont systemFontOfSize:12]
//                             textAlignment:NSTextAlignmentCenter
//                                     frame:CGRectMake(ix, 0, iw, ih)
//                                 superView:_topWeekDayView];
//            lbl.text = title;
//            lbl.backgroundColor = [UIColor clearColor];
//            i++;
//        }
//    }
//    return _topWeekDayView;
//}

@end
