//
//  UIView+LayoutMethods.h
//  TmallClient4iOS-Prime
//
//  Created by casa on 14/12/8.
//  Copyright (c) 2014年 casa. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define SCREEN_WIDTH ([[UIScreen mainScreen]bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen]bounds].size.height)
#define SCREEN_WITHOUT_STATUS_HEIGHT (SCREEN_HEIGHT - [[UIApplication sharedApplication] statusBarFrame].size.height)
#define STATUS_BAR_HEIGHT 20.0f
#define NAVGATION_VIEW_HEIGHT 64.0f
#define TABBAR_VIWE_HEIGHT 49.0f

//X方向的边距，若屏幕宽度为非Plus设备，则为10，否则为15
#define VIEW_X_EDGE_DISTANCE ((SCREEN_WIDTH < (375+1))?10.0:15.0)
#define VIEW_Y_GAP 10.0f

//typedef CGFloat UIScreenType
//
//static UIScreenType UIScreenType_iPhone6 = 375.0f;

typedef NS_ENUM(NSInteger,UIScreenType){
    UIScreenTypeNone = -1,
    UIScreenTypeIPhone4 ,
    UIScreenTypeIPhone4s,
    UIScreenTypeIPhone5,
    UIScreenTypeIPhone5s,
    UIScreenTypeIPhone5c,
    UIScreenTypeIPhone6,
    UIScreenTypeIPhone6plus,
    UIScreenTypeIPhone6s,
    UIScreenTypeIPhone6sPlus,
    UIScreenTypeOther
};

@interface UIView (LayoutMethods)
//base view size
/**
 *  UI作图依照的设备的高度。如iphont6,则为667
 *
 *  @return UI作图依照的设备的高度
 */
-(CGFloat)baseHeight;
/**
 *  UI作图依照的设备的宽度。如iphont6,则为375
 *
 *  @return UI作图依照的设备的宽度
 */
-(CGFloat)baseWidth;
//ScreenType
-(UIScreenType)screenType;

// coordinator getters
- (CGFloat)height;
- (CGFloat)width;
- (CGFloat)x;
- (CGFloat)y;
- (CGSize)size;
- (CGPoint)origin;
- (CGFloat)centerX;
- (CGFloat)centerY;

- (CGFloat)left;
- (CGFloat)top;
- (CGFloat)bottom;
- (CGFloat)right;

- (void)setX:(CGFloat)x;
- (void)setLeft:(CGFloat)left;
- (void)setY:(CGFloat)y;
- (void)setTop:(CGFloat)top;

// height
- (void)setHeight:(CGFloat)height;
- (void)heightEqualToView:(UIView *)view;

// width
- (void)setWidth:(CGFloat)width;
- (void)widthEqualToView:(UIView *)view;

// center
- (void)setCenterX:(CGFloat)centerX;
- (void)setCenterY:(CGFloat)centerY;
- (void)centerXEqualToView:(UIView *)view;
- (void)centerYEqualToView:(UIView *)view;

// top, bottom, left, right
- (void)top:(CGFloat)top FromView:(UIView *)view;
- (void)bottom:(CGFloat)bottom FromView:(UIView *)view;
- (void)left:(CGFloat)left FromView:(UIView *)view;
- (void)right:(CGFloat)right FromView:(UIView *)view;

- (void)topRatio:(CGFloat)top FromView:(UIView *)view screenType:(UIScreenType)screenType;
- (void)bottomRatio:(CGFloat)bottom FromView:(UIView *)view screenType:(UIScreenType)screenType;
- (void)leftRatio:(CGFloat)left FromView:(UIView *)view screenType:(UIScreenType)screenType;
- (void)rightRatio:(CGFloat)right FromView:(UIView *)view screenType:(UIScreenType)screenType;

- (void)topInContainer:(CGFloat)top shouldResize:(BOOL)shouldResize;
- (void)bottomInContainer:(CGFloat)bottom shouldResize:(BOOL)shouldResize;
- (void)leftInContainer:(CGFloat)left shouldResize:(BOOL)shouldResize;
- (void)rightInContainer:(CGFloat)right shouldResize:(BOOL)shouldResize;

- (void)topRatioInContainer:(CGFloat)top shouldResize:(BOOL)shouldResize screenType:(UIScreenType)screenType;
- (void)bottomRatioInContainer:(CGFloat)bottom shouldResize:(BOOL)shouldResize screenType:(UIScreenType)screenType;
- (void)leftRatioInContainer:(CGFloat)left shouldResize:(BOOL)shouldResize screenType:(UIScreenType)screenType;
- (void)rightRatioInContainer:(CGFloat)right shouldResize:(BOOL)shouldResize screenType:(UIScreenType)screenType;

- (void)topEqualToView:(UIView *)view;
- (void)bottomEqualToView:(UIView *)view;
- (void)leftEqualToView:(UIView *)view;
- (void)rightEqualToView:(UIView *)view;

// size
- (void)setSize:(CGSize)size;
- (void)sizeEqualToView:(UIView *)view;

// imbueset
- (void)fillWidth;
- (void)fillHeight;
- (void)fill;

- (UIView *)topSuperView;

- (void)cornerRadius:(CGFloat)radius;
- (void)bolderWidth:(CGFloat)bw;
- (void)bolderColor:(UIColor*)bo;

@end

@protocol LayoutProtocol
@required
// put your layout code here
- (void)calculateLayout;
@end
