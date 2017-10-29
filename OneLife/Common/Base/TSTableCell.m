//
//  TSTableCell.m
//  HiTravelService
//
//  Created by hitomedia on 2017/4/18.
//  Copyright © 2017年 hitumedia. All rights reserved.
//

#import "TSTableCell.h"

@implementation TSTableCell

- (id)initWithReuseId:(NSString*)reuseId parameter:(TSCellParameter*)parameter{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    if( self ){
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end


@implementation TSCellParameter

@end
