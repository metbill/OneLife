//
//  NSDate+Ext.h
//  Hitu
//
//  Created by hitomedia on 16/7/28.
//  Copyright © 2016年 hitomedia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Ext)

+ (NSDate*)dateByAddDays:(NSInteger)days toDate:(NSDate*)date;

+ (NSDate*)dateWithString:(NSString*)str format:(NSString*)format;

@end
