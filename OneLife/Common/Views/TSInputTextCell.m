//
//  TSInputTextCell.m
//  HiTravelService
//
//  Created by hitomedia on 2017/4/21.
//  Copyright © 2017年 hitumedia. All rights reserved.
//

#import "TSInputTextCell.h"
#import "XWViewFactory.h"
#import "UIColor+Ext.h"
#import "UIView+LayoutMethods.h"

@interface TSInputTextCell()<UITextFieldDelegate>

@property (nonatomic, assign) id<TSInputTextCellDelegate> delegate;


@end

@implementation TSInputTextCell{
    UIView *_line;
    UILabel *_leftViewL;
}

- (instancetype)initWithReuseId:(NSString *)reuseId parameter:(TSCellParameter *)parameter{
    self = [super initWithReuseId:reuseId parameter:parameter];
    if( self ){
        self.delegate = parameter.delegate;
        
        _leftL =
        [XWViewFactory labelWithTextColor:[UIColor colorWithRgb102]
                                     font:[UIFont systemFontOfSize:14]
                                alignment:NSTextAlignmentLeft
                                    frame:CGRectZero
                                superView:self.contentView];
        _rightTf =
        [XWViewFactory textFieldWithTextColor:[UIColor colorWithRgb102]
                                         font:[UIFont systemFontOfSize:14]
                                  placeHolder:nil
                                    alignment:NSTextAlignmentLeft
                                        frame:CGRectZero
                                    superView:self.contentView];
        [_rightTf setValue:[UIColor colorWithRgb221]
                forKeyPath:@"_placeholderLabel.textColor"];
        _rightTf.delegate = self;
        _rightTf.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        _leftViewL = [UILabel new];
        _leftViewL.frame = CGRectMake(0, 0, 15, 30);
        _leftViewL.textColor = _rightTf.textColor;
        _leftViewL.font = [UIFont systemFontOfSize:14];
        _rightTf.leftView = _leftViewL;
        
        _line = [UIView new];
        _line.backgroundColor = [UIColor colorWithRgb221];
        [self.contentView addSubview:_line];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat lineH = 0.5;
    _line.frame = CGRectMake(0, self.height-lineH, SCREEN_WIDTH, lineH);
    _leftL.frame = CGRectMake(20, 0, 125, self.height);
    CGFloat ix = _leftL.right+10;
    CGFloat iw = self.width-ix-_leftL.x;
    _rightTf.frame = CGRectMake(ix, 0, iw, _leftL.height);
}

- (void)setModel:(TSCellModel *)model{
    [super setModel:model];
    TSInputTextCellModel *cm = (TSInputTextCellModel*)model;
    if( [cm isKindOfClass:[TSInputTextCellModel class]] ){
        _leftL.text = cm.leftText;
        _rightTf.text = cm.rightText;
        _rightTf.placeholder = cm.placeHolder;
        _rightTf.secureTextEntry = cm.secretyInput;
        _rightTf.keyboardType = cm.keyboardType;
        if( cm.rightTextColor){
            _rightTf.textColor = cm.rightTextColor;
        }else{
            _rightTf.textColor = [UIColor colorWithRgb102];
        }
        if( cm.leftViewText ){
            _rightTf.leftViewMode = UITextFieldViewModeAlways;
            _leftViewL.text = cm.leftViewText;
            _leftViewL.textColor = _rightTf.textColor;
        }else{
            _rightTf.leftViewMode = UITextFieldViewModeNever;
        }
        _rightTf.userInteractionEnabled = cm.textFieldEditEnable;
        self.selectionStyle = cm.textFieldEditEnable ? UITableViewCellSelectionStyleNone :UITableViewCellSelectionStyleDefault;
        self.userInteractionEnabled = cm.userInteractionEnabled;
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    TSInputTextCellModel *cm = (TSInputTextCellModel*)self.model;
    if( [cm isKindOfClass:[TSInputTextCellModel class]] ){
        cm.rightText = textField.text;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if( self.delegate && [self.delegate respondsToSelector:@selector(inputTextCell:textField:shouldChangeCharactersInRange:replacementString:)] ){
        return [_delegate inputTextCell:self textField:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    
    return YES;
}

@end

@implementation TSInputTextCellModel

- (instancetype)init{
    self = [super init];
    if( self ){
        self.textFieldEditEnable = YES;
        self.userInteractionEnabled = YES;
        self.secretyInput = NO;
    }
    return self;
}

@end
