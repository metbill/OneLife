//
//  TSTableCell.h
//  HiTravelService
//
//  Created by hitomedia on 2017/4/18.
//  Copyright © 2017年 hitumedia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSCellParameter : NSObject
@property (nonatomic, weak) id delegate;
@property (nonatomic, assign) NSUInteger type;
@property (nonatomic, assign) UITableViewCellSelectionStyle selectionStyle;
@end

@class TSCellModel;
@interface TSTableCell : UITableViewCell

- (id)initWithReuseId:(NSString*)reuseId parameter:(TSCellParameter*)parameter;

@property (nonatomic, strong) TSCellModel *model;

@end
