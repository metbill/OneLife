//
//  OLScheduleCtrl.m
//  OneLife
//
//  Created by wkun on 2017/10/21.
//  Copyright © 2017年 wkun. All rights reserved.
//

#import "OLScheduleCtrl.h"
#import "UIColor+Ext.h"
#import "UITabBarController+Ext.h"
#import "UINavigationController+Ext.h"
#import "UIViewController+Ext.h"
#import "KSegmentView.h"
#import "OLTargetCtrl.h"
#import "OLCalendarView.h"
#import "OLScheduleCell.h"
#import "OLScheduleModel.h"
#import "OLScheduleDataModel.h"
#import "OLRecordTimeCell.h"
#import "OLRecordTimeModel.h"
#import "OLAddScheduleCtrl.h"
#import "OLAddRecordCtrl.h"

@interface OLScheduleCtrl ()<KSegmentViewDelegate,UITableViewDelegate,UITableViewDataSource,OLCalendarViewDelegate>

@property (nonatomic, strong) KSegmentView *segmentView;
@property (nonatomic, strong) OLCalendarView *calendarView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *recordTimeDatas;
@property (nonatomic, strong) OLScheduleData *scheduleData;
@end

@implementation OLScheduleCtrl

#pragma mark - ViewLifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configSelf];
    
    [self addLeftBarItemWithAction:@selector(handleLeftItem) title:@"目标" textColor:[UIColor colorWithRgb16]];
    self.navigationItem.titleView = self.segmentView;
    
    [self loadDatas];
    
    [self addBtnViews];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

#pragma mark - LoadDatas

- (void)loadDatas{
    if( self.segmentView.seletedItemIndex ==0 ){
        [self loadScheduleDatas];
    }else{
        [self loadRecordDatas];
    }
}

- (void)loadScheduleDatas{
    NSMutableArray *arr = [NSMutableArray new];
    NSArray *dates = @[@"2017-10-25",@"2017-10-26",@"2017-10-27",@"2017-10-28",@"2017-10-29",@"2017-10-26"];
    NSArray *cnts = @[@"吃饭",@"喝水",@"睡觉",@"打豆豆",@"都都是谁"];
    for( NSUInteger i=0;i <5; i++ ){
        
        OLScheduleDataModel *dm = [OLScheduleDataModel new];
        dm.startDate = dates[i];
        
        OLScheduleModel *sm = [OLScheduleModel new];
        sm.scheduleStatus = OLScheduleStatusTobeDone;
        sm.scheduleContent = cnts[i];//@"去奥林匹克骑行";
        if( i%2==0 ){
            sm.remark = @"已延期5天";
            sm.scheduleStatus = OLScheduleStatusCompleted;
            sm.isDelayed = YES;
        }
        sm.dm = dm;
        [arr addObject:sm];
    }
    OLScheduleData *sd = [OLScheduleData new];
    sd.datas = arr;
    _scheduleData = sd;
    [self.tableView reloadData];
}

- (void)loadRecordDatas{
    _recordTimeDatas =
    [self.dataProcess recordDataWithDate:self.calendarView.currDate];
    [self.tableView reloadData];
    return;
    NSMutableArray *arr = [NSMutableArray new];
    NSArray *dates = @[@"6:00-7:00",@"7:25-9:00",@"9:50-10:20",@"10:25-11:00",@"11:25-15:00"];
    NSArray *cnts = @[@"吃饭",@"喝水",@"睡觉",@"打豆豆",@"都都是谁"];
    for( NSUInteger i=0;i <5; i++ ){
        
        OLRecordTimeModel *sm = [OLRecordTimeModel new];
        sm.time = dates[i];
        sm.content = cnts[i];//@"去奥林匹克骑行";
//        sm.howlong = @"1h5min";
        [arr addObject:sm];
    }
    _recordTimeDatas = arr;
    [self.tableView reloadData];
}
#pragma mark - Public

- (void)reloadData{
    [self loadDatas];
}

#pragma mark - Private
- (BOOL)isShowRecord{
    return
    self.segmentView.seletedItemIndex == 1;
}

- (void)addBtnViews{
    CGFloat iRight = 25;
    CGFloat wh = 44;
    CGFloat iy = SCREEN_HEIGHT-TABBAR_VIWE_HEIGHT-wh-15;
    UIButton *recordBtn =
    [self getNewBtnWithBgColor:[UIColor whiteColor] titleColor:[UIColor colorWithRgb153] action:@selector(handleAddSchedule) frame:CGRectMake(SCREEN_WIDTH-iRight-wh, iy, wh, wh)];
    recordBtn.layer.borderColor = [UIColor colorWithRgb153].CGColor;
    recordBtn.layer.borderWidth = 1;
    
    [self getNewBtnWithBgColor:[UIColor colorWithRgb_229_28_35] titleColor:[UIColor whiteColor] action:@selector(handleAddRecord) frame:CGRectMake(SCREEN_WIDTH-2*iRight-2*wh, iy, wh, wh)];
    
    
}

- (UIButton*)getNewBtnWithBgColor:(UIColor*)bgColor
                  titleColor:(UIColor*)tColor
                      action:(SEL)action
                       frame:(CGRect)fr{
    UIButton *btn = [UIButton new];
    btn.frame = fr;
    [btn cornerRadius:fr.size.width/2];
    btn.backgroundColor = bgColor;
    [btn setTitle:@"+" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:18];
    [btn setTitleColor:tColor forState:UIControlStateNormal];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    return btn;
}

- (void)pushCtrl:(UIViewController*)ctrl{
    ctrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ctrl animated:YES];
}

#pragma mark - TouchEvents

- (void)handleLeftItem{
    [self pushCtrl:[OLTargetCtrl new]];
}

- (void)handleAddRecord{
    OLAddRecordCtrl *rc = [OLAddRecordCtrl new];
    rc.date = self.calendarView.currDate;
    [self pushCtrl:rc];
}

- (void)handleAddSchedule{
    OLAddScheduleCtrl *sc = [OLAddScheduleCtrl new];
    sc.date = self.calendarView.currDate;
    [self pushCtrl:sc];
}

#pragma mark - KSegmentViewDelegate

- (void)segmentView:(KSegmentView *)segmentView didSelectItemAtIndex:(NSUInteger)index{

    [self loadDatas];
}

#pragma mark - OLCalendarViewDelegate
- (void)calendar:(OLCalendarView *)ctrl didSelectDate:(NSDate *)date{
    [self loadDatas];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if( [self isShowRecord] )
        return _recordTimeDatas.count;
    return _scheduleData.datas.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if( [self isShowRecord] ){
        static NSString *reuseid = @"recordcellreuseid";
        OLRecordTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseid];
        if( !cell ){
            cell = [[OLRecordTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseid];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.model = (OLRecordTimeModel*)[self modelAtIndex:indexPath.row datas:_recordTimeDatas modelClass:[OLRecordTimeModel class]];
        return cell;
    }
    
    static NSString *reuseid = @"reuseid";
    OLScheduleCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseid];
    if( !cell ){
        cell = [[OLScheduleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseid];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.model = (OLScheduleModel*)[self modelAtIndex:indexPath.row datas:_scheduleData.datas modelClass:[OLScheduleModel class]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if([self isShowRecord]){
        OLRecordTimeCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//        cell->_timeIntevalL.hidden = !cell->_timeIntevalL.isHidden;
    }
    else{
        OLScheduleCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        OLScheduleStatus status = cell.model.scheduleStatus;
        OLScheduleStatus toStatus = (status==OLScheduleStatusTobeDone)?OLScheduleStatusCompleted:OLScheduleStatusTobeDone;
        
        [_scheduleData updateModelStatus:toStatus atIndex:indexPath.row];
        [tableView reloadData];
    }
}

#pragma mark - Propertys
-(KSegmentView*)segmentView{
    if( !_segmentView ){
        _segmentView = [[KSegmentView alloc] initWithFrame:CGRectMake(0, 0, 180, 30) titles:@[@"日程",@"记录"]];
        _segmentView.defalutSelctIndex = 0;
        _segmentView.delegate = self;
    }
    return _segmentView;
}

- (OLCalendarView *)calendarView {
    if( !_calendarView ){
        _calendarView = [OLCalendarView new];
        _calendarView.frame = CGRectMake(0, NAVGATION_VIEW_HEIGHT, self.view.width, 75);
        _calendarView.clipsToBounds = YES;
        _calendarView.delegate = self;
        [self.view addSubview:_calendarView];
        
        UIView *line = [UIView new];
        CGFloat ih =0.5;
        line.frame = CGRectMake(0, _calendarView.height-ih, _calendarView.width, ih);
        line.backgroundColor = [UIColor colorWithRgb221];
        [_calendarView addSubview:line];
    }
    return _calendarView;
}

- (UITableView *)tableView {
    if( !_tableView ){
        _tableView = [[UITableView alloc] init];
        CGFloat iy = self.calendarView.bottom;
        CGFloat ih = SCREEN_HEIGHT-iy-TABBAR_VIWE_HEIGHT;
        _tableView.frame = CGRectMake(0, iy, SCREEN_WIDTH, ih);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = self.view.backgroundColor;
        
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

@end

@implementation OLScheduleCtrl(RootCtrl)

#pragma mark - RootViewController

+ (UIViewController *)getRootCtrl{
    UITabBarController *tabbar = [UITabBarController new];
    NSArray *ctrls = @[[self naviCtrlWithRootCtrlName:@"OLScheduleCtrl"],
                       [self naviCtrlWithRootCtrlName:@"OLStatisticsCtrl"],
                       [self naviCtrlWithRootCtrlName:@"OLMeCtrl"]];
    NSArray *titles = @[@"日程",@"统计",@"我的"];
    NSArray *niNames = @[@"tabbar_schedule",@"tabbar_statistics",@"tabbar_me"];
    NSArray *siNames = @[@"tabbar_schedule_s",@"tabbar_statistics_s",@"tabbar_me_s"];
    [tabbar configTabbarWithCtrls:ctrls titles:titles
                 selectedImgNames:siNames
                   normalImgNames:niNames
                        textColor:[UIColor colorWithRgb16]
                 selctedTextColor:[UIColor colorWithRgb_229_28_35]];
    
    tabbar.tabBar.barTintColor = [UIColor colorWithRgb248];
    
    return tabbar;
}

+ (UINavigationController*)naviCtrlWithRootCtrlName:(NSString*)cn{
    if( [cn isKindOfClass:[NSString class]] ){
        UIViewController *ctrl = [NSClassFromString(cn) new];
        if( [ctrl isKindOfClass:[UIViewController class]] ){
            UINavigationController *naviCtrl =
            [[UINavigationController alloc] initWithRootViewController:ctrl];
            [naviCtrl configNavigationCtrl];
            [naviCtrl setNavigationBarBgClear];
            return naviCtrl;
        }
    }
    return [UINavigationController new];
}


@end


@implementation OLScheduleData{
    NSMutableArray *_tobedoneDatas;  //未完成事项
    NSMutableArray *_completedDatas; //已完成事项
}

- (id)init{
    self = [super init];
    if( self ){
        _firstIndexForUnfinishSchedule = -1;
        _tobedoneDatas = [NSMutableArray new];
        _completedDatas = [NSMutableArray new];
    }
    return self;
}

/**
 更新某model的状态，并重新排序datas数据

 @param status 目标状态
 @param index model在datas的索引
 */
- (void)updateModelStatus:(OLScheduleStatus)status atIndex:(NSUInteger)index{
    if( index < _datas.count ){
        OLScheduleModel *sm = _datas[index];
        sm.scheduleStatus = status;
        
        if( status == OLScheduleStatusCompleted ){
            //修改为已完成。则原Model应存在 _tobedoneDatas 中,移除
            if( [_tobedoneDatas containsObject:sm]){
                [_tobedoneDatas removeObject:sm];
            }
            
            //将该Model，按时间顺序，插入 _completedDatas，
            [self insertModel:sm toDatas:_completedDatas];
            
        }else{
            if( [_completedDatas containsObject:sm] ){
                [_completedDatas removeObject:sm];
            }
            //将该Model，按时间顺序，插入 _completedDatas，
            [self insertModel:sm toDatas:_tobedoneDatas];
        }
    }
    [self updateDatas];
}

- (void)setDatas:(NSArray *)datas{
    [self updateTobedoneDatasAndCompleteDatasWithDatas:datas];
    [self updateDatas];
}

#pragma mark - private

- (void)updateTobedoneDatasAndCompleteDatasWithDatas:(NSArray*)datas{
    [_completedDatas removeAllObjects];
    [_tobedoneDatas removeAllObjects];
    for( OLScheduleModel *sm in datas ){
        if( sm.scheduleStatus == OLScheduleStatusCompleted ){
            [self insertModel:sm toDatas:_completedDatas];
        }
        else {
            [self insertModel:sm toDatas:_tobedoneDatas];
        }
    }
}

- (void)updateDatas{
    NSMutableArray *newDatas = [NSMutableArray new];
    if( _tobedoneDatas.count )
        [newDatas addObjectsFromArray:_tobedoneDatas];
    if( _completedDatas.count )
        [newDatas addObjectsFromArray:_completedDatas];
    _datas = newDatas;
}

/**
 按日程的开始时间，将model插入相应的数据中

 @param sm 将要插入的model
 @param datas 目标数组
 */
- (void)insertModel:(OLScheduleModel*)sm toDatas:(NSMutableArray*)datas{
   
    if( !sm || !datas) return;
    
    NSUInteger j = 0;
    for( NSUInteger i=0; i<datas.count; i++ ){
        OLScheduleModel *model  = datas[i];
        j=i;
        if( [sm compare:model] == NSOrderedAscending ){
            break;
        }
    }
    if( datas.count ==0 ){
        [datas addObject:sm];
    }else
        [datas insertObject:sm atIndex:j];
}

@end
