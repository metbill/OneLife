//
//  OLAddTargetCtrl.m
//  OneLife
//
//  Created by wkun on 2017/10/24.
//  Copyright © 2017年 wkun. All rights reserved.
//

#import "OLAddTargetCtrl.h"
#import "UIViewController+Ext.h"
#import "KTextView.h"
#import "UILabel+Ext.h"
#import "XWKeyboardToolView.h"
#import "KKeyBoard.h"
#import "KDatePicker.h"
#import "NSDate+Ext.h"
#import "NSString+Ext.h"
#import "OLTargetCtrl.h"

@interface OLAddTargetCtrl ()<KKeyBoardDelegate,XWKeyboardToolViewDelegate,UITextFieldDelegate,KTextViewDelegate>
@property (nonatomic, strong) UITextField *targetNameTf;
@property (nonatomic, strong) UILabel *endTimeMarkL;
@property (nonatomic, strong) UIButton *endTimeBtn;
@property (nonatomic, strong) UILabel *needHourMarkL;
@property (nonatomic, strong) UITextField *needHourTf;
@property (nonatomic, strong) KTextView *textView;
@property (nonatomic, strong) XWKeyboardToolView *toolView;
@property (nonatomic, strong) KKeyBoard *keyBoardManager;
@property (nonatomic, strong) KDatePicker *pickerView;
@property (nonatomic, strong) NSObject *currObject; //正在操作的对象
@end

@implementation OLAddTargetCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configSelf];
    self.navigationItem.title = @"新建目标";
    [self changeBackBarItemWithAction:@selector(handleBack)];
    
    self.textView.hidden = NO;
    self.toolView.hidden = NO;
    _currObject = self.targetNameTf;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.keyBoardManager removeObserver];
    [self.keyBoardManager addObserverKeyBoard];
    
    [self.targetNameTf becomeFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.keyBoardManager removeObserver];
}

#pragma mark - Private

- (UIButton*)getNewBtnWithTitle:(NSString*)title action:(SEL)action frame:(CGRect)fr{
    UIButton *btn = [UIButton new];
    btn.frame = fr;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithRgb51] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    btn.layer.masksToBounds = YES;
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = [UIColor colorWithRgb221].CGColor;
    btn.layer.cornerRadius = 3;
    [self.view addSubview:btn];
    
    return btn;
}

- (NSString*)endTimeBtnTitle{
    return @"选择日期";
}

- (void)updateEndTimeWithDate:(NSDate*)date{
    NSString *dateStr = [NSString stringWithDate:date format:@"yyyy-MM-dd"];
    if( date == nil ) dateStr = [self endTimeBtnTitle];
    [self.endTimeBtn setTitle:dateStr forState:UIControlStateNormal];
}

- (BOOL)validateData{
    if( self.targetNameTf.text.length ==0 ){
        [XWProgressHUD showError:@"骚年,你还没有输入目标名字啊"];
        return NO;
    }
    
    if( [self.endTimeBtn.titleLabel.text isEqualToString:[self endTimeBtnTitle]] ){
        [XWProgressHUD showError:@"客观,没有选择截止日期"];
        return NO;
    }
    
    if( self.needHourTf.text.length ==0 ){
        [XWProgressHUD showError:@"客观,没有输入总时间啊"];
        return NO;
    }
    
    return YES;
}

#pragma mark - TouchEvents
- (void)handleEndTime{
    [self.view endEditing:YES];

    _currObject = self.endTimeBtn;
    if( [self.endTimeBtn.titleLabel.text isEqualToString:[self endTimeBtnTitle]] ){
        [self updateEndTimeWithDate:self.pickerView.minimumDate];
    }
    
    CGRect fr = self.pickerView.frame;
    fr.origin.y = self.toolView.bottom;
    fr.size = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-fr.origin.y);
    self.pickerView.frame = fr;
    self.pickerView.hidden = NO;
}

- (void)handleBack{
    OLTargetCtrl *tc = ((OLTargetCtrl*)[self getCtrlAtNavigationCtrlsWithCtrlClass:[OLTargetCtrl class]]);
    [tc reloadDatas];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - KKeybaordDelegate

/**
 *  键盘将要出现。此时，键盘高度已取到。
 *
 *  @param keyBoard dd
 */
- (void)keyBoardWillShow:(KKeyBoard*)keyBoard keyBoardHeight:(CGFloat)height{
    if( self.pickerView.hidden == NO ){
        self.pickerView.hidden = YES;
    }
    CGRect fr = self.toolView.frame;
    fr.origin.y = (SCREEN_HEIGHT- height-fr.size.height);
    self.toolView.frame = fr;
}

#pragma mark - XWToolViewDelegate
- (void)keyboardToolView:(XWKeyboardToolView *)toolView handleBtnAtIndex:(NSUInteger)index{
    
    if( index == 2 )
    {
        //确定
        if( [self validateData] ){
            BOOL ret =
            [self.dataProcess addTargetWithName:_targetNameTf.text description:_textView.text endDate:_endTimeBtn.titleLabel.text needHours:_needHourTf.text.integerValue];
            if( ret ){
                [XWProgressHUD showMsg:@"亲，成功了^_^"];
                _targetNameTf.text = nil;
                [self updateEndTimeWithDate:nil];
                _needHourTf.text = nil;
                _textView.text = nil;
            }
        }
    }
    else{
        NSArray *objs = @[self.targetNameTf,self.endTimeBtn,self.needHourTf,self.textView];
        if( _currObject && [objs containsObject:_currObject]){
            NSUInteger idx = [objs indexOfObject:_currObject];
            
            NSInteger newIndex = -1;
            if( index ==0 ){
                //上一个
                NSUInteger prevIndex = idx - 1;
                if( idx ==0 ){
                    prevIndex = objs.count-1;
                }
                newIndex = prevIndex;
            }
            else if( index == 1 ){
                //下一个
                NSUInteger nextIndex = idx + 1;
                if( idx + 1 >= objs.count ){
                    nextIndex = 0;
                }
                newIndex = nextIndex;
            }
            
            if( newIndex < 0 && newIndex >=objs.count) return;
            
            NSObject *newObj = objs[newIndex];
            if( [newObj isKindOfClass:[UIButton class]] ){
                [self handleEndTime];
            }else{
                [((UITextField*)newObj) becomeFirstResponder];
            }
        }
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if( [textField isEqual:self.targetNameTf] ) return YES;
    
    if( textField.text.length ==0 && [string isEqualToString:@"0"]){
        return NO;
    }
    
    if( textField.text.length == 6 && ![string isEqualToString:@""] ){
        return NO;
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    _currObject = textField;
}

#pragma mark - KTextViewDelegate

- (void)kTextViewDidBeginEditing:(KTextView *)textView{
    _currObject = textView;
}

#pragma mark - Propertys
- (UITextField *)targetNameTf {
    if( !_targetNameTf ){
        _targetNameTf = [[UITextField alloc] init];
        _targetNameTf.delegate = self;
        _targetNameTf.textColor = [UIColor colorWithRgb16];
        _targetNameTf.font = [UIFont systemFontOfSize:14];
        _targetNameTf.placeholder = @"目标名称";
        _targetNameTf.layer.masksToBounds = YES;
        _targetNameTf.layer.borderColor = [UIColor colorWithRgb221].CGColor;
        _targetNameTf.layer.borderWidth = 1.0;
        _targetNameTf.frame = CGRectMake(0, 20+NAVGATION_VIEW_HEIGHT, SCREEN_WIDTH, 40);
        CGFloat iLeft = VIEW_X_EDGE_DISTANCE;
        UIView *leftView = [UIView new];
        leftView.frame = CGRectMake(0, 0, iLeft, _targetNameTf.height);
        leftView.backgroundColor = [UIColor clearColor];
        _targetNameTf.leftView = leftView;
        UIView *rv = [UIView new];
        rv.frame = CGRectMake(0, 0, iLeft, _targetNameTf.height);
        rv.backgroundColor = [UIColor clearColor];
        _targetNameTf.rightView = rv;
        _targetNameTf.leftViewMode = UITextFieldViewModeAlways;
        _targetNameTf.rightViewMode = UITextFieldViewModeAlways;
        
        [self.view addSubview:_targetNameTf];
    }
    return _targetNameTf;
}

- (UILabel *)endTimeMarkL {
    if( !_endTimeMarkL ){
        CGFloat ileft = VIEW_X_EDGE_DISTANCE;
        CGFloat ih = 30;
        _endTimeMarkL =
        [UILabel getLabelWithTextColor:[UIColor colorWithRgb51]
                                  font:[UIFont systemFontOfSize:14]
                         textAlignment:NSTextAlignmentLeft
                                 frame:CGRectMake(ileft, self.targetNameTf.bottom+10, 80, ih)
                             superView:self.view];
        _endTimeMarkL.text = @"截止时间";
    }
    return _endTimeMarkL;
}

- (UILabel *)needHourMarkL {
    if( !_needHourMarkL ){
        _needHourMarkL =
        [UILabel getLabelWithTextColor:[UIColor colorWithRgb51]
                                  font:[UIFont systemFontOfSize:14]
                         textAlignment:NSTextAlignmentLeft
                                 frame:CGRectMake(self.endTimeMarkL.x, self.endTimeMarkL.bottom+5, _endTimeMarkL.width, _endTimeMarkL.height)
                             superView:self.view];
        _needHourMarkL.text = @"需要小时";
    }
    return _needHourMarkL;
}

- (UIButton *)endTimeBtn {
    if( !_endTimeBtn ){
        CGFloat iw = 90;
        _endTimeBtn =
        [self getNewBtnWithTitle:[self endTimeBtnTitle]
                          action:@selector(handleEndTime)
                           frame:CGRectMake(self.needHourMarkL.right, self.endTimeMarkL.y, iw, self.endTimeMarkL.height)];
    }
    return _endTimeBtn;
}

- (UITextField *)needHourTf {
    if( !_needHourTf ){
        _needHourTf = [UITextField new];
        _needHourTf.delegate = self;
        _needHourTf.placeholder = @"输入小时";
        _needHourTf.textColor = [UIColor colorWithRgb51];
        _needHourTf.font = [UIFont systemFontOfSize:14];
        _needHourTf.textAlignment = NSTextAlignmentCenter;
        _needHourTf.frame =CGRectMake(self.needHourMarkL.right, self.needHourMarkL.y, self.endTimeBtn.width, self.endTimeMarkL.height);
        _needHourTf.layer.masksToBounds = YES;
        _needHourTf.layer.borderWidth = 1;
        _needHourTf.layer.borderColor = [UIColor colorWithRgb221].CGColor;
        _needHourTf.layer.cornerRadius = 3;
        _needHourTf.keyboardType = UIKeyboardTypeNumberPad;
        [self.view addSubview:_needHourTf];
    }
    return _needHourTf;
}

- (KTextView *)textView {
    if( !_textView ){
        _textView = [[KTextView alloc] init];
        CGFloat ix = self.endTimeMarkL.x-5;
        _textView.frame = CGRectMake(ix, 0, SCREEN_WIDTH-2*ix, 100);
        _textView.font = [UIFont systemFontOfSize:14];
        _textView.textColor = [UIColor colorWithRgb16];
        _textView.placeHolder = @"目标详情";
        _textView.del = self;
        
        UIView *bgView = [UIView new];
        bgView.frame = CGRectMake(0, self.needHourTf.bottom+(self.endTimeBtn.y-self.targetNameTf.bottom), SCREEN_WIDTH, _textView.height);
        bgView.backgroundColor = [UIColor clearColor];
        bgView.layer.masksToBounds = YES;
        bgView.layer.borderColor = [UIColor colorWithRgb221].CGColor;
        bgView.layer.borderWidth = 1;
        [bgView addSubview:_textView];
        
        [self.view addSubview:bgView];
    }
    return _textView;
}

- (XWKeyboardToolView *)toolView {
    if( !_toolView ){
        _toolView = [[XWKeyboardToolView alloc] init];
        _toolView.delegate = self;
        CGFloat ih = 44;
        _toolView.frame = CGRectMake(0, SCREEN_HEIGHT-ih, SCREEN_WIDTH, ih);
        _toolView.backgroundColor = [UIColor colorWithRgb248];
        [self.view addSubview:_toolView];
    }
    return _toolView;
}

- (KKeyBoard *)keyBoardManager{
    if( !_keyBoardManager ) {
        _keyBoardManager = [[KKeyBoard alloc] init];
        _keyBoardManager.delegate = self;
    }
    return _keyBoardManager;
}

- (KDatePicker *)pickerView {
    if( !_pickerView ){
        _pickerView = [[KDatePicker alloc] init];
        CGFloat iy = self.toolView.bottom;
        _pickerView.frame = CGRectMake(0, iy, SCREEN_WIDTH, SCREEN_HEIGHT-iy);
        _pickerView.hidden = YES;
        _pickerView.minimumDate = [NSDate dateByAddDays:1 toDate:[NSDate new]];
       
        _pickerView.datePickerMode = UIDatePickerModeDate;
        [self.view addSubview:_pickerView];
        
        __weak typeof(self) weakSelf = self;
        _pickerView.selectDateBlock = ^(NSDate *date) {
            NSLog(@"data=%@",date);
            [weakSelf updateEndTimeWithDate:date];
        };
    }
    return _pickerView;
}

@end
