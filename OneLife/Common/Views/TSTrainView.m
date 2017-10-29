//
//  TSTrainView.m
//  HiTravelService
//
//  Created by hitomedia on 2017/4/21.
//  Copyright © 2017年 hitumedia. All rights reserved.
//

#import "TSTrainView.h"
#import "UIView+LayoutMethods.h"
#import "UIColor+Ext.h"

@interface TSTrainView()

@end

@implementation TSTrainView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if( self){
        
    }
    return self;
}

#pragma mark - Private

- (void)configLbl:(UILabel*)lbl font:(UIFont*)font textColor:(UIColor*)color textAlignment:(NSTextAlignment)alignment frame:(CGRect)fr{
    lbl.font = font;
    lbl.textColor = color;
    lbl.textAlignment = alignment;
    lbl.frame = fr;
}

#pragma mark - Propertys
- (UIImageView*)tourLine {
    if( !_tourLine ){
        _tourLine = [[UIImageView alloc] init];
        UIImage *tourImg = [UIImage imageNamed:@"tb_list_line"];
        _tourLine.image = tourImg;
        _tourLine.frame = CGRectMake((self.width-tourImg.size.width)/2,
                                     (self.height-tourImg.size.height)/2,
                                     tourImg.size.width, tourImg.size.height);
        
        [self addSubview:_tourLine];
    }
    return _tourLine;
}

- (UILabel *)trainNumL {
    if( !_trainNumL ){
        _trainNumL = [[UILabel alloc] init];
        CGFloat ih = 16;
        CGRect fr = CGRectMake(self.tourLine.x, self.tourLine.y-ih, self.tourLine.width, ih);
        [self configLbl:_trainNumL
                   font:[UIFont systemFontOfSize:12]
              textColor:[UIColor colorWithRgb68]
          textAlignment:NSTextAlignmentCenter
                  frame:fr];
        [self addSubview:_trainNumL];
    }
    return _trainNumL;
}

- (UILabel *)tourTimeL {
    if( !_tourTimeL ){
        _tourTimeL = [[UILabel alloc] init];
        CGRect fr = CGRectMake(self.tourLine.x-20, self.tourLine.bottom, self.tourLine.width+40, self.trainNumL.height);
        [self configLbl:_tourTimeL
                   font:[UIFont systemFontOfSize:12]
              textColor:[UIColor colorWithRgb68]
          textAlignment:NSTextAlignmentCenter
                  frame:fr];
        
        [self addSubview:_tourTimeL];
    }
    return _tourTimeL;
}

- (UILabel *)departureStationL {
    if( !_departureStationL ){
        _departureStationL = [[UILabel alloc] init];
        CGFloat ih = 20;
        CGFloat ix = 18;
        CGRect fr = CGRectMake(ix, self.height/2-ih, (self.width-self.tourLine.width-2*ix)/2, ih);
        [self configLbl:_departureStationL
                   font:[UIFont systemFontOfSize:15]
              textColor:[UIColor colorWithRgb51]
          textAlignment:NSTextAlignmentLeft
                  frame:fr];
        
        [self addSubview:_departureStationL];
    }
    return _departureStationL;
}

- (UILabel *)departureTimeL {
    if( !_departureTimeL ){
        _departureTimeL = [[UILabel alloc] init];
        CGRect fr = CGRectMake(self.departureStationL.x, self.departureStationL.bottom, self.departureStationL.width, self.departureStationL.height);
        [self configLbl:_departureTimeL
                   font:[UIFont boldSystemFontOfSize:18]
              textColor:[UIColor colorWithRgb51]
          textAlignment:NSTextAlignmentLeft
                  frame:fr];
        
        [self addSubview:_departureTimeL];
    }
    return _departureTimeL;
}

- (UILabel*)arrivalStationL {
    if( !_arrivalStationL ){
        _arrivalStationL = [[UILabel alloc] init];
        CGRect fr = CGRectMake(self.tourLine.right, self.departureStationL.y, _departureStationL.width, _departureStationL.height);
        [self configLbl:_arrivalStationL
                   font:self.departureStationL.font
              textColor:self.departureStationL.textColor
          textAlignment:NSTextAlignmentRight
                  frame:fr];
        
        [self addSubview:_arrivalStationL];
    }
    return _arrivalStationL;
}

- (UILabel *)arrivalTimeL {
    if( !_arrivalTimeL ){
        _arrivalTimeL = [[UILabel alloc] init];
        CGRect fr = CGRectMake(self.arrivalStationL.x, self.arrivalStationL.bottom, _arrivalStationL.width, _arrivalStationL.height);
        [self configLbl:_arrivalTimeL
                   font:self.departureTimeL.font
              textColor:_departureTimeL.textColor
          textAlignment:NSTextAlignmentRight
                  frame:fr];
        
        [self addSubview:_arrivalTimeL];
    }
    return _arrivalTimeL;
}


@end
