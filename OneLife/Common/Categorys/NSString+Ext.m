//
//  NSString+Ext.m
//  Hitu
//
//  Created by hitomedia on 16/8/15.
//  Copyright © 2016年 hitomedia. All rights reserved.
//

#import "NSString+Ext.h"


@implementation NSString (Ext)

+(NSString*)stringWithObj:(NSObject*)obj{

    if( [obj isKindOfClass:[NSNumber class]] ){
        return ((NSNumber*)obj).stringValue;
    }
    else if( [obj isKindOfClass:[NSString class]] ){
        if( [((NSString*)obj ) isEqualToString:@"null"] || ((NSString*)obj ).length == 0){
            return nil;
        }
        return (NSString*)obj;
    }
    
    return nil;
}

+ (NSString *)stringWithDate:(NSDate *)date format:(NSString *)format{
    if( date ==nil || format ==nil || ![date isKindOfClass:[NSDate class]] || ![format isKindOfClass:[NSString class]] ){
        return nil;
    }
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:format];
//    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
//    [df setLocale:usLocale];
    return [df stringFromDate:date];
}

+ (NSString *)stringWithDateStr:(NSString *)dateStr orginFormat:(NSString *)oformat desFormat:(NSString *)dFormat {
    if( dateStr ==nil || oformat ==nil || dFormat ==nil || ![dateStr isKindOfClass:[NSString class]] || ![oformat isKindOfClass:[NSString class]] || ![dFormat isKindOfClass:[NSString class]] ){
        return nil;
    }
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:oformat];
    NSDate *dt = [df dateFromString:dateStr];
    [df setDateFormat:dFormat];
    return [df stringFromDate:dt];
}

+ (NSString *)stringWeekWithDate:(NSDate *)date {
    
    //获取今天星期几
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitWeekday;
    comps = [calendar components:unitFlags fromDate:date];
    //    NSLog(@"-----------weekday is %d",[comps weekday]);//在这里需要注意的是：星期日是数字1，星期一时数字2，以此类推。。。
    NSArray *wStr = @[@"日",@"一", @"二", @"三", @"四", @"五", @"六"];
    NSString *weekdayStr = @"";
    if( wStr.count > ([comps weekday]-1) ){
        weekdayStr = [NSString stringWithFormat:@"周%@",wStr[[comps weekday]-1]];
    }
    return weekdayStr;
}

+ (NSString *)stringSecurePhoneNum:(NSString *)phoneNum{
    if( [phoneNum isKindOfClass:[NSString class]] ){
        if( phoneNum.length == 11 ){
           return [phoneNum stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        }
    }
    return nil;
}


+ (NSString*)convertToJSONData:(id)infoDict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:infoDict
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    NSString *jsonString = @"";
    
    if (! jsonData)
    {
        NSLog(@"Got an error: %@", error);
    }else
    {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    
    [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    return jsonString;
}

- (NSString *)filterOutSpace{
    NSString * headerData = self;
    headerData = [headerData stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; //去除掉首尾的空白字符和换行字符
    headerData = [headerData stringByReplacingOccurrencesOfString:@"\r" withString:@" "];
    headerData = [headerData stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    return headerData;
}

#pragma mark - Call Phone

+ (void)callPhoneStr:(NSString*)phoneStr  withVC:(UIViewController *)selfvc{
    if (phoneStr.length >= 10) {
        NSString *str2 = [[UIDevice currentDevice] systemVersion];
        if ([str2 compare:@"10.2" options:NSNumericSearch] == NSOrderedDescending || [str2 compare:@"10.2" options:NSNumericSearch] == NSOrderedSame)
        {
            NSString* PhoneStr = [NSString stringWithFormat:@"telprompt://%@",phoneStr];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:PhoneStr] options:@{} completionHandler:^(BOOL success) {
                NSLog(@"phone success");
            }];
            
        }else {
            NSMutableString* str1 = [[NSMutableString alloc]initWithString:phoneStr];// 存在堆区，可变字符串
            if (phoneStr.length == 10) {
                [str1 insertString:@"-"atIndex:3];// 把一个字符串插入另一个字符串中的某一个位置
                [str1 insertString:@"-"atIndex:7];// 把一个字符串插入另一个字符串中的某一个位置
            }else {
                [str1 insertString:@"-"atIndex:3];// 把一个字符串插入另一个字符串中的某一个位置
                [str1 insertString:@"-"atIndex:8];// 把一个字符串插入另一个字符串中的某一个位置
            }
            NSString * str = [NSString stringWithFormat:@"是否拨打电话\n%@",str1];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:str message: nil preferredStyle:UIAlertControllerStyleAlert];
            // 设置popover指向的item
            alert.popoverPresentationController.barButtonItem = selfvc.navigationItem.leftBarButtonItem;
            // 添加按钮
            [alert addAction:[UIAlertAction actionWithTitle:@"呼叫" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                NSLog(@"点击了呼叫按钮10.2下");
                NSString* PhoneStr = [NSString stringWithFormat:@"tel://%@",phoneStr];
                if ([PhoneStr hasPrefix:@"sms:"] || [PhoneStr hasPrefix:@"tel:"]) {
                    UIApplication * app = [UIApplication sharedApplication];
                    if ([app canOpenURL:[NSURL URLWithString:PhoneStr]]) {
                        [app openURL:[NSURL URLWithString:PhoneStr]];
                    }
                }
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                NSLog(@"点击了取消按钮");
            }]];
            [selfvc presentViewController:alert animated:YES completion:nil];
        }
    }
}

#pragma mark - Private

+ (NSDate *)getDateWithString:(NSString *)str format:(NSString *)format{
    if( str ==nil || format ==nil || ![str isKindOfClass:[NSString class]] || ![format isKindOfClass:[NSString class]] ){
        return nil;
    }
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:format];
    return [df dateFromString:str];
}


@end
