//
//  OLTargetCell.m
//  OneLife
//
//  Created by wkun on 2017/10/23.
//  Copyright © 2017年 wkun. All rights reserved.
//

#import "OLTargetCell.h"
#import "UILabel+Ext.h"
#import "UIColor+Ext.h"
#import "UIView+LayoutMethods.h"
#import "OLTargetModel.h"

@implementation OLTargetCell{
    UILabel *_nameL;
    UILabel *_endDateL;
    UILabel *_needHoursL;
    UIImageView *_arrowIv;
    UIView *_line;
    
    UILabel *_statusL;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if( self ){
        [self initViews];
    }
    return self;
}

- (void)setModel:(OLTargetModel *)model {
    _model = model;
    _nameL.text = model.name;
    _needHoursL.text = model.needHours;
    _endDateL.text = model.endDate;
    
    _statusL.hidden = (model.status == OLTargetStatusContinue);
    
    UIColor *titleColor = [UIColor colorWithRgb_24_148_209];
    NSString *title = @"已完成";
    if( model.status == OLTargetStatusExpired ){
        titleColor = [UIColor colorWithRgb_229_28_35];
        title = @"已过期";
    }
    _statusL.textColor = titleColor;
    _statusL.text = title;
}

- (void)initViews{
    _nameL =
    [UILabel getLabelWithTextColor:[UIColor colorWithRgb_229_28_35]
                              font:[UIFont systemFontOfSize:18]
                     textAlignment:NSTextAlignmentLeft
                             frame:CGRectZero
                         superView:self.contentView];

    _endDateL =
    [UILabel getLabelWithTextColor:[UIColor colorWithRgb102]
                              font:[UIFont systemFontOfSize:14]
                     textAlignment:NSTextAlignmentLeft
                             frame:CGRectZero
                         superView:self.contentView];
    _needHoursL =
    [UILabel getLabelWithTextColor:[UIColor colorWithRgb102]
                              font:[UIFont systemFontOfSize:14]
                     textAlignment:NSTextAlignmentRight
                             frame:CGRectZero
                         superView:self.contentView];
    _line = [UIView new];
    _line.backgroundColor = [UIColor colorWithRgb221];
    [self.contentView addSubview:_line];
    
    _arrowIv = [UIImageView new];
    _arrowIv.image = [UIImage imageNamed:@"arrow_left"];
    [self.contentView addSubview:_arrowIv];
    
    _statusL =
    [UILabel getLabelWithTextColor:[UIColor redColor]
                              font:[UIFont systemFontOfSize:28]
                     textAlignment:NSTextAlignmentCenter
                             frame:CGRectZero
                         superView:self.contentView];
    _statusL.hidden = YES;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat iLeft = VIEW_X_EDGE_DISTANCE;
    CGFloat ix = self.width-iLeft-_arrowIv.image.size.width;
    CGFloat iy = (self.height-_arrowIv.image.size.height)/2;
    _arrowIv.frame = CGRectMake(ix, iy, _arrowIv.image.size.width, _arrowIv.image.size.height);
    CGFloat iw = 80;
    _needHoursL.frame = CGRectMake(_arrowIv.x-iw-3, 0, iw, self.height);
    _nameL.frame = CGRectMake(iLeft, 5, _needHoursL.x-iLeft, self.height/2-5);
    _endDateL.frame = CGRectMake(iLeft, _nameL.bottom, _nameL.width, 16);
    _line.frame = CGRectMake(0, self.height-0.5, self.width, 0.5);
    
    _statusL.frame = CGRectMake(0, 0, self.width, self.height);
}


@end


