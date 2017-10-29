//
//  XWKeyboardToolView.m
//  OneLife
//
//  Created by hitomedia on 2017/10/24.
//  Copyright © 2017年 wkun. All rights reserved.
//

#import "XWKeyboardToolView.h"

@implementation XWKeyboardToolView{
    UIButton *_prevBtn;
    UIButton *_nextBtn;
    UIButton *_sureBtn;
}

#pragma mark - Public

- (void)reloadData{
    if( _delegate && [_delegate respondsToSelector:@selector(keyboardToolViewItemNormalImageNameAtIndex:)]){
        
        NSArray *btns = @[_prevBtn,_nextBtn];
        for( NSUInteger i=0; i<btns.count; i++ ){
            NSString *imgName = [_delegate keyboardToolViewItemNormalImageNameAtIndex:i];
            if( imgName.length ){
                UIButton *btn = btns[i];
                [btn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
                [btn setImage:nil forState:UIControlStateHighlighted];
            }
        }
    }
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if( self ){
        [self initViews];
    }
    return self;
}

#pragma mark - Private

- (void)initViews{
    _prevBtn = [self getNewBtnWithImg:@"arrow_prev" selectImgName:@"arrow_prev_highlight" action:@selector(handlePrevBtn)];
    _nextBtn = [self getNewBtnWithImg:@"arrow_next" selectImgName:@"arrow_next_highlight" action:@selector(handleNextBtn)];
    
    _sureBtn = [UIButton new];
    [_sureBtn setTitle:@"创建" forState:UIControlStateNormal];
    UIColor *titleColor = [UIColor colorWithRed:24/255.0 green:148/255.0 blue:209/255.0 alpha:1.0];
    [_sureBtn setTitleColor:titleColor forState:UIControlStateNormal];
    _sureBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_sureBtn addTarget:self action:@selector(handleSureBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_sureBtn];
    
    _sureBtn.layer.masksToBounds = YES;
    _sureBtn.layer.borderColor = titleColor.CGColor;
    _sureBtn.layer.borderWidth = 1.0;
    _sureBtn.layer.cornerRadius = 3;
}

- (UIButton*)getNewBtnWithImg:(NSString*)nImgName selectImgName:(NSString*)sImgName action:(SEL)action{
    UIButton *btn = [UIButton new];
    [btn setImage:[UIImage imageNamed:nImgName] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:sImgName] forState:UIControlStateHighlighted];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    
    return btn;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat wh = 44;
    CGFloat ileft = 15;
    CGFloat viewH = CGRectGetHeight(self.frame);
    _prevBtn.frame = CGRectMake(ileft, (viewH-wh)/2, wh, wh);
    _nextBtn.frame = CGRectMake(CGRectGetMaxX(_prevBtn.frame)+10, CGRectGetMinY(_prevBtn.frame), wh, wh);
    CGFloat iw = 50;
    CGFloat ih = 30;
    _sureBtn.frame = CGRectMake(CGRectGetWidth(self.frame)-iw-ileft, (viewH-ih)/2, iw, ih);
}

#pragma mark - TouchEvents
- (void)handlePrevBtn{
    [self handleBtnWithIndex:0];
}
- (void)handleNextBtn{
    [self handleBtnWithIndex:1];
}
- (void)handleSureBtn{
    [self handleBtnWithIndex:2];
}

- (void)handleBtnWithIndex:(NSUInteger)idx{
    if( _delegate && [ _delegate respondsToSelector:@selector(keyboardToolView:handleBtnAtIndex:)]){
        [_delegate keyboardToolView:self handleBtnAtIndex:idx];
    }
}

@end
