//
//  KError.m
//  HopeHelpClient
//
//  Created by wkun on 3/27/16.
//  Copyright © 2016 deepai. All rights reserved.
//

#import "KError.h"

static NSString *kErrorTableName = @"KError";
static NSString *kErrorDesKey = @"KErrorDesKey";

@implementation KError

#pragma mark - Private
+ (KError*)shareError{
    static dispatch_once_t token = 0;
    static KError *err = nil;
    dispatch_once(&token, ^{
        err = [[KError alloc] init];
    });
    return err;
}

#pragma mark - Public
+ (NSString *)errorMsgWithCode:(NSInteger)code{
    return [[KError shareError] errorMsgWithCode:code];
}

+ (NSString*)errorMsgWithError:(NSError*)err{
    return [[KError shareError] errorMsgWithError:err];
}

+ (NSString *)errorMsgWithCode:(NSInteger )code msg:(NSString *)msg{
    return [[KError shareError] errorMsgWithCode:code msg:msg];
}

+ (NSError *)errorWithDomain:(NSString *)domain code:(NSInteger )code msg:(NSString *)msg{
    return [[KError shareError] errorWithDomain:domain code:code msg:msg];
}

+ (NSError*)errorWithCode:(NSInteger )code msg:(NSString *)msg{
    return [[KError shareError] errorWithCode:code msg:msg];
}

#pragma mark - Private
- (NSString*)stringWithCode:(NSInteger)code{
    return [NSString stringWithFormat:@"%ld",(long)code];
}

- (NSString *)errorMsgWithCode:(NSInteger )code{
    return NSLocalizedStringFromTable([self stringWithCode:code], kErrorTableName, nil);
}

- (NSString*)errorMsgWithError:(NSError*)err{
    NSString *msg = err.userInfo[kErrorDesKey];;
    
    if( ![msg isKindOfClass:[NSString class]] )
        return @"未知错误";

    return msg;
}

- (NSString *)errorMsgWithCode:(NSInteger )code msg:(NSString *)msg{
    if( msg  && [msg isEqualToString:@""] == NO ){
        return msg;
    }
    
    else {
        return [self errorMsgWithCode:code];
    }
}

- (NSError *)errorWithDomain:(NSString *)domain code:(NSInteger )code msg:(NSString *)msg{
    if( [msg isKindOfClass:[NSString class]] == NO )
        msg = @"未知错误";//[NSNull null];
    NSError *err = [NSError errorWithDomain:domain code:code userInfo:@{kErrorDesKey:msg}];
    return err;
}

- (NSError*)errorWithCode:(NSInteger )code msg:(NSString *)msg{
    NSError *err = [self errorWithDomain:KErrorDomainDataFormmatter code:code msg:msg];
    return err;
}

@end
