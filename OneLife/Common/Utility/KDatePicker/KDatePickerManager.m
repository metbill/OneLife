//
//  KDatePickerManager.m
//  Hitu
//
//  Created by hitomedia on 2017/7/19.
//  Copyright © 2017年 hitomedia. All rights reserved.
//

#import "KDatePickerManager.h"
#import "KDatePicker.h"

static CGFloat const gAnimateTime = 0.4;
#define XW_APV_SURE_BTN_TAG        100
#define XW_APV_CANCLE_BTN_TAG      101
@interface KDatePickerManager()

@property (nonatomic, strong) UIView       *bgView;
@property (nonatomic, strong) UIButton     *sureBtn;
@property (nonatomic, strong) UIButton     *cancleBtn;
@property (nonatomic, strong) UILabel      *titleL;
@property (nonatomic, strong) NSDate       *beginDate;
@property (nonatomic, strong) NSDate       *endDate;

@end

@implementation KDatePickerManager{
    KDatePicker *_datePicker;
    void(^_completeBlock)(NSDate *selctedDate);
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if( self ){
        [self initData];
    }
    return self;
}

- (void)initData{
    
    self.beginDate = [NSDate date];
    //不算今天，往后29天。
    self.endDate = [NSDate dateWithTimeIntervalSinceNow:29*24*60*60];

    CGSize size = [UIScreen mainScreen].bounds.size;
    self.frame = CGRectMake(0, 0, size.width, size.height);
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    self.alpha = 0.0;
    
    _datePicker = [[KDatePicker alloc] init];
    _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    _datePicker.currDate = self.beginDate;//[NSDate dateWithTimeIntervalSinceNow:24*60*60];
    _datePicker.minimumDate = self.beginDate;
    _datePicker.maximumDate = self.endDate;

    _datePicker.frame = CGRectMake(0, CGRectGetMaxY(self.sureBtn.frame), size.width, 190);
    [self.bgView addSubview:_datePicker];
    
    UILabel *titleL = [[UILabel alloc] init];
    CGFloat ix = CGRectGetMaxX(self.cancleBtn.frame);
    titleL.frame = CGRectMake(ix, 0, (size.width-2*ix), _cancleBtn.frame.size.height);
    titleL.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    titleL.font = [UIFont systemFontOfSize:15];
    titleL.textAlignment = NSTextAlignmentCenter;
    [self.bgView addSubview:titleL];
    _titleL = titleL;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleBgView:)];
    [self addGestureRecognizer:tap];
}


+ (KDatePickerManager*)shareDatePickerManager{
    static KDatePickerManager *kpm = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGRect fr = [UIScreen mainScreen].bounds;
        kpm = [[KDatePickerManager alloc] initWithFrame:CGRectMake(0, 0, fr.size.width, fr.size.height)];
    });
    return kpm;
}

+ (void)showDatePickerWithSelectDateBlock:(void (^)(NSDate *))selectDateBlock{
    [[KDatePickerManager shareDatePickerManager] showWithSelectDateBlock:selectDateBlock];
}

#pragma mark - Private

- (void)showWithSelectDateBlock:(void (^)(NSDate *))selectDateBlock{
    _completeBlock = selectDateBlock;

    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:gAnimateTime animations:^{
        CGRect fr = self.bgView.frame;
        fr.origin.y = CGRectGetHeight(self.frame)-CGRectGetHeight(_bgView.frame);
        self.bgView.frame = fr;
        self.alpha = 1.0;
    }];
}

- (void)hide{
    
    [UIView animateWithDuration:gAnimateTime animations:^{
        CGRect fr = self.bgView.frame;
        fr.origin.y = CGRectGetHeight(self.frame);
        self.bgView.frame = fr;
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        _completeBlock = nil;
    }];
}

- (void)configBtn:(UIButton*)btn{
    if( btn ){
        [btn setTitleColor:[UIColor colorWithRed:24/255.0 green:148/255.0 blue:209/255.0 alpha:1.0]
                  forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:100/255.0 green:140/255.0 blue:159/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        
        btn.backgroundColor = [UIColor clearColor];
        [btn addTarget:self action:@selector(handleBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark - TouchEvent

- (void)handleBgView:(UITapGestureRecognizer*)ges{
    [self hide];
}

- (void)handleBtn:(UIButton*)btn{

    if( _completeBlock ){
        
        _completeBlock(_datePicker.currDate);
    }
    
    [self hide];
}


#pragma mark - Propertys

- (UIButton *)cancleBtn {
    if( !_cancleBtn ){
        _cancleBtn = [[UIButton alloc] init];
        [_cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
//        _cancleBtn.tag = XW_APV_CANCLE_BTN_TAG;
        _cancleBtn.frame = CGRectMake(0, 0, 70, 40);
        [self configBtn:_cancleBtn];
        [self.bgView addSubview:_cancleBtn];
        [_cancleBtn setTitleColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0] forState:UIControlStateNormal];
    }
    return _cancleBtn;
}

- (UIButton *)sureBtn {
    if( !_sureBtn ){
        _sureBtn = [[UIButton alloc] init];
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
//        _sureBtn.tag = XW_APV_SURE_BTN_TAG;
        CGFloat iw = self.cancleBtn.frame.size.width;
        _sureBtn.frame = CGRectMake(CGRectGetWidth(self.frame)-iw, CGRectGetMinY(self.cancleBtn.frame), iw, self.cancleBtn.frame.size.height);
        [self configBtn:_sureBtn];
        
        [self.bgView addSubview:_sureBtn];
    }
    return _sureBtn;
}

- (UIView*)bgView {
    if( !_bgView ){
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.frame = CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), 190+40);
        
        [self addSubview:_bgView];
    }
    return _bgView;
}


@end
