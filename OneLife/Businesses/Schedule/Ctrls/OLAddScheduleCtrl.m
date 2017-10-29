//
//  OLAddScheduleCtrl.m
//  OneLife
//
//  Created by wkun on 2017/10/23.
//  Copyright © 2017年 wkun. All rights reserved.
//

#import "OLAddScheduleCtrl.h"
#import "UIViewController+Ext.h"
#import "XWKeyboardToolView.h"
#import "KKeyBoard.h"
#import "UILabel+Ext.h"
#import "NSString+Ext.h"
#import "KDatePicker.h"
#import "JLBtnListView.h"

@interface OLAddScheduleCtrl ()<UITextFieldDelegate,XWKeyboardToolViewDelegate,KKeyBoardDelegate,JLBtnListViewDelegate>
@property (nonatomic, strong) UITextField *scheduleTf;
@property (nonatomic, strong) XWKeyboardToolView *toolView;
@property (nonatomic, strong) KKeyBoard *keyboardManager;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *dateL;
@property (nonatomic, strong) UILabel *alarmL;
@property (nonatomic, strong) KDatePicker *pickerView;
@property (nonatomic, strong) JLBtnListView *dateView;
@end

@implementation OLAddScheduleCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configSelf];
    self.navigationItem.title = @"新建日程";
//    [self addBgGesture];
    [self.toolView reloadData];
    self.dateL.text = [NSString stringWithDate:_date format:@"MM月dd日"];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    
    [self.keyboardManager removeObserver];
    [self.keyboardManager addObserverKeyBoard];
    [self.scheduleTf becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.keyboardManager removeObserver];
}

#pragma mark - Private
//- (void)addBgGesture{
//    UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleBg)];
//    self.view.userInteractionEnabled = YES;
//    [self.view addGestureRecognizer:gr];
//}
//

- (void)updateAlarmWithDate:(NSDate*)date{
    if( date == nil ){
        self.alarmL.text = nil;
        self.alarmL.hidden = YES;
        return;
    }
    
    NSString *dateStr = [NSString stringWithDate:date format:@"HH:mm"];
    self.alarmL.text = dateStr;
    if( _alarmL.isHidden ){
        _alarmL.hidden = NO;
    }
}
#pragma mark - TouchEvents
- (void)handleCancleAlarmBtn{
    [self updateAlarmWithDate:nil];
    [self.scheduleTf becomeFirstResponder];
}

#pragma mark - ToolViewDelegate

- (void)keyboardToolView:(XWKeyboardToolView *)toolView handleBtnAtIndex:(NSUInteger)index{
    self.dateView.hidden = YES;
    self.pickerView.hidden = YES;
    if( index==0){
        //日历
        [self.scheduleTf resignFirstResponder];

        self.dateView.hidden = NO;
        if( self.dateView.currSelectedSingleBtnIndex == -1){
            [self.dateView selectBtnAtIndex:0];
        }
        
    }else if( index == 1 ){
        //闹钟
        [self.scheduleTf resignFirstResponder];
        CGRect fr = self.pickerView.frame;
        fr.origin.y = self.bottomView.bottom;
        fr.size = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-fr.origin.y);
        self.pickerView.frame = fr;
        self.pickerView.hidden = NO;
    }
    else if (index==2){
        //创建
//        [self.dateView selectBtnAtIndex:0];
    }
}

- (NSString *)keyboardToolViewItemNormalImageNameAtIndex:(NSUInteger)index{
    NSArray *tis = @[@"calendar",@"clock"];
    if( tis.count > index ){
        return tis[index];
    }
    return nil;
}

#pragma mark - KKeybaordDelegate

/**
 *  键盘将要出现。此时，键盘高度已取到。
 *
 *  @param keyBoard dd
 */
- (void)keyBoardWillShow:(KKeyBoard*)keyBoard keyBoardHeight:(CGFloat)height{
    
    CGRect fr = self.bottomView.frame;
    fr.origin.y = (SCREEN_HEIGHT- height-fr.size.height);
    self.bottomView.frame = fr;
}

#pragma mark - JLBtnListViewDelegate
- (NSArray<NSString *> *)btnListViewTitles:(JLBtnListView *)btnList{
    return @[@"今天",@"明天",@"后天",@"下周",@"下月",@"其他"];
}

- (NSInteger)btnListViewColumnCount:(JLBtnListView *)btnList{
    return 3;
}

- (CGFloat)btnListViewBtnHeight:(JLBtnListView *)btnList{
    return btnList.height/2;//-[self btnListViewBtnYGap:btnList]/2;
}

- (CGFloat)btnListViewBtnYGap:(JLBtnListView *)btnList{
    return btnList.x;
}

- (UIFont *)btnListViewBtnTitleFont:(JLBtnListView *)btnList{
    return [UIFont systemFontOfSize:24];
}

- (UIColor*)btnListViewBtnSelectedTitleColor:(JLBtnListView *)btnList{
    return [UIColor whiteColor];
}

- (UIColor*)btnListViewBtnTitleColor:(JLBtnListView *)btnList{
    return [UIColor colorWithRgb_24_148_209];
}

- (UIColor*)btnListViewBtnSelectedBgColor:(JLBtnListView *)btnList{
    return [UIColor colorWithRgb_24_148_209];
}

- (void)btnListView:(JLBtnListView *)btnList didSelectedBtnAtIndex:(NSUInteger)index{
    NSLog(@"btnlist");
}

#pragma mark - Propertys 

- (UITextField *)scheduleTf{
    if( !_scheduleTf ){
        UITextField *
        _recordContentTf = [UITextField new];
        _recordContentTf.frame = CGRectMake(0, NAVGATION_VIEW_HEIGHT+20, SCREEN_WIDTH, 44);
        _recordContentTf.placeholder = @"日程内容";
        _recordContentTf.delegate = self;
        _recordContentTf.textColor = [UIColor colorWithRgb51];
        _recordContentTf.font = [UIFont systemFontOfSize:14];
        _recordContentTf.layer.masksToBounds = YES;
        _recordContentTf.layer.borderColor = [UIColor colorWithRgb221].CGColor;
        _recordContentTf.layer.borderWidth = 1;
        _recordContentTf.returnKeyType = UIReturnKeyDone;
        CGFloat iLeft = VIEW_X_EDGE_DISTANCE;
        UIView *leftView = [UIView new];
        leftView.frame = CGRectMake(0, 0, iLeft, _recordContentTf.height);
        leftView.backgroundColor = [UIColor clearColor];
        _recordContentTf.leftView = leftView;
        UIView *rv = [UIView new];
        rv.frame = CGRectMake(0, 0, iLeft, _recordContentTf.height);
        rv.backgroundColor = [UIColor clearColor];
        _recordContentTf.rightView = rv;
        _recordContentTf.leftViewMode = UITextFieldViewModeAlways;
        _recordContentTf.rightViewMode = UITextFieldViewModeAlways;
        [self.view addSubview:_recordContentTf];
        
        _scheduleTf = _recordContentTf;
    }
    return _scheduleTf;
}

- (XWKeyboardToolView *)toolView {
    if( !_toolView ){
        _toolView = [[XWKeyboardToolView alloc] init];
        _toolView.backgroundColor = [UIColor colorWithRgb248];
        _toolView.delegate = self;
        CGFloat ih = 44;
        CGFloat iy =ih;
        _toolView.frame = CGRectMake(0, iy, SCREEN_WIDTH, ih);
        [self.bottomView addSubview:_toolView];
    }
    return _toolView;
}

- (KKeyBoard*)keyboardManager{
    if( !_keyboardManager ){
        _keyboardManager = [[KKeyBoard alloc] init];
        _keyboardManager.delegate = self;
    }
    return _keyboardManager;
}

- (UIView*)bottomView{
    if( !_bottomView ){
        _bottomView = [UIView new];
        CGFloat ih = 44*2;
        
        _bottomView.frame = CGRectMake(0, SCREEN_HEIGHT-ih, SCREEN_WIDTH, ih);
        _bottomView.backgroundColor = [UIColor colorWithR:237 G:250 B:255];
        [self.view addSubview:_bottomView];
    }
    return _bottomView;
}

- (UILabel *)dateL{
    if( !_dateL ){
        CGFloat ix = VIEW_X_EDGE_DISTANCE;
        CGFloat ih = 20;
        _dateL =
        [UILabel getLabelWithTextColor:[UIColor colorWithR:64 G:158 B:245] font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentCenter frame:CGRectMake(ix, (self.toolView.height-ih)/2, 80, ih) superView:self.bottomView];
        _dateL.backgroundColor = [UIColor colorWithR:183 G:220 B:247];// [UIColor colorWithR:184 G:229 B:255];
    }
    return _dateL;
}

- (UILabel *)alarmL{
    if( !_alarmL ){
        CGFloat ih = 20;
        _alarmL =
        [UILabel getLabelWithTextColor:self.dateL.textColor font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentCenter frame:CGRectMake(self.dateL.right+20, (self.toolView.height-ih)/2, 50, ih) superView:self.bottomView];
        _alarmL.backgroundColor = self.dateL.backgroundColor;//[UIColor colorWithR:184 G:229 B:255];
        _alarmL.hidden = YES;
    }
    return _alarmL;
}

- (KDatePicker *)pickerView {
    if( !_pickerView ){
        _pickerView = [[KDatePicker alloc] init];
        CGFloat iy = self.toolView.bottom;
        _pickerView.frame = CGRectMake(0, iy, SCREEN_WIDTH, SCREEN_HEIGHT-iy);
        _pickerView.hidden = YES;
//        _pickerView.minimumDate = [NSDate dateByAddDays:1 toDate:[NSDate new]];
        _pickerView.datePickerMode = UIDatePickerModeTime;
        [self.view addSubview:_pickerView];
        
        CGFloat ix = VIEW_X_EDGE_DISTANCE;
        UIButton *cancleBtn = [UIButton new];
        cancleBtn.frame = CGRectMake(ix, 5, 70, 30);
        [cancleBtn setTitleColor:[UIColor colorWithRgb_24_148_209] forState:UIControlStateNormal];
        [cancleBtn setTitle:@"取消闹钟" forState:UIControlStateNormal];
        cancleBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [cancleBtn addTarget:self action:@selector(handleCancleAlarmBtn) forControlEvents:UIControlEventTouchUpInside];
        [_pickerView addSubview:cancleBtn];
        
        __weak typeof(self) weakSelf = self;
        _pickerView.selectDateBlock = ^(NSDate *date) {
            NSLog(@"data=%@",date);
            [weakSelf updateAlarmWithDate:date];
        };
    }
    return _pickerView;
}

- (JLBtnListView *)dateView{
    if( !_dateView ){
       
        CGFloat ix = VIEW_X_EDGE_DISTANCE;
         CGFloat iy = self.bottomView.bottom+ix;
        _dateView = [[JLBtnListView alloc] initWithFrame:CGRectMake(ix, iy, SCREEN_WIDTH-2*ix, SCREEN_HEIGHT-iy-2*ix)];
        _dateView.delegate = self;
        _dateView.hidden = YES;
        _dateView.backgroundColor = [UIColor clearColor];
        
        [self.view addSubview:_dateView];
        
        [_dateView reloadData];
    }
    return _dateView;
}

@end
