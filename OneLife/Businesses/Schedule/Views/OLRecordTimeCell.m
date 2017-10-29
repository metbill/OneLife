//
//  OLRecordTimeCell.m
//  OneLife
//
//  Created by hitomedia on 2017/10/23.
//  Copyright © 2017年 wkun. All rights reserved.
//

#import "OLRecordTimeCell.h"
#import "UIColor+Ext.h"
#import "UILabel+Ext.h"
#import "UIView+LayoutMethods.h"
#import "OLRecordTimeModel.h"
#import "OLEnums.h"

@implementation OLRecordTimeCell{
    UILabel *_timeL;
    UILabel *_contentL;
    UIView *_line;
    UILabel *_timeIntevalL;
    UITextField *_timeTypeTf;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if( self ){
        [self initViews];
    }
    return self;
}

- (void)setModel:(OLRecordTimeModel *)model{
    _model = model;
    _timeL.text = model.time;
    _timeIntevalL.text = model.howLong;
    
    _contentL.text = model.content;
    _timeTypeTf.text = model.typeStr;
    
    [self updateTypeTfBgColorWithType:model.type];
}

- (void)initViews{
    _timeL = [UILabel getLabelWithTextColor:[UIColor colorWithRgb16] font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentCenter frame:CGRectZero superView:self.contentView];
    _contentL = [UILabel getLabelWithTextColor:[UIColor colorWithRgb16] font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentLeft frame:CGRectZero superView:self.contentView];
    _contentL.numberOfLines = 2;
    _timeIntevalL = [UILabel getLabelWithTextColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:10] textAlignment:NSTextAlignmentCenter frame:CGRectZero superView:nil];
    _line = [UIView new];
    _line.backgroundColor = [UIColor colorWithRgb221];
    [self.contentView addSubview:_line];
    
    _timeTypeTf = [UITextField new];
    _timeTypeTf.textColor = [UIColor whiteColor];
    _timeTypeTf.font = [UIFont systemFontOfSize:12];
    _timeTypeTf.rightView = _timeIntevalL;
    _timeTypeTf.rightViewMode = UITextFieldViewModeAlways;
    [_timeTypeTf cornerRadius:3];
    _timeTypeTf.textAlignment =NSTextAlignmentCenter;
    _timeTypeTf.userInteractionEnabled =NO;
    [self.contentView addSubview:_timeTypeTf];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat ih = 16;
    CGFloat iw = 90;
    CGFloat iLeft = VIEW_X_EDGE_DISTANCE;
    _timeL.frame = CGRectMake(iLeft, (self.height-ih)/2, iw, ih);
    
    iw = 70;
    ih = 25;
    _timeTypeTf.frame = CGRectMake(self.width-iw-iLeft, (self.height-ih)/2, iw, ih);
    _timeIntevalL.frame = CGRectMake(0, 0, 30, _timeTypeTf.height);
    
    CGFloat ix = _timeL.right+10;
    iw = _timeTypeTf.x-ix-iLeft;
    _contentL.frame = CGRectMake(ix, 0, iw, self.height);
    

    
    CGFloat lineH = 0.5;
    _line.frame = CGRectMake(0, self.height-lineH, self.width, lineH);
}

- (void)updateTypeTfBgColorWithType:(OLTimeType)type{
    if( type == OLTimeTypeWaste ){
        _timeTypeTf.backgroundColor = [UIColor colorWithRgb_236_78_59];
    }
    else if( type == OLTimeTypeSleep ){
        _timeTypeTf.backgroundColor = [UIColor colorWithRgb_0_168_226];
    }
    else if( type == OLTimeTypeRoutine ){
        _timeTypeTf.backgroundColor = [UIColor colorWithRgb_255_158_28];
    }else {
        //投资
        //        _titleL.backgroundColor = []
        _timeTypeTf.backgroundColor = [UIColor colorWithRgb_101_186_127];
    }
}

@end
