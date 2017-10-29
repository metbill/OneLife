//
//  TSShowTextCell.m
//  HiTravelService
//
//  Created by hitomedia on 2017/4/20.
//  Copyright © 2017年 hitumedia. All rights reserved.
//

#import "TSShowTextCell.h"
#import "XWViewFactory.h"
#import "UIColor+Ext.h"
#import "UIView+LayoutMethods.h"

@implementation TSShowTextCell{
    UIView *_line;
}

- (instancetype)initWithReuseId:(NSString *)reuseId parameter:(TSCellParameter *)parameter{
    self = [super initWithReuseId:reuseId parameter:parameter];
    if( self ){
        _leftL =
        [XWViewFactory labelWithTextColor:[UIColor colorWithRgb102]
                                     font:[UIFont systemFontOfSize:14]
                                alignment:NSTextAlignmentLeft
                                    frame:CGRectZero
                                superView:self.contentView];
        _rightL =
        [XWViewFactory labelWithTextColor:[UIColor colorWithRgb51]
                                     font:[UIFont systemFontOfSize:15]
                                alignment:NSTextAlignmentRight
                                    frame:CGRectZero
                                superView:self.contentView];
        
        _line = [UIView new];
        _line.backgroundColor = [UIColor colorWithRgb221];
        [self.contentView addSubview:_line];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat lineH = 0.5;
    _line.frame = CGRectMake(0, self.height-lineH, SCREEN_WIDTH, lineH);
    _leftL.frame = CGRectMake(20, 0, 75, self.height);
    CGFloat ix = _leftL.right+10;
    CGFloat iw = self.width-ix-_leftL.x;
    _rightL.frame = CGRectMake(ix, 0, iw, _leftL.height);
}

- (void)setModel:(TSCellModel *)model{
    [super setModel:model];
    TSShowTextCellModel *cm = (TSShowTextCellModel*)model;
    if( [cm isKindOfClass:[TSShowTextCellModel class]] ){
        _leftL.text = cm.leftText;
        _rightL.text = cm.rightText;
        if( cm.rightTextColor){
            _rightL.textColor = cm.rightTextColor;
        }else{
            _rightL.textColor = [UIColor colorWithRgb51];
        }
    }
}

@end

@implementation TSShowTextCellModel
@end
