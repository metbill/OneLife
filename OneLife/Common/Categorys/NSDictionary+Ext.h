//
//  NSDictionary+Ext.h
//  Hitu
//
//  Created by hitomedia on 2016/11/15.
//  Copyright © 2016年 hitomedia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Ext)

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
+ (NSString*)convertToJSONData:(id)infoDict;

+ (NSDictionary*)dictionaryWithKeys:(NSArray<NSString*>*)keys values:(NSString*)values, ...NS_REQUIRES_NIL_TERMINATION;
- (void)testParams:(NSString *)title addMoreParams:(NSString *)string, ...NS_REQUIRES_NIL_TERMINATION;
@end
