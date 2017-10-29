//
//  OLAddRecordCtrl.m
//  OneLife
//
//  Created by wkun on 2017/10/23.
//  Copyright © 2017年 wkun. All rights reserved.
//

#import "OLAddRecordCtrl.h"
#import "UIViewController+Ext.h"
#import "OLSelectTargetView.h"
#import "XWKeyboardToolView.h"
#import "UILabel+Ext.h"
#import "OLTargetModel.h"
#import "KKeyBoard.h"
#import "NSString+Ext.h"
#import "OLRecordTimeModel.h"
#import "OLRecordTimeDataModel.h"
#import "OLScheduleCtrl.h"
#import "NSDate+Ext.h"

static NSUInteger const gTagBase = 100;
@interface OLAddRecordCtrl ()<UITextFieldDelegate,KKeyBoardDelegate,XWKeyboardToolViewDelegate>

@property (nonatomic, strong) UIButton *startDateBtn;
@property (nonatomic, strong) UIButton *endDateBtn;
@property (nonatomic, strong) UITextField *startHourTf;
@property (nonatomic, strong) UITextField *startMinTf;
@property (nonatomic, strong) UITextField *endHourTf;
@property (nonatomic, strong) UITextField *endMinTf;
@property (nonatomic, strong) UILabel *timeIntevalL;
@property (nonatomic, strong) UIView *seperateView;
@property (nonatomic, strong) UITextField *recordContentTf;
@property (nonatomic, strong) OLSelectTargetView *targetView;
@property (nonatomic, strong) XWKeyboardToolView *toolView;
@property (nonatomic, strong) KKeyBoard *keyBoardManager;
@property (nonatomic, strong) UITextField *currObject;
@property (nonatomic, assign) NSInteger selectTargetIndex; //选中的类型的索引，默认为-1 ，未选中
@property (nonatomic, strong) OLRecordTimeModel *lastRecordTimeModel;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@end

@implementation OLAddRecordCtrl

#pragma mark - ♻️life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configSelf];
    self.navigationItem.title=
    [NSString stringWithFormat:@"新建记录(%@)",
     [NSString stringWithDate:_date format:@"MM/dd"]];
    [self addRightBarItemWithTitle:@"创建" imgName:nil selImgName:nil
                            action:@selector(handleCaldenlerBtn)
                        titleColor:[UIColor colorWithRgb_24_148_209]
                         titleFont:[UIFont systemFontOfSize:16]];
    [self changeBackBarItemWithAction:@selector(handleBack)];

    _startDate = _date;
    _endDate = _date;
    
    [self initViews];
    _selectTargetIndex = -1;
    [self getLastTimeRecord];
    [self updateStartAndEndTimeTextWithlastRecordTimeModel:_lastRecordTimeModel];
    [self updateTimeIntervalText];
    [self loadTargetDatas];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.keyBoardManager removeObserver];
    [self.keyBoardManager addObserverKeyBoard];
    
    [self.startHourTf becomeFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.keyBoardManager removeObserver];
}

#pragma mark - 🔓private
- (void)initViews{
    //    CGFloat iw = 30;
    CGFloat ih = 35;
    CGFloat iy = NAVGATION_VIEW_HEIGHT+20;
    CGFloat timeW = 38;
    CGFloat symlW = 12;
    CGFloat lineW = 80;
    CGFloat btnW = 40;
    CGFloat ix = (SCREEN_WIDTH-timeW*4-symlW*2-lineW-btnW*2)/2;
    if( ix < 0 ){
        ix =0;
        btnW = (SCREEN_WIDTH-timeW*4-symlW*2-lineW)/2;
    }
    
    _startDateBtn =
    [self getNewBtnWithTitle:@"今天"
                      action:@selector(handleStartDateBtn)
                       frame:CGRectMake(ix, iy, btnW, ih)];
    _endDateBtn =
    [self getNewBtnWithTitle:@"今天"
                      action:@selector(handleEndDateBtn)
                       frame:CGRectMake(SCREEN_WIDTH-btnW-ix, iy, btnW, ih)];
    
    _startHourTf = [self getTextFieldWithFrame:CGRectMake(_startDateBtn.right, iy, timeW, ih)];
    UILabel *symbolL = [self getNewSymbolLWithFr:CGRectMake(_startHourTf.right, iy-2, symlW, ih)];
    symbolL.text = @":";
    _startMinTf = [self getTextFieldWithFrame:CGRectMake(symbolL.right, iy, timeW, ih)];
    
    UIView *line = [UIView new];
    CGFloat lineXgap = 3;
    line.frame = CGRectMake(_startMinTf.right+lineXgap, _startMinTf.y+(_startMinTf.height/2), lineW-2*lineXgap, 1);
    line.backgroundColor = [UIColor colorWithRgb102];
    [self.view addSubview:line];
    
    _endHourTf = [self getTextFieldWithFrame:CGRectMake(line.right+lineXgap, iy, timeW, ih)];
    UILabel *symbolL1 = [self getNewSymbolLWithFr:CGRectMake(_endHourTf.right, symbolL.y, symlW, ih)];
    symbolL1.text = @":";
    _endMinTf = [self getTextFieldWithFrame:CGRectMake(symbolL1.right, iy, timeW, ih)];

    CGFloat tiH = 15;
    _timeIntevalL = [UILabel getLabelWithTextColor:[UIColor colorWithRgb102] font:[UIFont systemFontOfSize:12] textAlignment:NSTextAlignmentCenter frame:CGRectMake(line.x, line.y-tiH, line.width, tiH) superView:self.view];
    
    _recordContentTf = [UITextField new];
    _recordContentTf.frame = CGRectMake(0, _endMinTf.bottom+20, SCREEN_WIDTH, 44);
    _recordContentTf.placeholder = @"记录内容";
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
    
    _toolView = [[XWKeyboardToolView alloc] init];
    _toolView.backgroundColor = [UIColor colorWithRgb248];
    _toolView.delegate = self;
    ih = 44;
    _toolView.frame = CGRectMake(0, SCREEN_HEIGHT-ih, SCREEN_WIDTH, ih);
    [self.view addSubview:_toolView];
    
    _targetView = [OLSelectTargetView new];
    
    iy = _recordContentTf.bottom+40;
    ih = _toolView.y - iy;
    _targetView.frame = CGRectMake(0, iy, SCREEN_WIDTH, ih);
    _targetView.layer.masksToBounds = YES;
    _targetView.layer.borderWidth = 1;
    _targetView.layer.borderColor = [UIColor colorWithRgb221].CGColor;
    _targetView.backgroundColor = [UIColor clearColor];
    _targetView.handleItemBlock = ^(NSUInteger index) {
        _selectTargetIndex = index;
    };
    [self.view addSubview:_targetView];
    
    ix = VIEW_X_EDGE_DISTANCE;
    ih = 18;
    UILabel *selectTypeMarkL = [UILabel getLabelWithTextColor:[UIColor colorWithRgb51] font:[UIFont systemFontOfSize:12] textAlignment:NSTextAlignmentLeft frame:CGRectMake(ix, _targetView.y-ih, 100, ih) superView:self.view];
    selectTypeMarkL.text = @"选择类型";
    
    _startHourTf.tag = gTagBase + 1;
    _startMinTf.tag = gTagBase + 2;
    _endHourTf.tag = gTagBase +3;
    _endMinTf.tag = gTagBase + 4;
    _recordContentTf.tag = gTagBase + 5;
    
    _keyBoardManager = [[KKeyBoard alloc] init];
    _keyBoardManager.delegate = self;
    
    [self.view bringSubviewToFront:_toolView];
}

- (UILabel*)getNewSymbolLWithFr:(CGRect)fr{
    return [UILabel getLabelWithTextColor:[UIColor colorWithRgb51] font:[UIFont systemFontOfSize:28] textAlignment:NSTextAlignmentCenter frame:fr superView:self.view];
}

- (UITextField*)getTextFieldWithFrame:(CGRect)fr{
    UITextField *tf = [UITextField new];
    tf.delegate = self;
    tf.frame = fr;
    tf.textColor = [UIColor colorWithRgb51];
    tf.font = [UIFont systemFontOfSize:28];
    tf.keyboardType = UIKeyboardTypeNumberPad;
    tf.textAlignment = NSTextAlignmentCenter;
    tf.tintColor = [UIColor clearColor];//光标不可见
    [tf cornerRadius:3];
    
    [self.view addSubview:tf];
    return tf;
}

- (UIButton*)getNewBtnWithTitle:(NSString*)title action:(SEL)action frame:(CGRect)fr{
    UIButton *btn = [UIButton new];
    btn.frame = fr;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithRgb_24_148_209] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    //    btn.layer.masksToBounds = YES;
    //    btn.layer.borderWidth = 1;
    //    btn.layer.borderColor = [UIColor colorWithRgb221].CGColor;
    //    btn.layer.cornerRadius = 3;
    [self.view addSubview:btn];
    
    return btn;
}

- (void)updateTimeIntervalText{
    NSInteger hour =0;// _endHourTf.text.integerValue-_startHourTf.text.integerValue;
    NSInteger min =0;// _endMinTf.text.integerValue-_startMinTf.text.integerValue;
//    if( hour > 0 && min < 0 ){
//        hour = hour-1;
//        min = 60+min;
//    }
    NSDate *st = [self getDateWithDate:_startDate hourText:_startHourTf.text minutesText:_startMinTf.text];
    NSDate *et = [self getDateWithDate:_endDate hourText:_endHourTf.text minutesText:_endMinTf.text];
    NSTimeInterval ti = [et timeIntervalSinceDate:st];
    min = ((NSInteger)(ti/60.0))%60;
    hour = ((NSInteger)ti)/60/60;
    
    _timeIntevalL.text = [NSString stringWithFormat:@"%ld时%ld分",(long)hour,(long)min];
}

- (NSDate*)getDateWithDate:(NSDate*)date hourText:(NSString*)hourText minutesText:(NSString*)minuteText{
    NSString *dateText = [NSString stringWithDate:date format:@"yyyy-MM-dd"];
    NSString *dateTimeText = [NSString stringWithFormat:@"%@ %@:%@",dateText,hourText,minuteText];
    return [NSDate dateWithString:dateTimeText format:@"yyyy-MM-dd HH:mm"];
}

- (void)loadTargetDatas{
    NSMutableArray *arr = [NSMutableArray new];
    NSArray *titles = @[@"固定",@"浪费",@"睡眠"];
    NSArray *types = @[@(OLTimeTypeRoutine),@(OLTimeTypeWaste),@(OLTimeTypeSleep)];
    for( NSUInteger i=0; i<3; i++ ){
        OLTargetModel *tm = [OLTargetModel new];

        if( i < 3 ){
            tm.name = titles[i];//@"没啥事，闲着";
            tm.timeType = ((NSNumber*)(types[i])).intValue;
        }
        [arr addObject:tm];
    }
    
    NSArray *targetDatas = [self.dataProcess targetListWithType];
    if( targetDatas.count ){
        [arr addObjectsFromArray:targetDatas];
    }else{
        OLTargetModel *investTm = [OLTargetModel new];
        investTm.name = @"投资";
        investTm.timeType = OLTimeTypeInvestment;
        [arr addObject:investTm];
    }
    _targetView.datas = arr;
}

- (BOOL)validateData{
    NSInteger hour = _endHourTf.text.integerValue-_startHourTf.text.integerValue;
    NSInteger min = _endMinTf.text.integerValue-_startMinTf.text.integerValue;
    if( hour > 0 && min < 0 ){
        hour = hour-1;
        min = 60+min;
    }
    
    
    if( ((hour < 0 || min<0  || (hour==0&&min==0))  && [_startDate compare:_endDate] == NSOrderedSame ) || [_startDate compare:_endDate] == NSOrderedDescending) {
        [XWProgressHUD showError:@"开始时间应早于截止时间"];
        return NO;
    }
    
    if( _recordContentTf.text.length ==0 ){
        [XWProgressHUD showError:@"骚年,你还没有记录内容啊"];
        return NO;
    }
    
    if( _selectTargetIndex < 0 ){
        [XWProgressHUD showError:@"客观,没有选择类型呀"];
        return NO;
    }
    
    return YES;
}

- (void)getHour:(NSUInteger*)hours minutes:(NSUInteger*)minutes fromDate:(NSDate*)date{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute;
    
    NSDateComponents *comps  = [calendar components:unitFlags fromDate:date];
    
    //    int year = [comps year];
    //    int month = [comps month];
    //    int day = [comps day];
    //    int hour = [comps hour];
    NSUInteger min = [comps minute];
    NSUInteger hour = [comps hour];
    
    *minutes = min;
    *hours = hour;
}

//- (void)initTimeDatas{
//    NSUInteger endours = 0;
//    NSUInteger endMinutes = 0;
//    [self getHour:&endours minutes:&endMinutes fromDate:[NSDate new]];
//    
//    _startHourTf.text = @"00";
//    _startMinTf.text = @"00";
//    _endHourTf.text = [NSString stringWithFormat:@"%02ld",endours];
//    _endMinTf.text =  [NSString stringWithFormat:@"%02ld",endMinutes];;
//}

- (NSString*)getTimeWithHours:(NSString*)hour mins:(NSString*)min date:(NSDate*)date{
    NSString *hm = [NSString stringWithFormat:@"%@:%@",hour,min];
    NSString *dateStr = [NSString stringWithDate:date format:@"yyyy-MM-dd"];
    return [NSString stringWithFormat:@"%@ %@",dateStr,hm];
}

- (void)addTimeRecord{
    
    OLTargetModel *tm = nil;
    if( _selectTargetIndex < self.targetView.datas.count ){
        tm = _targetView.datas[_selectTargetIndex];
    }
    NSString *startTimeStr = [self getTimeWithHours:_startHourTf.text mins:_startMinTf.text date:_startDate];
    NSString *endTimeStr = [self getTimeWithHours:_endHourTf.text mins:_endMinTf.text date:_endDate];
    
    if( [_startDate compare:_date] == NSOrderedAscending && [_endDate compare:_date]==NSOrderedSame ){
        //记录跨越了两天。即从昨天开始，到今天结束. 则该记录插入两次，每天都插入一次
        [self.dataProcess addRecordWithStartTime:startTimeStr endTime:endTimeStr content:_recordContentTf.text type:tm.timeType targetId:tm.dm.ID targetName:tm.name date:_startDate];
    }
    
    BOOL ret =
    [self.dataProcess addRecordWithStartTime:startTimeStr endTime:endTimeStr content:_recordContentTf.text type:tm.timeType targetId:tm.dm.ID targetName:tm.name date:_date];
    if( ret ){
        [XWProgressHUD showMsg:@"成功啦"];
        
        [self getLastTimeRecord];
        [self updateStartAndEndTimeTextWithlastRecordTimeModel:_lastRecordTimeModel];
        [self loadTargetDatas];
        _selectTargetIndex = -1;
        _recordContentTf.text = nil;
        
    }else{
        [XWProgressHUD showError:@"失败啦"];
    }
}

- (void)getLastTimeRecord{
    _lastRecordTimeModel =
    [self.dataProcess lastRecordWithDate:_date];
}

- (void)updateStartAndEndTimeTextWithlastRecordTimeModel:(OLRecordTimeModel*)tm{
    NSString *hourText = @"00";
    NSString *minText = @"00";
    if( tm.dm.endTime ){
        NSArray *timeArr = [tm.dm.endTime componentsSeparatedByString:@" "];
        if( timeArr.count == 2 ){
            NSString *hourAndMinStr = timeArr[1];
            
            NSArray *timeArr = [hourAndMinStr componentsSeparatedByString:@":"];
            if( timeArr.count == 2 ){
                hourText = timeArr[0];
                minText = timeArr[1];
            }

        }
    }
    _startHourTf.text = hourText;
    _startMinTf.text = minText;
    
    NSUInteger hour=0;
    NSUInteger min =0;
    [self getHour:&hour minutes:&min fromDate:[NSDate new]];
    _endHourTf.text = [NSString stringWithFormat:@"%02ld",hour];
    _endMinTf.text = [NSString stringWithFormat:@"%02ld",min];
}

- (void)updateDateBtnTitleWithDate:(NSDate*)date isStartBtn:(BOOL)isStart{
    NSDate *targetDate = _date;
    UIButton *targetBtn = _endDateBtn;
    if( isStart ){
//        targetDate = _startDate;
        targetBtn = _startDateBtn;
    }
    
    NSTimeInterval ti = [date timeIntervalSinceDate:targetDate];
    ti = ti>0?ti:-ti;
    
    NSString *title = @"昨天";
    //相差小于24小时，则为今天
    if( ti/60.0/60 < 24 ){
        title = @"今天";
    }
    [targetBtn setTitle:title forState:UIControlStateNormal];
}

#pragma mark - 🚪public
#pragma mark - 🍐delegate

#pragma mark - XWToolViewDelegate
- (void)keyboardToolView:(XWKeyboardToolView *)toolView handleBtnAtIndex:(NSUInteger)index{
    
    if( index == 2 )
    {
        [self handleCaldenlerBtn];
    }
    else{
        
        NSArray *objs = @[_startHourTf,_startMinTf,_endHourTf,_endMinTf,_recordContentTf];
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
            //            if( [newObj isKindOfClass:[UIButton class]] ){
            ////                [self handleEndTime];
            //            }else{
            [((UITextField*)newObj) becomeFirstResponder];
            //            }
        }
    }
}


#pragma mark TextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if( [textField isEqual:_recordContentTf] ) return YES;
    
    if( [string isEqualToString:@""] ){
        //删除
        NSString *text = textField.text;
        if( text.integerValue > 10 ){
            //两位数，把高位变零，低位赋值高位的数字
            NSString *highText = [text substringToIndex:1];
            NSString *newText = [NSString stringWithFormat:@"0%@",highText];
            textField.text = newText;
        }else if( text.integerValue >0 && text.integerValue < 10 ){
            //个位数，直接变0
            textField.text = @"00";
        }
        else if( text.integerValue==0 ){
            //已经为0，直接去删除上一个
            if( [textField isEqual:_startHourTf] ){
                [_endMinTf becomeFirstResponder];
            }else{
                UITextField *prevTf = [self.view viewWithTag:textField.tag-1];
                if( [prevTf isKindOfClass:[UITextField class]] ){
                    [prevTf becomeFirstResponder];
                }
            }
        }
        [self updateTimeIntervalText];
        return NO;
    }
    
    if( textField.text.length <= 2 ){
        NSUInteger max = 0;
        if( [textField isEqual:_startHourTf] || [textField isEqual:_endHourTf ]){
            max = 2; //小时的十分位 最大为2
        }else{
            max = 5; //分钟的十分位 最大值为5
        }
        
        NSString *text = textField.text;
        //如果是第一次开始输入该文本，则之前的textfiled的text忽略重置为0
        if( textField.rightViewMode == UITextFieldViewModeAlways ){
            text = @"00";
            textField.rightViewMode = UITextFieldViewModeNever;
        }
        if( text.integerValue ==0 || text.integerValue > 10){
            //text为0 或者为两位数时
            
            textField.text = [NSString stringWithFormat:@"0%@",string];
            if( string.integerValue > max ){
                //此时跳转至下一个textfield继续输入
                
                if( [textField isEqual:_endMinTf] ){
                    [_startHourTf becomeFirstResponder];
                }else{
                    UITextField *nextTf = [self.view viewWithTag:textField.tag+1];
                    if( [nextTf isKindOfClass:[UITextField class]] ){
                        [nextTf becomeFirstResponder];
                    }
                }
            }
        }
        else if( text.integerValue >0 && text.integerValue < 10 ){
            //text是个位数时，则把个位数转移到高位，把新的值放在低位，同时跳转至下一个textfield输入
            
            //如果输入的文本是小时，则输入数的值若大于3则返回NO,保证小时不可超过23
            if( [textField isEqual:_startHourTf] || [textField isEqual:_endHourTf] ){
                if( string.integerValue > 3 && text.integerValue ==2 ) return NO;
            }
            
            if( text.integerValue <= max ){
                NSString *lowText = [text substringFromIndex:1];
                NSString *newText = [NSString stringWithFormat:@"%@%@",lowText,string];
                textField.text = newText;
            }
            if( [textField isEqual:_endMinTf] ){
                [_startHourTf becomeFirstResponder];
            }else{
                UITextField *nextTf = [self.view viewWithTag:textField.tag+1];
                if( [nextTf isKindOfClass:[UITextField class]] ){
                    [nextTf becomeFirstResponder];
                }
            }
        }
        
        [self updateTimeIntervalText];
    }
    
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    _currObject = textField;
    
    NSArray *tfs = @[_startHourTf,_startMinTf,_endHourTf,_endMinTf];
    for( UITextField *tf in tfs ){
        if( [tf isEqual:_currObject] ){
            tf.backgroundColor = [UIColor colorWithRgb_229_28_35];
            tf.textColor = [UIColor whiteColor];
            tf.rightViewMode = UITextFieldViewModeAlways;// 设置其为第一次输入
        }else{
            tf.backgroundColor = [UIColor clearColor];
            tf.textColor = [UIColor colorWithRgb51];
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if( [textField isEqual:_recordContentTf] ==NO ){
        textField.backgroundColor = [UIColor clearColor];
        textField.textColor = [UIColor colorWithRgb51];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - KKeybaordDelegate

/**
 *  键盘将要出现。此时，键盘高度已取到。
 *
 *  @param keyBoard dd
 */
- (void)keyBoardWillShow:(KKeyBoard*)keyBoard keyBoardHeight:(CGFloat)height{
    
    CGRect fr = self.toolView.frame;
    fr.origin.y = (SCREEN_HEIGHT- height-fr.size.height);
    self.toolView.frame = fr;
}

- (void)keyBoardWillHide:(KKeyBoard *)keyBoard keyBoardHeight:(CGFloat)height{
    CGRect fr = self.toolView.frame;
    fr.origin.y = (SCREEN_HEIGHT-fr.size.height);
    self.toolView.frame = fr;
}

#pragma mark - ☎️notification

#pragma mark - 🎬event response
- (void)handleStartDateBtn{
    if( [_startDate compare:_date]==NSOrderedSame ){
        //当前为今天。则修改为昨天
        _startDate = [NSDate dateByAddDays:-1 toDate:_date];
    }else{
        _startDate = _date;
    }
    [self updateDateBtnTitleWithDate:_startDate isStartBtn:YES];
    [self updateTimeIntervalText];
}

- (void)handleEndDateBtn{
    if( [_endDate compare:_date]==NSOrderedSame ){
        //当前为今天。则修改为昨天
        _endDate = [NSDate dateByAddDays:-1 toDate:_date];
    }else{
        _endDate = _date;
    }
    
    [self updateDateBtnTitleWithDate:_endDate isStartBtn:NO];
    [self updateTimeIntervalText];
}

- (void)handleCaldenlerBtn{
    //确定
    if( [self validateData] ){

        [self addTimeRecord];
    }
}

- (void)handleBack{
    OLScheduleCtrl *sc = (OLScheduleCtrl*)[self getCtrlAtNavigationCtrlsWithCtrlClass:[OLScheduleCtrl class]];
    [sc reloadData];
    [self.navigationController popToViewController:sc animated:YES];
}

#pragma mark - ☸getter and setter
#pragma mark - 🔄overwrite

@end
