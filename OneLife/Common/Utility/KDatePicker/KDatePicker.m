//
//  KDatePicker.m
//  RRTY
//
//  Created by 端倪 on 15/6/14.
//  Copyright (c) 2015年 RRTY. All rights reserved.
//

#import "KDatePicker.h"

@interface KDatePicker()

@property (nonatomic, strong) UIDatePicker *datePicker;

@end

@implementation KDatePicker

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if( self )
    {
        [self initDataPicker];
        self.frame = frame;
    }
    return self;
}

-(void)initDataPicker
{
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 1.0;
    self.layer.borderColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0].CGColor;
    
    if( !_datePicker )
    {
        self.backgroundColor = [UIColor whiteColor];
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
       
        [self addSubview:_datePicker];
         [_datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
//        [_datePicker addTarget:self action:@selector(beginTapPicker:) forControlEvents:UIControlEventTouchUpInside];
//        [_datePicker addTarget:self action:@selector(endTapPicker:) forControlEvents:UIControlEventEditingDidEnd];
//        [_datePicker addTarget:self action:@selector(exitDratPicker:) forControlEvents:UIControlEventTouchDragExit];
//        [_datePicker addTarget:self action:@selector(extiEndPicker:) forControlEvents:UIControlEventEditingDidEndOnExit];
        CGRect fr = self.frame;
        fr.origin = CGPointZero;
        _datePicker.frame = fr;
    }
}

-(void)setFrame:(CGRect)frame
{
    if( frame.size.width == 0 )
        frame.size.width = 320;
    if ( frame.size.height == 0 )
        frame.size.height = 162;
    
    super.frame = frame;
    
    CGRect fr = frame;
    fr.origin = CGPointZero;
    self.datePicker.frame = fr;
}

- (void)setCurrDate:(NSDate *)currDate{
    _currDate = currDate;
    self.datePicker.date = currDate;
}

-(void)setDatePickerMode:(UIDatePickerMode)datePickerMode
{
    _datePickerMode = datePickerMode;
    self.datePicker.datePickerMode = datePickerMode;
}

-(void)setMaximumDate:(NSDate *)maximumDate
{
    _maximumDate = maximumDate;
    self.datePicker.maximumDate = maximumDate;
}

-(void)setMinimumDate:(NSDate *)minimumDate
{
    _minimumDate = minimumDate;
    self.datePicker.minimumDate = minimumDate;
}

#pragma mark - IBAction
-(void)dateChange:(UIDatePicker*)datePicker
{
    NSDate *date = datePicker.date;
    self.currDate = date;
    if( self.selectDateBlock )
        self.selectDateBlock( date );
}

//-(void)beginTapPicker:(UIDatePicker*)datePicker
//{
//     NSLog(@"%s",__func__);
//}
//
//-(void)endTapPicker:(UIDatePicker*)datePicker
//{
//     NSLog(@"%s",__func__);
//}
//
//-(void)exitDratPicker:(UIDatePicker*)datePicker
//{
//     NSLog(@"%s",__func__);
//}
//
//-(void)extiEndPicker:(UIDatePicker*)datePicker
//{
//     NSLog(@"%s",__func__);
//}


@end
