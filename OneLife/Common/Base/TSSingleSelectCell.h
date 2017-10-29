//
//  TSSingleSelectCell.h
//  HiTravelService
//
//  Created by hitomedia on 2017/4/19.
//  Copyright © 2017年 hitumedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSTableCell.h"
#import "TSCellModel.h"

@class TSSingleSelectCellModel;
@interface TSSingleSelectCell : TSTableCell
///Views
@property (nonatomic, strong) UIImageView *leftImgView;
@property (nonatomic, strong) UIImageView *selectImgView;
@property (nonatomic, strong) UILabel *leftL;

//imgs
@property (nonatomic, strong) NSString *selectedImgName;
@property (nonatomic, strong) NSString *unselectedImgName;
@end


@interface TSSingleSelectCellModel : TSCellModel

@property (nonatomic, strong) NSString *leftImgName;
@property (nonatomic, strong) NSString *leftText;

@end
