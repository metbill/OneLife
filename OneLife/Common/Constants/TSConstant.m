//
//  TSConstant.m
//  HiTravelService
//
//  Created by hitomedia on 2017/4/27.
//  Copyright © 2017年 hitumedia. All rights reserved.
//

#import "TSConstant.h"

@implementation TSConstant

NSInteger const TSConstantPhoneNumLength = 11;
NSInteger const TSConstantPwdMaxLength = 20;
NSInteger const TSConstantPwdMinLength = 6;

//赵纯洁
//NSString* const TSConstantServerUrl = @"http://192.168.1.39:8082/";
//13
//NSString* const TSConstantServerUrl = @"http://192.168.1.13:8080/hituAPP/";
NSString* const TSConstantServerUrl = @"https://app.hitumedia.com/";

#pragma mark - HttpReturnCode
NSString* const ReturnCodeSuccess = @"00000";
NSString* const ReturnCodeNoData = @"20001";

@end
