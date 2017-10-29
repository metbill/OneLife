//
//  TSShowTextCell.h
//  HiTravelService
//
//  Created by hitomedia on 2017/4/20.
//  Copyright © 2017年 hitumedia. All rights reserved.
//

#import "TSTableCell.h"
#import "TSCellModel.h"
@interface TSShowTextCell : TSTableCell
//views
@property (nonatomic, strong) UILabel *leftL;
@property (nonatomic, strong) UILabel *rightL;

@end

@interface TSShowTextCellModel : TSCellModel
@property (nonatomic, strong) NSString *leftText;
@property (nonatomic, strong) NSString *rightText;

/**
 如果为nil，则为默认颜色
 */
@property (nonatomic, strong) UIColor *rightTextColor;
@end
