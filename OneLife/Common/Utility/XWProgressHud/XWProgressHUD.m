//
//  XWProgressHUD.m
//  XWPlanExcel
//
//  Created by hitomedia on 2017/8/22.
//  Copyright © 2017年 hitumedia. All rights reserved.
//

#import "XWProgressHUD.h"

@implementation XWProgressHUD{
    UILabel *_msgL;
    NSTimer *_timer;
}

#pragma mark - Public

+ (void)showError:(NSString *)err{
    [[XWProgressHUD shareProgress] showErr:err];
}

+ (void)showMsg:(NSString *)msg{
    [[XWProgressHUD shareProgress] showErr:msg];
}

#pragma mark - Private

+ (XWProgressHUD*)shareProgress{
    static dispatch_once_t onceToken;
    static XWProgressHUD *hud = nil;
    dispatch_once(&onceToken, ^{
        CGSize size = [UIScreen mainScreen].bounds.size;
        CGRect frame = CGRectMake(0, 0, size.width, size.height);
        hud = [[XWProgressHUD alloc] initWithFrame:frame];
    });
    return hud;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if( self ){
        [self initViews];
    }
    return self;
}

- (void)initViews{
    _msgL = [UILabel new];
    CGSize size = [UIScreen mainScreen].bounds.size;
    _msgL.frame = CGRectMake(0, 0, size.width, size.height);
    _msgL.font = [UIFont systemFontOfSize:18];
    _msgL.textColor = [UIColor redColor];
    _msgL.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_msgL];
    
    self.backgroundColor = [UIColor clearColor];
}

- (void)showErr:(NSString*)msg{
    if( self.superview ){
        return;
    }
    
    _msgL.text = msg;
    UIWindow *keyW = [UIApplication sharedApplication].keyWindow;
    [keyW addSubview:self];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.5 repeats:NO block:^(NSTimer * _Nonnull timer) {
        [self removeFromSuperview];
    }];
}


@end
