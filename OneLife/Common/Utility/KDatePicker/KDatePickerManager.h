//
//  KDatePickerManager.h
//  Hitu
//
//  Created by hitomedia on 2017/7/19.
//  Copyright © 2017年 hitomedia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KDatePickerManager : UIView


+ (void)showDatePickerWithSelectDateBlock:(void(^)(NSDate *selectDate))selectDateBlock;

@end
