//
//  XWKeyboardToolView.h
//  OneLife
//
//  Created by hitomedia on 2017/10/24.
//  Copyright © 2017年 wkun. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 在键盘上方的工具视图
 */
@protocol XWKeyboardToolViewDelegate;
@interface XWKeyboardToolView : UIView
@property (nonatomic, assign) id<XWKeyboardToolViewDelegate> delegate;

- (void)reloadData;

@end

@protocol XWKeyboardToolViewDelegate <NSObject>

@optional

/**
 点击按钮事件

 @param toolView 本实例
 @param index 按钮索引，从左至右依次为 0，1，2
 */
- (void)keyboardToolView:(XWKeyboardToolView*)toolView handleBtnAtIndex:(NSUInteger)index;

/**
 按钮的图标

 @param index 从左至右 0开始
 @return 图片名字
 */
- (NSString*)keyboardToolViewItemNormalImageNameAtIndex:(NSUInteger)index;
@end
