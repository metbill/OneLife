//
//  NSDate+Ext.m
//  Hitu
//
//  Created by hitomedia on 16/7/28.
//  Copyright © 2016年 hitomedia. All rights reserved.
//

#import "NSDate+Ext.h"

@implementation NSDate (Ext)

+ (NSDate*)dateByAddDays:(NSInteger)days toDate:(NSDate*)date{
    if( date == nil )
        return nil;
    NSDate *newDate = [date dateByAddingTimeInterval:60 * 60 * 24 * days];
    
    return newDate;
}

+ (NSDate *)dateWithString:(NSString *)str format:(NSString *)format{
    if( str ==nil || format ==nil || ![str isKindOfClass:[NSString class]] || ![format isKindOfClass:[NSString class]] ){
        return nil;
    }
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:format];
    return [df dateFromString:str];
}

@end
