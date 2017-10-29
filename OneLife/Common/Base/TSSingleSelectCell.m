//
//  TSSingleSelectCell.m
//  HiTravelService
//
//  Created by hitomedia on 2017/4/19.
//  Copyright © 2017年 hitumedia. All rights reserved.
//

#import "TSSingleSelectCell.h"
#import "XWViewFactory.h"
#import "UIColor+Ext.h"
#import "UIView+LayoutMethods.h"

@implementation TSSingleSelectCell{
    UIView *_line;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if( self ){
        [self initData];
    }
    return self;
}

- (instancetype)initWithReuseId:(NSString *)reuseId parameter:(TSCellParameter *)parameter{
    self = [super initWithReuseId:reuseId parameter:parameter];
    if( self ){
        [self initData];
    }
    return self;
}

- (void)initData{
    _leftImgView = [UIImageView new];
    _leftImgView.contentMode = UIViewContentModeScaleAspectFit;
    _selectImgView = [UIImageView new];
    _selectImgView.contentMode = UIViewContentModeScaleAspectFit;
    _line = [UIView new];
    _line.backgroundColor = [UIColor colorWithRgb221];
    [self.contentView addSubview:_line];
    [self.contentView addSubview:_leftImgView];
    [self.contentView addSubview:_selectImgView];
    
    _leftL =
    [XWViewFactory labelWithTextColor:[UIColor colorWithRgb51] font:[UIFont systemFontOfSize:15] alignment:NSTextAlignmentLeft frame:CGRectMake(0, 0, 0, 0) superView:self.contentView];
    
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

//- (void)setModel:(TSSingleSelectCellModel *)model {
//    _model = model;
//    
//    _leftL.text = model.leftText;
//    _leftImgView.image = [UIImage imageNamed:model.leftImgName];
//}

- (void)setModel:(TSCellModel *)model{
    [super setModel:model];
    TSSingleSelectCellModel *cm = (TSSingleSelectCellModel*)model;
    if( [cm isKindOfClass:[TSSingleSelectCellModel class]] ){
        _leftL.text = cm.leftText;
        _leftImgView.image = [UIImage imageNamed:cm.leftImgName];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    
    NSString *imgName = self.selectedImgName;
    if( !selected ){
        imgName = self.unselectedImgName;
    }
    _selectImgView.image = [UIImage imageNamed:imgName];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat lineH = 0.5;
    CGFloat edgeDisance = 20;
    _leftImgView.frame = CGRectMake(edgeDisance, 0, 16, self.height-lineH);
    _leftL.frame = CGRectMake(_leftImgView.right+10, 0, 260, _leftImgView.height);
    CGFloat iw = 16;
    CGFloat ix = self.width-iw-edgeDisance;
    _selectImgView.frame = CGRectMake(ix, 0, iw, _leftImgView.height);
    
    _line.frame = CGRectMake(0, _selectImgView.bottom, self.width, lineH);
}

@end

@implementation TSSingleSelectCellModel
@end
