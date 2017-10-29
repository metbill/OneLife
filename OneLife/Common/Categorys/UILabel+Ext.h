//
//  UILabel.h
//  HopeHelpClient
//
//  Created by 端倪 on 16/2/4.
//  Copyright © 2016年 deepai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UILabel(Ext)

-(void)addStarAtTopRight;

/**
 当Label设置字体和文本后，调用此方法计算label宽高

 @param width 最大宽度
 @return 实际宽高
 */
- (CGSize)labelSizeWithMaxWidth:(CGFloat)width;

+(CGSize)lableSizeWithText:(NSString*)text font:(UIFont*)font width:(CGFloat)width;



+ (UILabel*)getLabelWithTextColor:(UIColor*)textColor font:(UIFont*)font textAlignment:(NSTextAlignment)ta frame:(CGRect)fr superView:(UIView*)superView;


@end
