//
//  TSTextArrowCell.m
//  HiTravelService
//
//  Created by hitomedia on 2017/4/26.
//  Copyright © 2017年 hitumedia. All rights reserved.
//

#import "TSTextArrowCell.h"

@implementation TSTextArrowCell

- (id)initWithReuseId:(NSString *)reuseId parameter:(TSCellParameter *)parameter{
    self = [super initWithReuseId:reuseId parameter:parameter];
    if( self ){
        self.selectedImgName = @"msg_arrow_right";
        self.unselectedImgName = @"msg_arrow_right";
        self.selectImgView.contentMode = UIViewContentModeCenter;
        
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    return self;
}

@end
