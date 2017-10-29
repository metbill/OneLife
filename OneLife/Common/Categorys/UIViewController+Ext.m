//
//  UIViewController+Ext.m
//  OneLife
//
//  Created by wkun on 2017/10/21.
//  Copyright © 2017年 wkun. All rights reserved.
//

#import "UIViewController+Ext.h"

@implementation UIViewController (Ext)

- (void)configSelf{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *view = [UIView new];
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, NAVGATION_VIEW_HEIGHT);
    view.backgroundColor = [UIColor colorWithRgb248];
    [self.view addSubview:view];
    
    [self changeBackBarItem];
}

#pragma mark - Public

-(void)changeBackBarItemWithAction:(SEL)action{
    self.navigationItem.leftBarButtonItems = [self leftItemsWithTarget:self
                                                                action:action];
}

-(void)changeBackBarItem{
    [self changeBackBarItemWithAction:@selector(category_handleBackBtn:)];
}

-(void)addLeftBarItemWithAction:(SEL)action{
    self.navigationItem.leftBarButtonItems = [self leftItemsWithTarget:self
                                                                action:action
                                                               imgName:@"home_nav_left"];
}

- (void)addLeftBarItemWithAction:(SEL)action imgName:(NSString *)imgName{
    NSArray *btns = [self leftItemsWithTarget:self action:action imgName:imgName];
    self.navigationItem.leftBarButtonItems = btns;
}

- (void)addLeftBarItemWithAction:(SEL)action title:(NSString*)title textColor:(UIColor*)textColor{
    [self addLeftBarItemWithTitle:title imgName:nil selImgName:nil action:action textAlignment:NSTextAlignmentLeft textColor:textColor];
}

//-(void)addLeftBarItem{
//    [self addLeftBarItemWithAction:@selector(handleLeftBtn:)];
//}

-(void)addLeftBarItemWithTitle:(NSString *)title imgName:(NSString *)imgName selImgName:(NSString *)selImgName action:(SEL)action textAlignment:(NSTextAlignment)textAlignment textColor:(UIColor*)textColor{
    
    UIBarButtonItem *rightBarItem = [self barItemWithNormalTitle:title
                                                     normalImage:imgName
                                                      hightImage:nil
                                                     selectedImg:selImgName
                                                       andTarget:self andAction:action titleAlignment:textAlignment textColor:textColor];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                    target:nil
                                                                                    action:nil];
    negativeSpacer.width = -5;
    self.navigationItem.leftBarButtonItems = @[rightBarItem];
}


- (void)addRightBarItemWithTitle:(NSString *)title
                          action:(SEL)action{
    self.navigationItem.rightBarButtonItems = [self rightItemsWithTitle:title
                                                                imgName:nil
                                                             selImgName:nil
                                                                 action:action
                                                              titleFont:[UIFont systemFontOfSize:14.0]
                                                             titleColor:nil];
}

-(void)addRightBarItemWithTitle:(NSString *)title
                        imgName:(NSString *)imgName
                     selImgName:(NSString *)selImgName
                         action:(SEL)action
                     titleColor:(UIColor*)color
                      titleFont:(UIFont *)font{
    self.navigationItem.rightBarButtonItems = [self rightItemsWithTitle:title
                                                                imgName:imgName
                                                             selImgName:selImgName
                                                                 action:action
                                                              titleFont:font
                                                             titleColor:color];
}

-(void)addRightBarItemWithTitle:(NSString *)title imgName:(NSString *)imgName selImgName:(NSString *)selImgName action:(SEL)action textAlignment:(NSTextAlignment)textAlignment{
    
    UIBarButtonItem *rightBarItem = [self barItemWithNormalTitle:title
                                                     normalImage:imgName
                                                      hightImage:nil
                                                     selectedImg:selImgName
                                                       andTarget:self andAction:action titleAlignment:NSTextAlignmentRight];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                    target:nil
                                                                                    action:nil];
    negativeSpacer.width = -5;
    self.navigationItem.rightBarButtonItems = @[negativeSpacer,rightBarItem];
    
}

-(void)addRightBarItemWithTitle:(NSString *)title action:(SEL)action titleFont:(UIFont*)font{
    [self addRightBarItemWithTitle:title
                           imgName:nil selImgName:nil
                            action:action titleColor:nil titleFont:nil];
}


#pragma mark - UINavigationCtrl
- (void)pushViewCtrl:(UIViewController*)ctrl{
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (void)popToCtrlWithClass:(Class)ctrlClass{
    for( UIViewController *ctrl in self.navigationController.viewControllers ){
        if( [ctrl isKindOfClass:ctrlClass] ){
            [self.navigationController popToViewController:ctrl animated:YES];
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIViewController *)getCtrlAtNavigationCtrlsWithCtrlName:(NSString*)name{
    return
    [self getCtrlAtNavigationCtrlsWithCtrlClass:NSClassFromString(name)];
}

- (UIViewController *)getCtrlAtNavigationCtrlsWithCtrlClass:(Class)ctrlClass{
    if( ctrlClass == nil ) return nil;
    for( UIViewController *ctrl in self.navigationController.viewControllers ){
        if( [ctrl isKindOfClass:ctrlClass] ){
            return ctrl;
        }
    }
    return nil;
}

#pragma mark - Dispatch

- (void)dispatchAsyncQueueWithName:(const NSString *)queueName block:(dispatch_block_t)queueBlock{
    dispatch_queue_t queue = dispatch_queue_create([queueName UTF8String], DISPATCH_QUEUE_PRIORITY_DEFAULT);
    dispatch_async(queue, queueBlock);
}

- (void)dispatchAsyncMainQueueWithBlock:(dispatch_block_t)mainBlock{
    dispatch_async(dispatch_get_main_queue(), ^{
        if( mainBlock ){
            mainBlock();
        }
    });
}

- (void)dispachAsyncAfterSecond:(NSUInteger)seconds execBlock:(void(^)())execBlock{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
                       if( execBlock ){
                           execBlock();
                       }
                   });

}


#pragma mark - DataProcess

- (OLDataProcess *)dataProcess {
    return [OLDataProcess shareDataProcess];
}

- (NSObject *)modelAtIndex:(NSUInteger)index datas:(NSArray *)datas modelClass:(Class)classType{
    if( [datas isKindOfClass:[NSArray class]] ){
        if( datas.count > index ){
            id obj = datas[index];
            if( [obj isKindOfClass:classType] ){
                return obj;
            }
        }
    }
    
    return nil;
}


#pragma mark - Private
-(UIBarButtonItem*)backItemWithTarget:(id)target action:(SEL)action{
    return [self  backItemWithTarget:target action:action imgName:nil];
}

-(NSArray*)leftItemsWithTarget:(id)target action:(SEL)action{
    return [self leftItemsWithTarget:target action:action imgName:nil];
}

-(NSArray*)leftItemsWithTarget:(id)target action:(SEL)action imgName:(NSString*)imgName{
    
    UIBarButtonItem *backBarItem = [self backItemWithTarget:target action:action];
    if( imgName && imgName.length > 0 ){
        backBarItem = [self  backItemWithTarget:target action:action imgName:imgName];
    }
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                    target:nil
                                                                                    action:nil];
    negativeSpacer.width = -5;
    return @[negativeSpacer,backBarItem];
}

-(NSArray*)rightItemsWithTitle:(NSString*)title imgName:(NSString*)imgName selImgName:(NSString*)selImgName action:(SEL)action titleFont:(UIFont*)font titleColor:(UIColor*)titleColor{
    UIBarButtonItem *rightBarItem = [self barItemWithNormalTitle:title
                                                     normalImage:imgName
                                                      hightImage:nil
                                                     selectedImg:selImgName
                                                       andTarget:self andAction:action
                                                       titleFont:font titleColor:titleColor];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                    target:nil
                                                                                    action:nil];
    negativeSpacer.width = -5;
    return @[negativeSpacer,rightBarItem];
}

-(UIBarButtonItem*)backItemWithTarget:(id)target action:(SEL)action imgName:(NSString*)imgName{
    UIButton *button = [[UIButton alloc] init];
    button.frame = CGRectMake(-10, 0, 70, 40);
    NSString *name = @"arrow_right_155";
    if( imgName && imgName.length > 0 ){
        name = imgName;
    }
    [button setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, button.frame.size.width - button.currentImage.size.width);
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    if( [target respondsToSelector:action] ){
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (UIBarButtonItem *)barItemWithNormalTitle:(NSString *)title normalImage:(NSString *)normalI hightImage:(NSString *)hightI selectedImg:(NSString*)seletImgName andTarget:(id)target andAction:(SEL)action titleFont:(UIFont*)font titleColor:(UIColor*)titleColor{
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:title forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 80, 40);
    [button setImage:[UIImage imageNamed:normalI] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:hightI] forState:UIControlStateHighlighted];
    [button setImage:[UIImage imageNamed:seletImgName] forState:UIControlStateSelected];
    if( [titleColor isKindOfClass:[UIColor class]] )
        [button setTitleColor:titleColor forState:UIControlStateNormal];
    if( button.currentImage ){
        button.imageEdgeInsets = UIEdgeInsetsMake(0, button.frame.size.width - button.currentImage.size.width, 0, 0);
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    }
    else{
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
        [button setTitleColor:[UIColor colorWithWhite:0.8 alpha:0.9] forState:UIControlStateHighlighted];
        
    }
    UIFont *titleFont = [UIFont systemFontOfSize:16.0];
    if( font ){
        titleFont = font;
    }
    [button.titleLabel setFont:titleFont];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (UIBarButtonItem *)barItemWithNormalTitle:(NSString *)title normalImage:(NSString *)normalI hightImage:(NSString *)hightI selectedImg:(NSString*)seletImgName andTarget:(id)target andAction:(SEL)action titleAlignment:(NSTextAlignment)ta{
    return 
    [self barItemWithNormalTitle:title normalImage:normalI hightImage:hightI selectedImg:seletImgName andTarget:target andAction:action titleAlignment:ta textColor:nil];
}

- (UIBarButtonItem *)barItemWithNormalTitle:(NSString *)title normalImage:(NSString *)normalI hightImage:(NSString *)hightI selectedImg:(NSString*)seletImgName andTarget:(id)target andAction:(SEL)action titleAlignment:(NSTextAlignment)ta textColor:(UIColor*)color {
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:title forState:UIControlStateNormal];
    CGSize tileSize = [self lableSizeWithText:title font:[UIFont systemFontOfSize:14.0] width:100];
    button.frame = CGRectMake(0, 0, 70, 40);
    [button setImage:[UIImage imageNamed:normalI] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:hightI] forState:UIControlStateHighlighted];
    [button setImage:[UIImage imageNamed:seletImgName] forState:UIControlStateSelected];
    if( button.currentImage ){
        button.imageEdgeInsets = UIEdgeInsetsMake(0, button.frame.size.width - button.currentImage.size.width, 0, 0);
        CGFloat titleToImg = 3.0;
        button.titleEdgeInsets = UIEdgeInsetsMake(0, button.frame.size.width-button.currentImage.size.width*2 - tileSize.width - titleToImg, 0, button.currentImage.size.width+titleToImg);
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    }
    else{
        BOOL isLeft = (ta == NSTextAlignmentLeft );
        if( isLeft ){
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        }else{
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        }
    }
    if( normalI == nil ){
        UIColor *tc = color;
        if( tc == nil ){
            tc = [UIColor colorWithWhite:0.7 alpha:0.9];
        }
        [button setTitleColor:tc forState:UIControlStateNormal];
    }
    [button.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.textAlignment = ta;
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

-(CGSize)lableSizeWithText:(NSString *)text font:(UIFont *)font width:(CGFloat)width{
    CGSize size = CGSizeMake(width, MAXFLOAT);
    return [ text boundingRectWithSize:size
                               options:NSStringDrawingUsesLineFragmentOrigin
                            attributes:@{NSFontAttributeName:font} context:nil].size;
}

#pragma mark - TouchEvents
- (void)category_handleBackBtn:(id)obj{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
