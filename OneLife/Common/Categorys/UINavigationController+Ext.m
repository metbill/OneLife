//
//  UINavigationController+Ext.m
//  HiTravelService
//
//  Created by hitomedia on 2017/4/14.
//  Copyright © 2017年 hitumedia. All rights reserved.
//

#import "UINavigationController+Ext.h"
#import "UIColor+Ext.h"

@implementation UINavigationController (Ext)
- (void)configNavigationCtrl{
    // Do any additional setup after loading the view.
    [self setNeedsStatusBarAppearanceUpdate];
    //取出Appearance对象
    UINavigationBar *navBar = [UINavigationBar appearance];
    
    [navBar setBarStyle:UIBarStyleBlack];
    //设置返回按钮为黑色
    navBar.tintColor = [UIColor colorWithR:85 G:85 B:85];
//    navBar.barTintColor = [UIColor colorWithRgb_24_148_209];
    
    //设置barButtonItem的主题
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    //不显示返回按钮的标题
    [item setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStyleDone target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backBtn];
    item.tintColor = [UIColor whiteColor];

    //设置文字颜色
    NSDictionary *attr =
    @{NSForegroundColorAttributeName:[UIColor colorWithRgb16],
      NSFontAttributeName:[UIFont fontWithName:@"STHeitiSC-Light"//@"STHeitiSC-Light"
                                          size:18.0]};
    [navBar setTitleTextAttributes:attr];
}

/**
 设置NaviBar 透明
 */
- (void)setNavigationBarBgClear{
    
    self.navigationBar.translucent = YES;
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.shadowImage = [UIImage new];
}

#pragma mark - reload 

- (UIViewController*)childViewControllerForStatusBarStyle{
    return self.visibleViewController;
}

@end
