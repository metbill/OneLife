//
//  TSInputTextCell.h
//  HiTravelService
//
//  Created by hitomedia on 2017/4/21.
//  Copyright © 2017年 hitumedia. All rights reserved.
//

#import "TSTableCell.h"
#import "TSShowTextCell.h"

@class TSInputTextCellModel;
/**
 文本输入Cell
 */
@interface TSInputTextCell : TSTableCell
//views
@property (nonatomic, strong) UILabel *leftL;
@property (nonatomic, strong) UITextField *rightTf;

@end

@interface TSInputTextCellModel : TSShowTextCellModel

@property (nonatomic, strong) NSString *placeHolder;

/**
 是否可以输入，默认YES
 */
@property (nonatomic, assign) BOOL textFieldEditEnable;

/**
 是否展示右侧箭头。默认NO
 */
@property (nonatomic, assign) BOOL showArrowView;

/**
 cell 是否可以交互,默认为NO
 */
@property (nonatomic, assign) BOOL userInteractionEnabled;

/**
 加密输入，默认为NO
 */
@property (nonatomic, assign) BOOL secretyInput;


@property (nonatomic, assign) UIKeyboardType keyboardType;

@property (nonatomic, strong) NSString *leftViewText;
@end

@protocol TSInputTextCellDelegate <NSObject>

@optional
- (BOOL)inputTextCell:(TSInputTextCell*)cell textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

@end

