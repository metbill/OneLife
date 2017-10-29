//
//  OLScheduleCell.m
//  OneLife
//
//  Created by wkun on 2017/10/22.
//  Copyright © 2017年 wkun. All rights reserved.
//

#import "OLScheduleCell.h"
#import "UIView+LayoutMethods.h"
#import "UILabel+Ext.h"
#import "UIColor+Ext.h"
#import "OLScheduleModel.h"

@implementation OLScheduleCell{
    UIButton *_selectBtn; //选择框按钮
    UILabel *_scheduleL;  //日程内容
    UILabel *_remarkL;    //备注，如已延期等
    UIView *_line;
}

#pragma mark - 🚪public

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if( self ){
        [self initViews];
    }
    return self;
}

#pragma mark - 🔒private

- (void)initViews{
    _selectBtn = [UIButton new];
    [_selectBtn setImage:[UIImage imageNamed:@"checked_18x18"] forState:UIControlStateSelected];
    _selectBtn.userInteractionEnabled = NO;
    [self.contentView addSubview:_selectBtn];
    
    _scheduleL = [UILabel getLabelWithTextColor:[UIColor colorWithRgb16] font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentLeft frame:CGRectZero superView:self.contentView];
    _remarkL = [UILabel getLabelWithTextColor:[UIColor colorWithRgb_229_28_35] font:[UIFont systemFontOfSize:13] textAlignment:NSTextAlignmentRight frame:CGRectZero superView:self.contentView];
    _line = [UIView new];
    _line.backgroundColor = [UIColor colorWithRgb221];
    [self.contentView addSubview:_line];
}

- (void)doLayout{
    CGFloat btnW = 60;
    CGFloat ih = self.height;
    _selectBtn.frame = CGRectMake(0, 0, btnW, ih);
    CGFloat iw = [_remarkL labelSizeWithMaxWidth:150].width;
    CGFloat iRight = VIEW_X_EDGE_DISTANCE;
    CGFloat scheduleW = self.width-iRight-_selectBtn.right;
    if( iw > 0 ){
        _remarkL.frame = CGRectMake(self.width-iw-iRight, 0, iw, ih);
        scheduleW = _remarkL.x-_selectBtn.right-5;
    }
    _scheduleL.frame = CGRectMake(_selectBtn.right, 0, scheduleW, ih);
}

- (void)updateScheduleContentWithModel:(OLScheduleModel*)model{
    if( model.scheduleStatus != OLScheduleStatusCompleted ){
        _scheduleL.text = model.scheduleContent;
    }else {
        if( [model.scheduleContent isKindOfClass:[NSString class]] ==NO ) return;
        //添加中划线
        NSDictionary *attribtDic = @{
                                     
                                     NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle],
                                     NSBaselineOffsetAttributeName:@(NSUnderlineStyleSingle),
                                     NSFontAttributeName:[UIFont systemFontOfSize:14],
                                     NSForegroundColorAttributeName:[UIColor colorWithRgb102]};
        
        NSMutableAttributedString *attriText = [[NSMutableAttributedString alloc] initWithString:model.scheduleContent attributes:attribtDic];
        _scheduleL.attributedText = attriText;
    }
}

- (void)updateViewsLayoutWithStatus:(OLScheduleStatus)status isDelayed:(BOOL)isDelayed{
    BOOL isCompleted = (status==OLScheduleStatusCompleted);
    _remarkL.hidden = isCompleted;
    _selectBtn.selected = isCompleted;
    
    NSString *imgName = @"box_yellow_18x18";
    if( !isDelayed )
        imgName = @"box_red_18x18";
    [_selectBtn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
}

#pragma mark - 🍐delegate
#pragma mark - ☎️notification
#pragma mark - 🎬event response
#pragma mark - ☸getter and setter

- (void)setModel:(OLScheduleModel *)model{
    _model = model;

    [self updateScheduleContentWithModel:model];
    _remarkL.text = model.remark;
    
    [self doLayout];
    
    [self updateViewsLayoutWithStatus:model.scheduleStatus isDelayed:model.isDelayed];
}

#pragma mark - 🔄overwrite
- (void)layoutSubviews{
    [super layoutSubviews];
    [self doLayout];
    
    CGFloat lineH = 0.5;
    _line.frame = CGRectMake(0, self.height-lineH, self.width, lineH);
}


@end
