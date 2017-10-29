//
//  UIViewController+Ext.h
//  OneLife
//
//  Created by wkun on 2017/10/21.
//  Copyright © 2017年 wkun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+LayoutMethods.h"
#import "UIColor+Ext.h"
#import "XWProgressHUD.h"
#import "OLDataProcess.h"

@interface UIViewController (Ext)

- (void)configSelf;

/**
 *  替换掉系统的返回按钮
 */
- (void)changeBackBarItem;
- (void)changeBackBarItemWithAction:(SEL)action;

/**
 *  添加导航栏左侧按钮
 */
//-(void)addLeftBarItem;
- (void)addLeftBarItemWithAction:(SEL)action;
- (void)addLeftBarItemWithAction:(SEL)action imgName:(NSString*)imgName;
- (void)addLeftBarItemWithAction:(SEL)action title:(NSString*)title textColor:(UIColor*)textColor;

/**
 *  添加右侧导航栏按钮
 *
 *  @param title 按钮标题
 */

- (void)addRightBarItemWithTitle:(NSString*)title
                         action:(SEL)action;

- (void)addRightBarItemWithTitle:(NSString*)title
                         action:(SEL)action
                      titleFont:(UIFont*)font;

- (void)addRightBarItemWithTitle:(NSString *)title
                        imgName:(NSString*)imgName
                     selImgName:(NSString*)selImgName
                         action:(SEL)action
                     titleColor:(UIColor*)color
                      titleFont:(UIFont*)font;
- (void)addRightBarItemWithTitle:(NSString *)title
                        imgName:(NSString*)imgName
                     selImgName:(NSString*)selImgName
                         action:(SEL)action
                  textAlignment:(NSTextAlignment)textAlignment;

#pragma mark - UINavigationCtrl

- (void)pushViewCtrl:(UIViewController*)ctrl;

/**
 pop到某个ctrl
 
 @param ctrlClass 要得到的ctrl的类Class 如：[UIViewController class],
 若导航控制器中，不存在该ctrl,则pop到上一ctrl
 */
- (void)popToCtrlWithClass:(Class)ctrlClass;

- (UIViewController *)getCtrlAtNavigationCtrlsWithCtrlName:(NSString*)name;
/**
 得到导航控制器的viewControllers 数组中的某一个ctrl的实例
 
 @param ctrlClass 要得到的ctrl的类Class 如：[UIViewController class]
 @return ctrl
 */
- (UIViewController*)getCtrlAtNavigationCtrlsWithCtrlClass:(Class)ctrlClass;

#pragma mark - Dispatch

/**
 *  获取一个异步新线程,不包含主线程回调
 *
 *  @param queueName  线程名字
 *  @param queueBlock 新线程的代码块
 */
- (void)dispatchAsyncQueueWithName:(const NSString*)queueName block:(dispatch_block_t)queueBlock;

- (void)dispatchAsyncMainQueueWithBlock:(dispatch_block_t)mainBlock;

- (void)dispachAsyncAfterSecond:(NSUInteger)seconds execBlock:(void(^)())execBlock;
#pragma mark - DataProcess

- (OLDataProcess*)dataProcess;

- (NSObject *)modelAtIndex:(NSUInteger)index datas:(NSArray *)datas modelClass:(Class)classType;


@end
