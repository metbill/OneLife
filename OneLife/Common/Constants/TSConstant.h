//
//  TSConstant.h
//  HiTravelService
//
//  Created by hitomedia on 2017/4/27.
//  Copyright © 2017年 hitumedia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSConstant : NSObject

extern NSInteger const TSConstantPhoneNumLength;
extern NSInteger const TSConstantPwdMaxLength;
extern NSInteger const TSConstantPwdMinLength;

extern NSString* const TSConstantServerUrl;

#pragma mark - HttpReturnCode
extern NSString* const ReturnCodeSuccess;   //请求成功
extern NSString* const ReturnCodeNoData;    //没有数据


@end
