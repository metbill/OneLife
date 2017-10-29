//
//  NSString+Ext.h
//  Hitu
//
//  Created by hitomedia on 16/8/15.
//  Copyright © 2016年 hitomedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Ext)

+ (NSString*)stringWithObj:(NSObject*)obj;

+ (NSString*)stringWithDateStr:(NSString*)dateStr orginFormat:(NSString*)oformat desFormat:(NSString*)dFormat;
+ (NSString*)stringWithDate:(NSDate*)date format:(NSString*)format;

/**
 *  获取某日期是星期几
 *
 *  @param date 待查询的日期
 *
 *  @return 星期几。如星期一
 */
+ (NSString*)stringWeekWithDate:(NSDate*)date;

//对电话号码中间打星号
+ (NSString*)stringSecurePhoneNum:(NSString*)phoneNum;
//nsdictionnary 转nsstring
+ (NSString*)convertToJSONData:(id)infoDict;


/**
 过滤掉首尾和中间的空格

 @return <#return value description#>
 */
- (NSString*)filterOutSpace;

#pragma mark - CallPhone
+ (void)callPhoneStr:(NSString*)phoneStr withVC:(UIViewController *)ctrl;

@end
