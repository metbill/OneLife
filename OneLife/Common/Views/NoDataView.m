//
//  NoDataView.m
//  HiTravelService
//
//  Created by hitomedia on 2017/5/5.
//  Copyright © 2017年 hitumedia. All rights reserved.
//

#import "NoDataView.h"
#import "UIView+LayoutMethods.h"
#import "UIColor+Ext.h"

@implementation NoDataView
{
    UIButton *_reloadBtn;
    UILabel  *_textL;
}

- (id)initWithFrame:(CGRect)fr text:(NSString*)text action:(SEL)loadDataSel target:(UIViewController*)target{
    self = [super initWithFrame:fr];
    if( self ){
        UIView *noDataView = self;//[UIView new];
        noDataView.frame = fr;
        UIImageView *iv = [[UIImageView alloc] init];
        iv.image = [UIImage imageNamed:@"no_data_icon"];
        UILabel* lbl = [UILabel new];
        _textL = lbl;
        lbl.text = text;
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.font = [UIFont systemFontOfSize:15.0];
        lbl.textColor = [UIColor colorWithRgb153];
        
        CGFloat lh = 20;
        CGFloat bh = 40;
        CGFloat yGap = 5;
        CGFloat th = iv.image.size.height + lh + yGap + bh + 4*yGap;
        CGFloat ix = (fr.size.width - iv.image.size.width)/2;
        CGFloat iy = (fr.size.height-th)/2 - 25;
        iv.frame = CGRectMake(ix, iy, iv.image.size.width, iv.image.size.height);
        lbl.frame = CGRectMake(0, iv.bottom+yGap, fr.size.width, lh);
        
        [noDataView addSubview:iv];
        [noDataView addSubview:lbl];
        
        UIButton *loadBtn = [[UIButton alloc ] init];
        [loadBtn setTitle:@"重新加载" forState:UIControlStateNormal];
        [loadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        loadBtn.titleLabel.font = [UIFont systemFontOfSize:15];
   
        [loadBtn setBackgroundImage:[UIImage imageNamed:@"btn_blue_bg"] forState:UIControlStateNormal];
        [loadBtn setBackgroundImage:[UIImage imageNamed:@"btn_blue_highlight_bg"] forState:UIControlStateHighlighted];
        CGFloat bw = 120;
        loadBtn.frame = CGRectMake((fr.size.width-bw)/2, lbl.bottom+4*yGap, bw, bh);
        if( loadDataSel && [target respondsToSelector:loadDataSel] ){
            [loadBtn addTarget:target action:loadDataSel forControlEvents:UIControlEventTouchUpInside];
        }
        loadBtn.layer.masksToBounds = YES;
        loadBtn.layer.cornerRadius = 5.0;
        [noDataView addSubview:loadBtn]; //去掉重新加载按钮
        _reloadBtn = loadBtn;
        
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)setHideReloadBtn:(BOOL)hideReloadBtn{
    _hideReloadBtn = hideReloadBtn;
    _reloadBtn.hidden = hideReloadBtn;
}

- (void)setText:(NSString *)text{
    _text = text;
    _textL.text = text;
}

@end
